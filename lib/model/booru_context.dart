import 'dart:developer';

import 'package:droidbooru/model/base/booru_deserializer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'base/booru.dart';

class BooruContext {
  late Database _db;
  final StoreRef _booruStore = intMapStoreFactory.store('boorus');
  Future<void>? _init;

  BooruContext() {
    _init = initSembast();
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
          record['url'] as String
      )!
    ).toList();
  }

  Future<void> add(Booru booru) async {
    if(_init != null) await _init;

    await _booruStore.add(_db, booru.toMap());
  }

  Future<void> clear() async {
    if(_init != null) await _init;

    await _booruStore.delete(_db);
  }
}