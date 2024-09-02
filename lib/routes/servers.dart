import 'package:flutter/material.dart' hide NavigationDrawer;

import '../model/base/booru.dart';
import '../db/booru_context.dart';
import '../ui/drawers/navigation_drawer.dart';
import '../ui/details/server_detail.dart';

class ServersPage extends StatefulWidget {
  const ServersPage({super.key});

  @override
  State<StatefulWidget> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  final List<Booru> _servers = [];
  final BooruContext _ctx = BooruContext();

  void loadServers() async {
    List<Booru> boorus = await _ctx.readAll();
    setState(() {
      _servers.clear();
      _servers.addAll(boorus);
    });
  }

  @override
  void initState() {
    super.initState();
    loadServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Servers"),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final MenuController menuController = MenuController();
          return MenuAnchor(
            controller: menuController,
            style: const MenuStyle(
              alignment: Alignment.topRight,
            ),
            alignmentOffset: const Offset(0, 0),
            menuChildren: [
              MenuItemButton(
                child: const Text('Edit'),
                onPressed: () => _updateServer(context, index),
              ),
              MenuItemButton(
                child: const Text('Remove'),
                onPressed: () {
                  late Booru server;
                  setState(() {
                    server = _servers.removeAt(index);
                  });
                  _ctx.delete(server);
                },
              ),
            ],
            child: ListTile(
              onLongPress: () {
                menuController.open();
              },
              title: Text(_servers[index].url.origin),
              subtitle: const Text("idk"),
            ),
          );
        },
        itemCount: _servers.length,
      ),
      drawer: const NavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addServer(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _addServer(BuildContext context) async {
    Booru? newServer = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ServerDetail())
    );

    if(newServer != null) {
      setState(() {
        _servers.add(newServer);
      });
    }
  }
  void _updateServer(BuildContext context, index) async {
    Booru? updatedServer = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ServerDetail(
            server: _servers[index]
        ))
    );

    if(updatedServer != null) {
      setState(() {
        _servers[index] = updatedServer;
      });
    }
  }
}