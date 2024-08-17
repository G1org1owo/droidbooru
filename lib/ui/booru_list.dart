import 'package:flutter/material.dart';

import '../model/base/booru.dart';
import 'booru_container.dart';

class BooruList extends StatefulWidget {
  final List<Booru> _boorus;

  const BooruList(this._boorus, {super.key});

  @override
  State<StatefulWidget> createState() => _BooruListState();
}

class _BooruListState extends State<BooruList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: widget._boorus.map((booru) => SizedBox(
        height: 150,
        child: BooruContainer(booru),
      )).toList(),
    );
  }
}