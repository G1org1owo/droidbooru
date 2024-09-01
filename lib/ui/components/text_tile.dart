import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  final String _text;
  final String? _subtitle;
  final double _textSize;
  final double _subtitleSize;
  final bool _enabled;
  final Color? _color;

  const TextTile(this._text,
      {String? subtitle,
      double textSize = 14,
      double subtitleSize = 14,
      bool enabled = true,
      Color? color,
      super.key})
      : _subtitle = subtitle,
        _textSize = textSize,
        _subtitleSize = subtitleSize,
        _enabled = enabled,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _text,
        style: TextStyle(
          fontSize: _textSize,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _subtitle == null? null : Text(
        _subtitle,
        style: TextStyle(
          fontSize: _subtitleSize,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      enabled: _enabled,
      textColor: _color,
    );
  }
}