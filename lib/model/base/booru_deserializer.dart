import 'booru.dart';

class BooruDeserializer {
  static final Map<String, BooruDeserializer> _deserializers = {};
  final Booru Function(String) _deserializer;

  BooruDeserializer(String key, this._deserializer) {
    _deserializers[key] = this;
  }

  static Booru? deserialize(String key, String url) {
    return _deserializers[key]?._deserializer(url);
  }
}