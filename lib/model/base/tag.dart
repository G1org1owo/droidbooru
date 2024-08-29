import 'tag_type.dart';

abstract class Tag {
  int get id;
  String get name;
  TagType get type;
}