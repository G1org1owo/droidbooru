import 'dart:developer';

import '../base/booru.dart';
import '../base/post.dart';
import 'moe_post.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Moebooru extends Booru {
  final int? _id;
  final Uri _url;
  static const String _type = "moebooru";

  Moebooru.fromUrl(String url, {int? id}) :
    _url = Uri.parse(url),
    _id = id;

  @override
  Future<List<Post>> listPosts(int limit, int page, List<String> tags) async {
    Map<String, dynamic> queryParams = {
      "tags": Uri.encodeQueryComponent(tags.join(" "))
    };
    if(limit>0) queryParams['limit'] = limit.toString();
    if(page>0) queryParams['page'] = page.toString();

    final uriBuilder = isHttps() ? Uri.https : Uri.http;

    final Uri url = uriBuilder(_url.authority, 'post.json', queryParams);
    final response = await http.get(url);

    List<dynamic> posts = jsonDecode(response.body);
    return posts.map((post) => MoebooruPost.fromMap(post)).toList();
  }

  @override
  int? get id => _id;

  @override
  Uri get url => _url;

  @override
  String get type => _type;

  @override
  bool isHttps() {
    return _url.hasScheme && _url.scheme == "https";
  }

  @override
  String toString() {
    return 'Moebooru{id: $id, _url: $_url}';
  }
}