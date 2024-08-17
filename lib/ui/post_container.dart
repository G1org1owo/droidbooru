import 'package:flutter/material.dart';

import '../model/base/post.dart';
import 'post_detail.dart';

class PostContainer extends StatelessWidget {
  final Post _post;
  const PostContainer(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostDetail(_post)),
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