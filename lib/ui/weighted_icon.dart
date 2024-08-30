import 'package:flutter/material.dart';

class WeightedIcon extends StatelessWidget {
  final IconData _icon;
  final double? _iconSize;
  final FontWeight? _iconWeight;
  final Color? _color;

  const WeightedIcon(this._icon, {double? iconSize, FontWeight? iconWeight,
    Color? color, super.key}) :
  _iconSize = iconSize,
  _iconWeight = iconWeight,
  _color = color;

  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(_icon.codePoint),
      style: TextStyle(
        inherit: false,
        fontSize: _iconSize ?? Theme.of(context).iconTheme.size ?? 24,
        fontWeight: _iconWeight ?? _calculateFontWeight(
            Theme.of(context).iconTheme.weight ?? 400.0
        ),
        fontFamily: _icon.fontFamily,
        color: _color,
      ),
    );
  }

  static FontWeight _calculateFontWeight(double iconWeight) => switch((iconWeight/100).round()) {
    1 => FontWeight.w100,
    2 => FontWeight.w200,
    3 => FontWeight.w300,
    4 => FontWeight.w400,
    5 => FontWeight.w500,
    6 => FontWeight.w600,
    7 => FontWeight.w700,
    8 => FontWeight.w800,
    9 => FontWeight.w900,
    int() => throw StateError("Invalid argument: iconWeight must be a value"
        " between 100 and 900, inclusive."),
  };
}