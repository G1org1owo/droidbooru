import 'package:flutter/material.dart';

import '../../model/base/booru.dart';
import '../../model/base/post.dart';
import '../components/text_tile.dart';
import '../containers/post_grid.dart';

class BooruDetail extends StatefulWidget {
  final Booru _booru;
  final List<Post> _posts;
  final List<String> _tags;
  final Future<void> Function() _loadNewPosts;

  const BooruDetail(this._booru, this._posts,
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
        title: _makeTitle(),
      ),
      body: PostGrid(
        widget._posts,
        loadNewPosts: () => widget._loadNewPosts(),
      ),
    );
  }

  Widget _makeTitle() {
    String title = widget._tags.join(' ');

    if(title.isEmpty) title = "All Posts";

    return TextTile(
      title,
      subtitle: widget._booru.url.toString(),
      textSize: 20,
    );
  }
}
