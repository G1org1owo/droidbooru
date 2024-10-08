import 'package:flutter/material.dart';

import '../../model/base/booru.dart';
import '../../model/base/booru_deserializer.dart';
import '../../db/booru_context.dart';

class ServerDetail extends StatelessWidget {
  final Booru? _server;
  ServerDetail({Booru? server, super.key}) :
    _server = server,
    _urlController = TextEditingController(text: server?.url.origin);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _booruTypeController = TextEditingController();
  final TextEditingController _urlController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Server"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              DropdownMenu<String>(
                dropdownMenuEntries: BooruDeserializer.keys.map((string) {
                  return DropdownMenuEntry(
                    value: string,
                    label: string,
                  );
                }).toList(),
                initialSelection: _server?.type ?? BooruDeserializer.keys.first,
                expandedInsets: const EdgeInsets.symmetric(vertical: 10.0),
                label: const Text("Type:"),
                controller: _booruTypeController,
              ),
              // TODO: add server verification
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Url:",
                  ),
                  validator: _validator,
                  controller: _urlController,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => _addServer(context),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validator(value) {
    RegExp regex = RegExp(
        "^http[s]?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\\.[a-z]{2,4}"
    );

    if(value == null || value.isEmpty ||
        regex.firstMatch(value) == null) {
      return "Please enter a valid url";
    }

    try {
      Uri.parse(value);
      return null;
    } on FormatException catch (e) {
      return e.message;
    }
  }

  void _addServer(BuildContext context) async {
    if(_formKey.currentState!.validate()) {
      String key = _booruTypeController.text;
      String url = _urlController.text;

      if((_server == null || _server.url.origin != url) && (await BooruContext().find(url)) != null &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server already exists!"),
          ),
        );
        return;
      }

      Booru newServer = BooruDeserializer.deserialize(key, url, id: _server?.id)!;
      newServer = await BooruContext().put(newServer);
      if(context.mounted) {
        Navigator.pop(context, newServer);
      }
    }
  }
}