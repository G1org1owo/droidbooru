import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'base/booru.dart';
import 'base/booru_deserializer.dart';

class BooruContext {
  late Database _db;
  final StoreRef _booruStore = intMapStoreFactory.store('boorus');
  Future<void>? _init;

  static BooruContext? _instance;

  BooruContext._() {
    _init = initSembast();
  }

  factory BooruContext.getContext() {
    _instance ??= BooruContext._();
    return _instance!;
  }

  Future<void> initSembast() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'boorus.db');
    _db = await databaseFactoryIo.openDatabase(dbPath);
    _init = null;
  }

  Future<List<Booru>> readAll() async {
    if(_init != null) await _init;

    final records = await _booruStore.find(_db);
    return records.map((record) =>
      BooruDeserializer.deserialize(
          record['type'] as String,
          record['url'] as String,
          id: record.key as int,
      )!
    ).toList();
  }

  Future<Booru?> find(String url) async {
    if(_init != null) await _init;

    final record = await _booruStore.findFirst(
        _db,
        finder: Finder(filter: Filter.equals('url', url))
    );

    return record == null? null : BooruDeserializer.deserialize(
        record['type'] as String,
        record['url'] as String,
        id: record.key as int,
    )!;
  }

  Future<Booru> add(Booru booru) async {
    if(_init != null) await _init;

    int id = (await _booruStore.add(_db, booru.toMap())) as int;

    return BooruDeserializer.deserialize(booru.type, booru.url.origin, id: id)!;
  }

  Future<void> update(Booru booru) async {
    if(_init != null) await _init;

    if(booru.id == null) throw StateError("Booru.id is Null!");

    await _booruStore.record(booru.id).update(_db, booru.toMap());
  }

  Future<Booru> put(Booru booru) async {
    if(_init != null) await _init;

    if(booru.id != null) {
      await update(booru);
      return booru;
    } else {
      return await add(booru);
    }
  }

  Future<void> clear() async {
    if(_init != null) await _init;

    await _booruStore.delete(_db);
  }

  Future<void> findAndRemove(String url) async {
    if(_init != null) await _init;

    final record = await _booruStore.findFirst(
        _db,
        finder: Finder(filter: Filter.equals('url', url))
    );

    await _booruStore.record(record?.key).delete(_db);
  }

  Future<void> delete(Booru booru) async {
    if(_init != null) await _init;

    if(booru.id == null) throw StateError("Booru.id is Null!");

    await _booruStore.record(booru.id!).delete(_db);
  }
}