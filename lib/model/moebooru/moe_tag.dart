import '../base/tag.dart';

class MoebooruTag implements Tag {
  String _name;

  MoebooruTag(String name) : _name = name;

  @override
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  @override
  String toString() {
    return 'MoebooruTag{_name: $_name}';
  }
}