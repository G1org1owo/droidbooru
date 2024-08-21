import 'post.dart';

abstract class Booru {
  Uri get url;
  String get type;
  bool isHttps();

  Future<List<Post>> listPosts(int limit, int page, List<String> tags);

  Map<String, dynamic> toMap() {
    return {
      'url': url.origin,
      'type': type,
    };
  }
}