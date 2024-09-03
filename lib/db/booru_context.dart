import 'package:droidbooru/db/db_context.dart';
import 'package:sembast/sembast.dart';

import '../model/base/booru.dart';
import '../model/base/booru_deserializer.dart';

class BooruContext extends DBContext {
  final StoreRef _booruStore = intMapStoreFactory.store('boorus');

  static BooruContext? _instance;
  static BooruContext? _memoryInstance;

  BooruContext._();
  factory BooruContext() {
    _instance ??= BooruContext._();
    return _instance!;
  }

  factory BooruContext.memory() {
    _memoryInstance ??= BooruContext._();
    _memoryInstance!.memory = true;
    return _memoryInstance!;
  }

  Future<List<Booru>> readAll() async {
    final records = await _booruStore.find(await db);
    return records.map((record) =>
      BooruDeserializer.deserialize(
          record['type'] as String,
          record['url'] as String,
          id: record.key as int,
      )!
    ).toList();
  }

  Future<Booru?> read(int id) async {
    final record = await _booruStore.record(id).get(await db) as Map<String, Object?>?;

    return record == null? null : BooruDeserializer.deserialize(
      record['type'] as String,
      record['url'] as String,
      id: id,
    )!;
  }

  Future<Booru?> find(String url) async {
    final record = await _booruStore.findFirst(
        await db,
        finder: Finder(filter: Filter.equals('url', url))
    );

    return record == null? null : BooruDeserializer.deserialize(
        record['type'] as String,
        record['url'] as String,
        id: record.key as int,
    )!;
  }

  Future<Booru> add(Booru booru) async {
    int id = (await _booruStore.add(await db, booru.toMap())) as int;

    return BooruDeserializer.deserialize(booru.type, booru.url.origin, id: id)!;
  }

  Future<void> update(Booru booru) async {
    if(booru.id == null) throw StateError("Booru.id is Null!");

    await _booruStore.record(booru.id).update(await db, booru.toMap());
  }

  Future<Booru> put(Booru booru) async {
    if(booru.id != null) {
      await update(booru);
      return booru;
    } else {
      return await add(booru);
    }
  }

  Future<void> clear() async {
    await _booruStore.delete(await db);
  }

  Future<void> findAndRemove(String url) async {
    final record = await _booruStore.findFirst(
        await db,
        finder: Finder(filter: Filter.equals('url', url))
    );

    await _booruStore.record(record?.key).delete(await db);
  }

  Future<void> delete(Booru booru) async {
    if(booru.id == null) throw StateError("Booru.id is Null!");

    await _booruStore.record(booru.id!).delete(await db);
  }
}