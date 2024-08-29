import '../base/booru.dart';
import '../base/tag.dart';
import '../base/tag_type.dart';
import 'moe_booru.dart';
import 'moe_tag_type.dart';

class MoebooruTag implements Tag, Comparable<MoebooruTag> {
  final Booru _booru;
  int _id;
  String _name;
  MoebooruTagType _type;

  MoebooruTag(this._id, this._name, this._type, this._booru);

  factory MoebooruTag.fromMap(Map<String, dynamic> map, Moebooru booru) {
    return MoebooruTag(
      map['id'] as int,
      map['name'] as String,
      MoebooruTagType.getByValue(map['type'] as int),
      booru
    );
  }

  @override
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  @override
  String toString() {
    return 'MoebooruTag{_id:$_id, _name: $_name, type: $_type}';
  }

  @override
  int get id => _id;

  @override
  TagType get type => switch(_type) {
    MoebooruTagType.general => TagType.general,
    MoebooruTagType.artist => TagType.artist,
    MoebooruTagType.copyright => TagType.copyright,
    MoebooruTagType.character => TagType.character,
    MoebooruTagType.style => TagType.meta,
    MoebooruTagType.circle => TagType.artist,
  };

  @override
  int compareTo(MoebooruTag other) {
    int typeComparison = type.compareTo(other.type);

    return typeComparison == 0? name.compareTo(other.name) : typeComparison;
  }
}