import 'package:flutter/material.dart';

import '../../model/base/post.dart';
import '../containers/post_grid.dart';

class BooruDetail extends StatefulWidget {
  final List<Post> _posts;
  final List<String> _tags;
  final Future<void> Function() _loadNewPosts;

  const BooruDetail(this._posts,
      {List<String> tags = const [],
      required Future<void> Function() loadNewPosts,
      super.key})
      : _loadNewPosts = loadNewPosts,
        _tags = tags;

  @override
  State<StatefulWidget> createState() => _BooruDetailState();
}

class _BooruDetailState extends State<BooruDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget._tags.join(' '),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PostGrid(
        widget._posts,
        loadNewPosts: () => widget._loadNewPosts().then((_) => setState(() {})),
      ),
    );
  }
}
