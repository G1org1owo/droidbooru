import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

// Consider using generics
class DBContext {
  static late Database _db;
  static Future<void>? _init;

  Future<void> _initSembast() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'boorus.db');
    _db = await databaseFactoryIo.openDatabase(dbPath);
    _init = null;
  }

  @protected
  Future<Database> get db async {
    _init ??= _initSembast();
    await _init;

    return _db;
  }
}