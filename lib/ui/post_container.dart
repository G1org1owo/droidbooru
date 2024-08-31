import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/base/post.dart';
import 'post_detail.dart';

class PostContainer extends StatelessWidget {
  final List<Post> _posts;
  final int _index;
  final BoxFit _fit;
  final void Function(int)? _onExit;
  final Future<bool> Function(int)? _onIndexUpdate;

  const PostContainer({required List<Post> posts, int index = 0,
    BoxFit fit = BoxFit.fill, void Function(int)? onExit,
    Future<bool> Function(int)? onIndexUpdate, super.key}) :
      _posts = posts,
      _index = index,
      _fit = fit,
      _onExit = onExit,
      _onIndexUpdate = onIndexUpdate;

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
            onIndexUpdate: _onIndexUpdate,
          )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: FadeInImage.memoryNetwork(
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 100),
          placeholder: kTransparentImage,
          image: _post.previewUrl,
          fit: _fit,
        ),
      ),
    );
  }
}