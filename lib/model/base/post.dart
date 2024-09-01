import 'booru.dart';
import 'tag.dart';

abstract class Post {
  Booru get booru;

  int? get parentId;
  set parentId(int? value);

  int get height;
  set height(int value);

  int get width;
  set width(int value);

  String get sampleUrl;
  set sampleUrl(String value);

  String get previewUrl;
  set previewUrl(String value);

  String get contentUrl;
  set contentUrl(String value);

  String? get fileExtension;
  set fileExtension(String? value);

  String get md5;
  set md5(String value);

  int get score;
  set score(int value);

  String get source;
  set source(String value);

  String get author;
  set author(String value);

  int get id;
  set id(int value);

  List<String> get stringTags;
  List<Tag> get tags;
  set tags(List<Tag> value);

  String get rating;
  set rating(String value);

  bool get hasChildren;
  set hasChildren(bool value);

  String get url;

  Map<String, dynamic> toMap() {
    return {
      'url': booru.url.origin,
      'type': booru.type,
      'id': id,
      'author': author,
      'source': source,
      'score':score ,
      'md5': md5,
      'file_ext': fileExtension,
      'content_url': contentUrl,
      'preview_url': previewUrl,
      'sample_url': sampleUrl,
      'width': width,
      'height': height,
      'parent_id': parentId,
      'rating': rating,
      'has_children': hasChildren,
      'tags': stringTags.join(' '),
    };
  }
}