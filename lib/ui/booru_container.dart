import 'package:flutter/material.dart';

import '../model/base/booru.dart';
import '../model/base/post.dart';
import 'post_container.dart';

class BooruContainer extends StatefulWidget {
  final Booru _booru;
  const BooruContainer(this._booru, {super.key});

  @override
  State<StatefulWidget> createState() => _BooruState();
}

class _BooruState extends State<BooruContainer> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    widget._booru.listPosts(0, 0, [])
        .then((posts) => updatePosts(posts));
  }

  void updatePosts(List<Post> posts) => setState(() => _posts = posts);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _posts.map((post) => PostContainer(post)).toList(),
      ),
    );
  }
}
