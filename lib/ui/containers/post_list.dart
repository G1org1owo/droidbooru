import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../model/base/post.dart';
import 'loadable_post_list_mixin.dart';
import 'post_container.dart';

class PostList extends StatelessWidget with LoadablePostList {
  final List<Post> _posts;
  final Future<void> Function() _loadNewPosts;
  final Mutex _mutex = Mutex();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  final ItemScrollController _controller = ItemScrollController();

  PostList(this._posts,
      {required Future<void> Function() loadNewPosts, super.key})
      : _loadNewPosts = loadNewPosts {
    _itemPositionsListener.itemPositions.addListener(_onPositionUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      scrollDirection: Axis.horizontal,
      itemScrollController: _controller,
      itemPositionsListener: _itemPositionsListener,
      itemCount: _posts.length,
      itemBuilder: _postBuilder,
      shrinkWrap: true,
    );
  }

  Widget _postBuilder(BuildContext context, int index) {
    return PostContainer(
      posts: _posts,
      index: index,
      onIndexUpdate: (index) =>
          loadIfLast(index, snackBar: true, context: context),
      onExit: (index) => _controller.jumpTo(index: index),
    );
  }

  void _onPositionUpdate() async {
    final positions = _itemPositionsListener.itemPositions.value;
    final lastVisibleItem = positions.reduce(
        (last, position) => last.index > position.index ? last : position);

    loadIfLast(lastVisibleItem.index);
  }

  @override
  Mutex get mutex => _mutex;

  @override
  List<Post> get posts => _posts;

  @override
  Future<void> loadNewPosts() => _loadNewPosts();
}