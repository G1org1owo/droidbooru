import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  final String _text;
  final bool _enabled;
  final Color? _color;

  const TextTile(this._text, {bool enabled=true, Color? color, super.key}) :
        _enabled = enabled,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _text,
        style: const TextStyle(
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      enabled: _enabled,
      textColor: _color,
    );
  }
}