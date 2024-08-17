import 'dart:developer';

import '../base/booru.dart';
import '../base/post.dart';
import 'moe_post.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Moebooru implements Booru {
  final Uri _url;

  Moebooru.fromUrl(String url) : _url = Uri.parse(url);

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
  Map<String, dynamic> toMap() {
    return {
      'url': _url.toString(),
      'type': 'moebooru',
    };
  }

  @override
  Uri get url => _url;

  @override
  bool isHttps() {
    return _url.hasScheme && _url.scheme == "https";
  }

  @override
  String toString() {
    return 'Moebooru{_url: $_url}';
  }
}