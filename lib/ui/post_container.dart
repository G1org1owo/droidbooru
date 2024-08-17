import 'package:flutter/material.dart';

import '../model/base/post.dart';
import 'post_detail.dart';

class PostContainer extends StatelessWidget {
  final List<Post> _posts;
  final int _index;
  final void Function(int)? _onExit;

  const PostContainer({required List<Post> posts, int index = 0,
    void Function(int)? onExit, super.key}) :
        _posts = posts,
        _index = index,
        _onExit = onExit;

  Post get _post => _posts[_index];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetail(
              posts: _posts,
              index: _index,
              onExit: _onExit,
          )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Image.network(
          _post.previewUrl,
          fit: BoxFit.fill,
        ),
      )
    );
  }
}