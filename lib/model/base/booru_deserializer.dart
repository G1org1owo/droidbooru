import 'booru.dart';

class BooruDeserializer {
  static final Map<String, BooruDeserializer> _deserializers = {};
  final Booru Function(String, {int? id}) _deserializer;

  BooruDeserializer(String key, this._deserializer) {
    _deserializers[key] = this;
  }

  static Booru? deserialize(String key, String url, {int? id}) {
    return _deserializers[key]?._deserializer(url, id: id);
  }

  static List<String> get keys => _deserializers.keys.toList();
}