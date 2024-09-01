import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

import '../../model/base/post.dart';
import 'loadable_post_list_mixin.dart';
import 'post_container.dart';

class PostGrid extends StatelessWidget with LoadablePostList {
  final List<Post> _posts;
  final Future<void> Function() _loadNewPosts;

  final Mutex _mutex = Mutex();

  PostGrid(this._posts,
      {required Future<void> Function() loadNewPosts, super.key})
      : _loadNewPosts = loadNewPosts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
      ),
      itemBuilder: _postBuilder,
    );
  }

  Widget _postBuilder(BuildContext context, int index) {
    return PostContainer(
      posts: _posts,
      index: index,
      fit: BoxFit.cover,
      onIndexUpdate: (index) =>
          loadIfLast(index, snackBar: true, context: context),
    );
  }

  @override
  Mutex get mutex => _mutex;

  @override
  List<Post> get posts => _posts;

  @override
  Future<void> loadNewPosts() => _loadNewPosts();
}