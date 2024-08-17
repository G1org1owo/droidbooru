import 'package:flutter/material.dart';

import '../model/base/post.dart';

class PostDetail extends StatelessWidget {
  final Post _post;
  final Map<String, dynamic> _ctx;
  const PostDetail(this._post, this._ctx, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${_ctx['index']}/${_ctx['totalPosts']}"),
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