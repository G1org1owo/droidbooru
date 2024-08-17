import 'dart:developer';

import 'package:flutter/material.dart';

import 'model/base/booru.dart';
import 'model/base/booru_deserializer.dart';
import 'model/booru_context.dart';
import 'model/moebooru/moe_booru.dart';
import 'ui/booru_list.dart';

void main() {
  // This sucks and it defeates the whole purpose of creating an interface,
  // but this framework sucks and won't let me use reflection nor annotations
  BooruDeserializer("moebooru", Moebooru.fromUrl);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Droidbooru',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Droidbooru'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BooruList(_boorus),
      floatingActionButton: FloatingActionButton(
          onPressed: loadBoorus,
      ),
    );
  }
}