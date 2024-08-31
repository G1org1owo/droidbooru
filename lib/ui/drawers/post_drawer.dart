import 'package:flutter/material.dart';

import '../../model/base/post.dart';
import '../components/tag_tile.dart';
import '../components/text_tile.dart';

class PostDrawer extends StatelessWidget {
  final Post _post;

  const PostDrawer(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 330,
      // TODO: add on tap redirects etc
      child: ListView(
        children: [
          const Divider(
            color: Colors.white,
          ),
          ..._buildSource(),
          const Divider(
            color: Colors.white,
          ),
          ..._buildUrl(),
          const Divider(
            color: Colors.white,
          ),
          ..._buildOther(),
          const Divider(
            color: Colors.white,
          ),
          ..._buildTags(),
          const Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSource() => [
    const TextTile(
      "Source",
      enabled: false,
    ),
    TextTile(
        _post.source
    ),
  ];
  List<Widget> _buildUrl() => [
    const TextTile(
      "Url",
      enabled: false,
    ),
    TextTile(
        _post.url,
    ),
  ];
  List<Widget> _buildOther() => [
    const TextTile(
      "Other",
      enabled: false,
    ),
    TextTile(
      "Id: ${_post.id}",
    ),
    TextTile(
      "Score: ${_post.score}",
    ),
    TextTile(
      "Rating: ${_post.rating}",
    ),
    TextTile(
      "Child posts: ${_post.hasChildren}",
    ),
    TextTile(
      "Parent id: ${_post.parentId}",
    ),
    TextTile(
      "MD5: ${_post.md5}",
    ),
  ];
  List<Widget> _buildTags() => [
    const TextTile(
      "Tags",
      enabled: false,
    ),
    ...(_post.tags..sort()).map((tag) => TagTile(tag)),
  ];
}