import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

// Consider using generics
class DBContext {
  static Database? _db;
  static Database? _memoryDb;

  bool memory = false;

  Future<void> _initIO() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'droidbooru.db');
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<void> _initMemory() async {
    _memoryDb = await databaseFactoryMemory.openDatabase('droidbooru');
  }

  @protected
  Future<Database> get db async {
    if(memory) {
      _memoryDb ?? await _initMemory();
      return _memoryDb!;
    }

    _db ?? await _initIO();
    return _db!;
  }
}