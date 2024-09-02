import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text("Home"),
            onTap: () {
              _navigate(context, 'home');
            },
          ),
          ListTile(
            title: const Text("Servers"),
            onTap: () {
              _navigate(context, 'servers');
            },
          ),
          ListTile(
            title: const Text("Favorites"),
            onTap: () {
              _navigate(context, 'favorites');
            },
          ),
        ],
      ),
    );
  }

  _navigate(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer

    if(ModalRoute.of(context)!.settings.name == route) return;

    if(route == 'home') {
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    if(ModalRoute.of(context)!.settings.name == 'home') {
      Navigator.pushNamed(context, route);
      return;
    }

    Navigator.pushReplacementNamed(context, route);
  }
}