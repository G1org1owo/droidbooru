import 'package:flutter/material.dart';

// This has to extend a StatefulWidget or else it breaks and does all kinds of
// weird shit
class SearchBottomSheet extends StatefulWidget {
  final List<String> _tags;

  const SearchBottomSheet({List<String> tags = const [], super.key}) :
    _tags = tags;

  @override
  State<StatefulWidget> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget._tags.join(' '));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      //key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: const Text(
                "Search",
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Tags:"),
              ),
              controller: _controller,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () => _search(context),
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    List<String> tags = _controller.text.split(' ');
    Navigator.pop(context, tags);
  }

}