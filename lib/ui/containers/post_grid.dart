import 'package:flutter/material.dart';

import '../../model/base/post.dart';
import 'loadable_post_list_mixin.dart';
import 'post_container.dart';

class PostGrid extends StatefulWidget {
  final List<Post> _posts;
  final Future<void> Function() _loadNewPosts;

  const PostGrid(this._posts,
      {required Future<void> Function() loadNewPosts, super.key})
      : _loadNewPosts = loadNewPosts;

  @override
  State<StatefulWidget> createState() => _PostGridState();
}

class _PostGridState extends State<PostGrid> with LoadablePostList {
  late final ScrollController _controller;

  static const double _maxCrossAxisExtent = 150.0;
  static const double _mainAxisSpacing = 5;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      onAttach: _onScrollAttach,
      onDetach: _onScrollDetach,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: posts.length,
      controller: _controller,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: _maxCrossAxisExtent,
        mainAxisSpacing: _mainAxisSpacing,
      ),
      itemBuilder: _postBuilder,
    );
  }

  Widget _postBuilder(BuildContext context, int index) {
    return PostContainer(
      posts: posts,
      index: index,
      fit: BoxFit.cover,
      onIndexUpdate: (index) =>
          loadIfLast(index, snackBar: true, context: context),
      onExit: (index) => _controller.jumpTo(_firstPositionFromIndex(index)),
    );
  }

  void _onScrollAttach(ScrollPosition position) {
    position.addListener(_onPositionUpdate);
  }
  void _onScrollDetach(ScrollPosition position) {
    position.removeListener(_onPositionUpdate);
  }

  void _onPositionUpdate() async {
    final position = _controller.position;

    int lastVisiblePostIndex = _lastPostIndexFromPosition(position);

    await loadIfLast(lastVisiblePostIndex, snackBar: true, context: context);
  }

  int _lastPostIndexFromPosition(ScrollPosition position) {
    int lastVisibleRow = ((position.extentBefore + position.extentInside) /
        (postExtent + _mainAxisSpacing)).ceil();

    int lastVisiblePostIndex = lastVisibleRow * postsPerRow - 1;
    if(lastVisiblePostIndex > posts.length - 1) {
      lastVisiblePostIndex = posts.length - 1;
    }

    return lastVisiblePostIndex;
  }

  double _firstPositionFromIndex(int index) {
    int row = (index / postsPerRow).floor();

    return row * (postExtent + _mainAxisSpacing);
  }

  @override
  List<Post> get posts => widget._posts;

  @override
  Future<void> loadNewPosts() => widget._loadNewPosts().then((_) {
    setState(() { });
  });

  int get postsPerRow =>
      (MediaQuery.sizeOf(context).width / _maxCrossAxisExtent).ceil();

  double get postExtent => MediaQuery.sizeOf(context).width / postsPerRow;
}