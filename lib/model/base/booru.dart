import 'post.dart';

abstract class Booru {
  Uri get url;
  bool isHttps();

  Future<List<Post>> listPosts(int limit, int page, List<String> tags);

  Map<String, dynamic> toMap();
}