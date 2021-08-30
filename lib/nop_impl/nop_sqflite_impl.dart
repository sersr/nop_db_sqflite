import 'dart:async';

import 'package:nop_db/database/nop.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'sqflite_main_isolate.dart';

abstract class NopDatabaseSqflite extends NopDatabase {
  NopDatabaseSqflite(String path) : super(path);

  @override
  late final execute = innerQuery;

  @override
  late final rawQuery = innerQuery;

  @override
  late final rawDelete = innerDelete;

  @override
  late final rawUpdate = innerUpdate;

  @override
  late final rawInsert = innerInsert;

  factory NopDatabaseSqflite.create({
    required String path,
    bool useFfi = false,
  }) {
    if (useFfi) {
      return NopDatabaseSqfliteImpl(path);
    }
    return NopDatabaseSqfliteMain(path);
  }

  static Future<NopDatabase> openSqfite(
    String path, {
    required DatabaseOnCreate onCreate,
    int version = 1,
    DatabaseUpgrade? onUpgrade,
    DatabaseUpgrade? onDowngrade,
    bool useFfi = false,
  }) {
    final db = NopDatabaseSqflite.create(path: path, useFfi: useFfi);
    return db
        .open(
          version: version,
          onCreate: onCreate,
          onUpgrade: onUpgrade,
          onDowngrade: onDowngrade,
        )
        .then((_) => db);
  }

  Future<void> open({
    required DatabaseOnCreate onCreate,
    int version = 1,
    DatabaseUpgrade? onUpgrade,
    DatabaseUpgrade? onDowngrade,
  });

  Future<List<Map<String, Object?>>> innerQuery(String sql,
      [List<Object?> parameters = const []]);

  Future<int> innerUpdate(String sql, [List<Object?> paramters = const []]);

  Future<int> innerInsert(String sql, [List<Object?> paramters = const []]);

  Future<int> innerDelete(String sql, [List<Object?> paramters = const []]);

  Future<void> innerExecute(String sql, [List<Object?> paramters = const []]);
}

class NopDatabaseSqfliteImpl extends NopDatabaseSqflite {
  NopDatabaseSqfliteImpl(String path) : super(path);

  late Database db;

  @override
  Future<void> open({
    required DatabaseOnCreate onCreate,
    int version = 1,
    DatabaseUpgrade? onUpgrade,
    DatabaseUpgrade? onDowngrade,
    bool useFfi = true,
  }) async {
    assert(version > 0);
    FutureOr<void> _onCreate(Database db, int version) {
      this.db = db;
      return onCreate(this, version);
    }

    FutureOr<void> _onUpdate(Database db, int o, int n) {
      this.db = db;
      return onUpgrade?.call(this, o, n);
    }

    FutureOr<void> _onDown(Database db, int o, int n) {
      this.db = db;
      return onDowngrade?.call(this, o, n);
    }

    if (useFfi) {
      sqfliteFfiInit();
      db = await databaseFactoryFfi.openDatabase(path,
          options: OpenDatabaseOptions(
            version: version,
            onCreate: _onCreate,
            onUpgrade: _onUpdate,
            onDowngrade: _onDown,
          ));
    } else {
      db = await openDatabase(path,
          version: version,
          onCreate: _onCreate,
          onUpgrade: _onUpdate,
          onDowngrade: _onDown);
    }
  }

  @override
  Future<List<Map<String, Object?>>> innerQuery(String sql,
      [List<Object?> parameters = const []]) async {
    final result = await db.rawQuery(sql, parameters);
    return result;
  }

  @override
  Future<int> innerUpdate(String sql, [List<Object?> paramters = const []]) {
    return db.rawUpdate(sql, paramters);
  }

  @override
  Future<int> innerInsert(String sql, [List<Object?> paramters = const []]) {
    return db.rawInsert(sql, paramters);
  }

  @override
  Future<int> innerDelete(String sql, [List<Object?> paramters = const []]) {
    return db.rawDelete(sql, paramters);
  }

  @override
  Future<void> innerExecute(String sql, [List<Object?> paramters = const []]) {
    return db.execute(sql, paramters);
  }

  @override
  Future<void> dispose() {
    return db.close();
  }
}

class NopDatabaseSqfliteMain extends NopDatabaseSqflite {
  NopDatabaseSqfliteMain(String path) : super(path);

  late final SqfliteDbIsolate dbMessager = SqfliteDbIsolate.create(this);

  DatabaseOnCreate? _onCreate;
  DatabaseUpgrade? _onUpgrade;
  DatabaseUpgrade? _onDowngrade;
  DatabaseOnCreate? get onCreate => _onCreate;
  DatabaseUpgrade? get onUpgrade => _onUpgrade;
  DatabaseUpgrade? get onDowngrade => _onDowngrade;
  @override
  Future<void> open({
    required DatabaseOnCreate onCreate,
    int version = 1,
    DatabaseUpgrade? onUpgrade,
    DatabaseUpgrade? onDowngrade,
  }) async {
    _onCreate = onCreate;
    _onUpgrade = onUpgrade;
    _onDowngrade = onDowngrade;
    dbMessager.init();
    await dbMessager.open(path, version);
    _onCreate = null;
    _onDowngrade = null;
    _onUpgrade = null;
  }

  @override
  Future<List<Map<String, Object?>>> innerQuery(String sql,
      [List<Object?> parameters = const []]) async {
    final result = await dbMessager.innerQuery(sql, parameters);
    return result;
  }

  @override
  Future<int> innerUpdate(String sql, [List<Object?> paramters = const []]) {
    return dbMessager.innerUpdate(sql, paramters);
  }

  @override
  Future<int> innerInsert(String sql, [List<Object?> paramters = const []]) {
    return dbMessager.innerInsert(sql, paramters);
  }

  @override
  Future<int> innerDelete(String sql, [List<Object?> paramters = const []]) {
    return dbMessager.innerDelete(sql, paramters);
  }

  @override
  Future<void> innerExecute(String sql, [List<Object?> paramters = const []]) {
    return dbMessager.innerExecute(sql, paramters);
  }

  @override
  void dispose() {
    dbMessager.dispose();
  }
}
