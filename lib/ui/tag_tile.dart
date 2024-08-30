import 'package:flutter/material.dart';

import '../model/base/tag.dart';
import '../model/base/tag_type.dart';
import 'text_tile.dart';

class TagTile extends StatelessWidget {
  final Tag _tag;
  const TagTile(this._tag, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: add tag search on tap
    return TextTile(
      _tag.name,
      color: switch(_tag.type) {
        TagType.copyright => Colors.purpleAccent,
        TagType.character => Colors.greenAccent,
        TagType.artist => Colors.redAccent,
        TagType.meta => Colors.pinkAccent,
        TagType.general => null,
      },
    );
  }
}