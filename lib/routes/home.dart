import 'package:flutter/material.dart';

import '../model/base/booru.dart';
import '../model/booru_context.dart';
import '../ui/booru_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Booru> _boorus = [];
  final BooruContext _ctx = BooruContext.getContext();

  void loadBoorus() async {
    List<Booru> boorus = await _ctx.readAll();
    setState(() {
      _boorus.clear();
      _boorus.addAll(boorus);
    });
  }

  @override
  void initState() {
    super.initState();
    loadBoorus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BooruList(_boorus),
    );
  }
}