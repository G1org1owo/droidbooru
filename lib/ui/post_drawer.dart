import 'package:flutter/material.dart';

import '../model/base/post.dart';

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
          ..._source(),
          const Divider(
            color: Colors.white,
          ),
          ..._url(),
          const Divider(
            color: Colors.white,
          ),
          ..._other(),
          const Divider(
            color: Colors.white,
          ),
          ..._tags(),
          const Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  List<Widget> _source() => [
    const TextTile(
      "Source",
      enabled: false,
    ),
    TextTile(
        _post.source
    ),
  ];
  List<Widget> _url() => [
    const TextTile(
      "Url",
      enabled: false,
    ),
    TextTile(
        _post.url,
    ),
  ];
  List<Widget> _other() => [
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
  List<Widget> _tags() => [
    const TextTile(
      "Tags",
      enabled: false,
    ),
    ..._post.tags.map((tag) => TextTile(tag.name)),
  ];
}

class TextTile extends StatelessWidget {
  final String _text;
  final bool _enabled;

  const TextTile(this._text, {bool enabled=true, super.key}) :
    _enabled = enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _text,
        style: const TextStyle(
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      enabled: _enabled,
    );
  }
}