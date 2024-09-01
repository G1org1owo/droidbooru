import 'package:flutter/material.dart' hide NavigationDrawer;

import '../model/base/booru.dart';
import '../db/booru_context.dart';
import '../ui/containers/booru_list.dart';
import '../ui/drawers/navigation_drawer.dart';
import '../ui/drawers/search_bottom_sheet.dart';
import '../ui/components/weighted_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _tags = [];
  final List<Booru> _boorus = [];
  final BooruContext _ctx = BooruContext();

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
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              List<String>? newTags = await showModalBottomSheet(
                  context: context,
                  builder: (context) => SearchBottomSheet(tags: _tags),
              );

              if(newTags == null) return;

              setState(() {
                _tags = newTags;
              });
            },
            icon: const WeightedIcon(
              Icons.search_rounded,
              iconSize: 30,
              iconWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      body: BooruList(_boorus, tags: _tags),
      drawer: const NavigationDrawer(),
    );
  }
}