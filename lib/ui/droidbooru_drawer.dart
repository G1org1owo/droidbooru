import 'package:flutter/material.dart';

class DroidbooruDrawer extends StatelessWidget {
  const DroidbooruDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              _navigate(context, 'home');
            },
          ),
          ListTile(
            title: const Text("Servers"),
            onTap: () {
              Navigator.pop(context);
              _navigate(context, 'servers');
            },
          ),
        ],
      ),
    );
  }

  _navigate(BuildContext context, String route) {
    if(ModalRoute.of(context)!.settings.name! == route) return;

    Navigator.restorablePushReplacementNamed(context, route);
  }
}