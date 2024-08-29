import 'post.dart';
import 'tag.dart';

abstract class Booru {
  int? get id;
  Uri get url;
  String get type;
  bool isHttps();

  Future<List<Post>> listPosts(int limit, int page, List<String> tags);
  Future<Tag> getTag(String name);

  Map<String, dynamic> toMap() {
    return {
      'url': url.origin,
      'type': type,
    };
  }
}