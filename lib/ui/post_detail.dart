import 'package:flutter/material.dart';

import '../model/base/post.dart';

class PostDetail extends StatelessWidget {
  final Post _post;
  const PostDetail(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: Center(
          child: Image.network(_post.sampleUrl),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            }
        )
    );
  }
}