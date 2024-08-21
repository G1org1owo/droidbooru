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
          record['url'] as String
      )!
    ).toList();
  }

  Future<Booru?> read(String url) async {
    if(_init != null) await _init;

    final record = await _booruStore.findFirst(
        _db,
        finder: Finder(filter: Filter.equals('url', url))
    );

    return record == null? null : BooruDeserializer.deserialize(
        record['type'] as String,
        record['url'] as String
    )!;
  }

  Future<void> add(Booru booru) async {
    if(_init != null) await _init;

    await _booruStore.add(_db, booru.toMap());
  }

  Future<void> clear() async {
    if(_init != null) await _init;

    await _booruStore.delete(_db);
  }

  Future<void> remove(String url) async {
    if(_init != null) await _init;

    final record = await _booruStore.findFirst(
        _db,
        finder: Finder(filter: Filter.equals('url', url))
    );

    await _booruStore.record(record?.key).delete(_db);
  }
}