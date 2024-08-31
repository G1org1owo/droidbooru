import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../model/base/post.dart';
import 'post_container.dart';

class PostList extends StatelessWidget {
  final List<Post> _posts;
  final Future<bool> Function(int)? _onIndexUpdate;

  final ItemPositionsListener? _itemPositionsListener;
  final ItemScrollController _controller = ItemScrollController();

  PostList(this._posts, {ItemPositionsListener? itemPositionsListener,
    Future<bool> Function(int)? onIndexUpdate, super.key}) :
      _itemPositionsListener = itemPositionsListener,
      _onIndexUpdate = onIndexUpdate;

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
      onIndexUpdate: _onIndexUpdate,
      onExit: (index) => _controller.jumpTo(index: index),
    );
  }
}