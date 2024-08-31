import 'package:flutter/cupertino.dart';

import '../../model/base/post.dart';
import 'post_container.dart';

class PostGrid extends StatelessWidget {
  final List<Post> _posts;
  final Future<bool> Function(int)? _onIndexUpdate;

  const PostGrid(this._posts, {Future<bool> Function(int)? onIndexUpdate,
    super.key}) :
      _onIndexUpdate = onIndexUpdate;

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
      onIndexUpdate: _onIndexUpdate,
    );
  }
}