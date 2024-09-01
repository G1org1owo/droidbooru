import 'booru.dart';

class BooruDeserializer {
  static final Map<String, BooruDeserializer> _deserializers = {};
  final Booru Function(String, {int? id}) _deserializer;

  // Each deserializer keeps a pool of every booru it has deserialized,
  // in order to avoid deserializing the same booru multiple times
  final Map<String, Booru?> _boorus = {};

  BooruDeserializer(String key, this._deserializer) {
    _deserializers[key] = this;
  }

  static Booru? deserialize(String key, String url, {int? id}) {
    _deserializers[key]?._boorus[url] ??=
        _deserializers[key]?._deserializer(url, id: id);

    return _deserializers[key]?._boorus[url];
  }

  static List<String> get keys => _deserializers.keys.toList();
}