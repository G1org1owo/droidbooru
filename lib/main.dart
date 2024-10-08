import 'package:flutter/material.dart';

import 'model/base/booru_deserializer.dart';
import 'model/moebooru/moe_booru.dart';
import 'routes/favorites.dart';
import 'routes/home.dart';
import 'routes/servers.dart';

void main() {
  // This sucks and it defeates the whole purpose of creating an interface,
  // but this framework sucks and won't let me use reflection nor annotations
  BooruDeserializer("moebooru", Moebooru.fromUrl);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomePage(title: 'Droidbooru'),
        'servers': (context) => const ServersPage(),
        'favorites': (context) => const FavoritesPage(),
      },
    );
  }
}