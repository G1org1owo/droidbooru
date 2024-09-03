import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

// Consider using generics
class DBContext {
  static Database? _db;

  Future<void> _initSembast() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'droidbooru.db');
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }

  @protected
  Future<Database> get db async {
    _db ?? await _initSembast();
    return _db!;
  }
}