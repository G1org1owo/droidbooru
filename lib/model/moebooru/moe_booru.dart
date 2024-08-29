import 'package:html/dom.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as html;

import '../base/booru.dart';
import '../base/post.dart';
import '../base/tag.dart';
import 'moe_post.dart';
import 'moe_tag.dart';
import 'moe_tag_type.dart';

class Moebooru extends Booru {
  final int? _id;
  final Uri _url;
  static const String _type = "moebooru";

  Moebooru.fromUrl(String url, {int? id}) :
    _url = Uri.parse(url),
    _id = id;

  @override
  Future<List<Post>> listPosts(int limit, int page, List<String> tags) async {
    final client = RetryClient(http.Client());

    Map<String, dynamic> queryParams = {
      "tags": Uri.encodeQueryComponent(tags.join(" "))
    };
    if(limit>0) queryParams['limit'] = limit.toString();
    if(page>0) queryParams['page'] = page.toString();

    final Uri url = _uriBuilder(_url.authority, 'post.json', queryParams);
    final response = await client.get(url);
    List<dynamic> posts = jsonDecode(response.body);

    client.close();
    return posts.map((post) => MoebooruPost.fromMap(post, this)).toList();
  }

  @override
  Future<Tag> getTag(String name) async {
    final client = RetryClient(http.Client(), retries: 5);
    final uriBuilder = isHttps() ? Uri.https : Uri.http;
    final Uri url = uriBuilder(_url.authority, 'tag.json', {'name': name});

    http.Response response;
    do {
      response = await client.get(url);
    } while(!_isValidTag(response));

    Map<String, dynamic> tag =
      (jsonDecode(response.body) as List<dynamic>).firstWhere(
        (tag) => tag['name'] == name
      );

    client.close();
    return MoebooruTag.fromMap(tag, this);
  }

  Future<List<Tag>> getTags(int postId) async {
    final client = RetryClient(http.Client(), retries: 5);

    Uri url = _uriBuilder(_url.authority, "post/show/$postId");
    final response = await client.get(url);
    final document = html.parse(response.body);

    List<Tag> tags = document.querySelectorAll("#tag-sidebar > li")
        .map(_parseTag)
        .nonNulls
        .toList();

    client.close();
    return tags;
  }

  Tag? _parseTag(Element element) {
    String name;
    final tagNameElements = element.getElementsByTagName('a');

    if(tagNameElements.length <= 1) return null;
    name = tagNameElements[tagNameElements.length - 1].text.replaceAll(' ', '_');

    MoebooruTagType? category;

    for(final className in element.classes) {
      switch(className) {
        case "tag-type-copyright":
          category = MoebooruTagType.copyright;
          break;
        case "tag-type-character":
          category = MoebooruTagType.character;
          break;
        case "tag-type-artist":
          category = MoebooruTagType.artist;
          break;
        case "tag-type-style":
          category = MoebooruTagType.style;
          break;
        case "tag-type-circle":
          category = MoebooruTagType.circle;
          break;
        case "tag-type-general":
          category = MoebooruTagType.general;
          break;
        default:
          // There could be multiple classes, e.g. tag-link and tag-type-general
          break;
      }
    }

    category ??= MoebooruTagType.general;

    return MoebooruTag(0, name, category, this);
  }

  bool _isValidTag(http.Response response) {
    return response.statusCode == 200;
  }

  get _uriBuilder => isHttps() ? Uri.https : Uri.http;

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