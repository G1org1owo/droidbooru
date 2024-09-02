import 'package:droidbooru/model/base/post.dart';
import 'package:droidbooru/model/base/tag.dart';
import 'package:droidbooru/model/moebooru/moe_booru.dart';
import 'package:flutter_test/flutter_test.dart';

class HasTags extends CustomMatcher {
  HasTags(Matcher matcher) : super('Post with stringTags', 'tags', matcher);
  @override
  Object? featureValueOf(actual) => (actual as Post).stringTags;
}

void main() {
  group("Moebooru", () {
    Moebooru booru = Moebooru.fromUrl('https://konachan.com');

    test('isHttps', () {
      expect(booru.isHttps(), true);
    });

    Future<List<Post>> posts = booru.listPosts(10, 1, ['hatsune_miku']);

    test('listPosts', () async {
      expect(await posts, everyElement(HasTags(contains('hatsune_miku'))));
    });

    test('getTags', () async {
      Post post = (await posts)[0];
      List<Tag> tags = await booru.getTags(post.id);

      expect(tags.map((tag) => tag.name), containsAll(post.stringTags));
    });
  });
}