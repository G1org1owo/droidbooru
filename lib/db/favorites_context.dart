import 'package:sembast/sembast.dart';

import '../model/base/booru.dart';
import '../model/base/booru_deserializer.dart';
import '../model/base/post.dart';
import 'db_context.dart';

class FavoritesContext extends DBContext {
  final StoreRef _favoriteStore = intMapStoreFactory.store('favorites');

  static FavoritesContext? _instance;
  static FavoritesContext? _memoryInstance;

  FavoritesContext._();
  factory FavoritesContext() {
    _instance ??= FavoritesContext._();
    return _instance!;
  }

  factory FavoritesContext.memory() {
    _memoryInstance ??= FavoritesContext._();
    _memoryInstance!.memory = true;
    return _memoryInstance!;
  }

  Future<List<Post>> readAll() async {
    final records = await _favoriteStore.find(await db);

    return records.map((record) {
      Booru _booru = BooruDeserializer.deserialize(
          record['type'] as String,
          record['url'] as String,
      )!;

      return _booru.deserializePost(Map.of(record.value as Map<String, dynamic>));
    }).toList();
  }

  Future<Post> add(Post post) async {
    await _favoriteStore.add(await db, post.toMap());

    return post;
  }

  Future<void> clear() async {
    await _favoriteStore.delete(await db);
  }

  Future<void> remove(Post post) async {
    (await _getPostRecord(post))?.ref.delete(await db);
  }

  Future<bool> isFavorite(Post post) async {
    return (await _getPostRecord(post)) != null;
  }

  Future<RecordSnapshot<Object?, Object?>?> _getPostRecord(Post post) async {
    return await _favoriteStore.findFirst(
        await db,
        finder: Finder(filter: Filter.and([
          Filter.equals('type', post.booru.type),
          Filter.equals('url', post.booru.url.origin),
          Filter.equals('id', post.id),
        ]))
    );
  }
}