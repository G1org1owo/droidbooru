import 'package:flutter/material.dart';

import '../../model/base/booru.dart';
import 'booru_container.dart';

class BooruList extends StatefulWidget {
  final List<Booru> _boorus;
  final List<String> _tags;

  const BooruList(this._boorus, {List<String> tags = const [], super.key}) :
    _tags = tags;

  @override
  State<StatefulWidget> createState() => _BooruListState();
}

class _BooruListState extends State<BooruList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: widget._boorus.map((booru) => BooruContainer(
        booru,
        tags: widget._tags,)
      ).toList(),
    );
  }
}