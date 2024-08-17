import 'dart:convert';

import '../base/tag.dart';
import '../base/post.dart';
import 'moe_tag.dart';

class MoebooruPost implements Post {
  int _id;
  String _author;
  String _source;
  int _score;
  String _md5;
  String? _fileExtension;
  String _contentUrl;
  String _previewUrl;
  String _sampleUrl;
  int _width;
  int _height;
  int _parentId;
  String _rating;
  List<Tag> _tags;

  MoebooruPost._(int id, String author, String source, int score, String md5,
      String? fileExtension, String contentUrl, String previewUrl,
      String sampleUrl, int width, int height, int parentId, String rating,
      List<Tag> tags) :
    _id = id,
    _author = author,
    _source = source,
    _score = score,
    _md5 = md5,
    _fileExtension = fileExtension,
    _contentUrl = contentUrl,
    _previewUrl = previewUrl,
    _sampleUrl = sampleUrl,
    _width = width,
    _height = height,
    _parentId = parentId,
    _rating = rating,
    _tags = tags;

  factory MoebooruPost.fromJson(String json) {
    final jsonData = jsonDecode(json);

    return MoebooruPost.fromMap(jsonData);
  }

  factory MoebooruPost.fromMap(Map<String, dynamic> map) {
    return MoebooruPost._(
      map['id'],
      map['author'],
      map['source'],
      map['score'],
      map['md5'],
      map['file_ext'],
      map['file_url'],
      map['preview_url'],
      map['sample_url'],
      map['width'],
      map['height'],
      map['parent_id'] ?? -1,
      map['rating'],
      (map['tags'] as String).split(' ').map((tag) => MoebooruTag(tag)).toList(),
    );
  }

  @override
  String toString() {
    return 'MoebooruPost{_id: $_id, _author: $_author, _source: $_source,'
        ' _score: $_score, _md5: $_md5, _fileExtension: $_fileExtension,'
        ' _contentUrl: $_contentUrl, _previewUrl: $_previewUrl,'
        ' _sampleUrl: $_sampleUrl, _width: $_width, _height: $_height,'
        ' _parentId: $_parentId, _rating: $_rating, _tags: $_tags}';
  }

  @override
  int get parentId => _parentId;

  @override
  set parentId(int value) {
    _parentId = value;
  }

  @override
  int get height => _height;

  @override
  set height(int value) {
    _height = value;
  }

  @override
  int get width => _width;

  @override
  set width(int value) {
    _width = value;
  }

  @override
  String get sampleUrl => _sampleUrl;

  @override
  set sampleUrl(String value) {
    _sampleUrl = value;
  }

  @override
  String get previewUrl => _previewUrl;

  @override
  set previewUrl(String value) {
    _previewUrl = value;
  }

  @override
  String get contentUrl => _contentUrl;

  @override
  set contentUrl(String value) {
    _contentUrl = value;
  }

  @override
  String? get fileExtension => _fileExtension;

  @override
  set fileExtension(String? value) {
    _fileExtension = value;
  }

  @override
  String get md5 => _md5;

  @override
  set md5(String value) {
    _md5 = value;
  }

  @override
  int get score => _score;

  @override
  set score(int value) {
    _score = value;
  }

  @override
  String get source => _source;

  @override
  set source(String value) {
    _source = value;
  }

  @override
  String get author => _author;

  @override
  set author(String value) {
    _author = value;
  }

  @override
  int get id => _id;

  @override
  set id(int value) {
    _id = value;
  }

  @override
  List<Tag> get tags => _tags;

  @override
  set tags(List<Tag> value) {
    _tags = value;
  }

  @override
  String get rating => _rating;

  @override
  set rating(String value) {
    _rating = value;
  }
}