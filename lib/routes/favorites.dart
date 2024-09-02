import 'package:flutter/material.dart' hide NavigationDrawer;

import '../db/favorites_context.dart';
import '../model/base/post.dart';
import '../ui/containers/post_grid.dart';
import '../ui/drawers/navigation_drawer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<StatefulWidget> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<Post> _posts = [];
  final FavoritesContext _favoritesContext = FavoritesContext();

  @override
  void initState() {
    super.initState();

    _favoritesContext.readAll().then((posts) =>
      setState(() {
        _posts.addAll(posts.reversed); // Show last added posts first
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Favorites"),
      ),
      body: PostGrid(_posts),
      drawer: const NavigationDrawer(),
    );
  }
}

