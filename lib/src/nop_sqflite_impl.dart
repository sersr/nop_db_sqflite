import 'dart:async';
import 'dart:isolate';

import 'package:nop_db/nop_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utils/utils.dart';

import 'sqflite_event.dart';
import 'sqflite_main_isolate.dart';

abstract class NopDatabaseSqflite extends NopDatabase {
  NopDatabaseSqflite(String path) : super(path);
  @override
  void execute(String sql, [List<Object?> paramters = const []]) =>
      innerExecute(sql, paramters);
  @override
  FutureOr<List<Map<String, Object?>>> rawQuery(String sql,
          [List<Object?> paramters = const []]) =>
      innerQuery(sql, paramters);
  @override
  FutureOr<int> rawUpdate(String sql, [List<Object?> paramters = const []]) =>
      innerUpdate(sql, paramters);
  @override
  FutureOr<int> rawDelete(String sql, [List<Object?> paramters = const []]) =>
      innerDelete(sql, paramters);
  @override
  FutureOr<int> rawInsert(String sql, [List<Object?> paramters = const []]) =>
      innerInsert(sql, paramters);

  factory NopDatabaseSqflite.create({required String path}) {
    // 使用端口与主隔离通信
    return NopDatabaseSqfliteMain(path);
  }

  static Future<NopDatabase> openSqfite(
    String path, {
    required DatabaseOnCreate onCreate,
    int version = 1,
    DatabaseUpgrade? onUpgrade,
    DatabaseUpgrade? onDowngrade,
  }) {
    final db = NopDatabaseSqflite.create(path: path);
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
    // bool useFfi = true,
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

    // '没有完整的生命周期，不能关闭Isolate
    // if (useFfi) {
    //   sqfliteFfiInit();
    //   db = await databaseFactoryFfi.openDatabase(path,
    //       options: OpenDatabaseOptions(
    //         version: version,
    //         onCreate: _onCreate,
    //         onUpgrade: _onUpdate,
    //         onDowngrade: _onDown,
    //       ));
    // } else {
    db = await openDatabase(path,
        version: version,
        onCreate: _onCreate,
        onUpgrade: _onUpdate,
        onDowngrade: _onDown);
    // }
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
  Future<void> disposeNop() async {
    Log.w('close...', onlyDebug: false);
    return db.close();
  }

  @override
  NopPrepare prepare(String sql,
      {bool persistent = false, bool vtab = true, bool checkNoTail = false}) {
    throw UnimplementedError('暂未支持sqflite');
  }
}

/// 连接 main Isolate
class NopDatabaseSqfliteMain extends NopDatabaseSqflite
    with
        SqfliteEvent,
        Resolve,
        SqfliteEventResolve,
        SqfliteEventMessager,
        SendEventMixin,
        SendCacheMixin,
        SendInitCloseMixin {
  NopDatabaseSqfliteMain(String path) : super(path);

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
    await init();
    await sqfliteOpen(path, version);
    _onCreate = null;
    _onDowngrade = null;
    _onUpgrade = null;
  }

  bool _state = false;
  @override
  bool get state => _state;
  @override
  FutureOr<void> initTask() async {
    if (_state) return;
    rcPort?.close();
    _state = true;
    final _receivePort = ReceivePort();
    try {
      sendPortGroup = SqfliteMainIsolate.getNopDatabaseSqfliteMainOwner(
          _receivePort.sendPort);
    } catch (e) {
      Log.e(e, onlyDebug: false);
    }
    onResume();
    rcPort = _receivePort;
    _receivePort.listen(_listen);
  }

  ReceivePort? rcPort;
  void _listen(message) {
    if (add(message)) return;
    if (resolveAll(message)) return;
  }

  /// messager
  @override
  Future<int> innerDelete(String sql,
      [List<Object?> paramters = const []]) async {
    final d = await sqfliteDelete(sql, paramters);
    return d ?? 0;
  }

  @override
  Future<int> innerInsert(String sql,
      [List<Object?> paramters = const []]) async {
    final i = await sqfliteInsert(sql, paramters);
    return i ?? 0;
  }

  @override
  Future<int> innerUpdate(String sql,
      [List<Object?> paramters = const []]) async {
    final u = await sqfliteUpdate(sql, paramters);
    return u ?? 0;
  }

  @override
  Future<void> innerExecute(String sql,
      [List<Object?> paramters = const []]) async {
    return sqfliteExecute(sql, paramters);
  }

  @override
  Future<List<Map<String, Object?>>> innerQuery(String sql,
      [List<Object?> parameters = const []]) async {
    final q = await sqfliteQuery(sql, parameters);
    return q ?? const [];
  }

  @override
  SendEvent get sendEvent => this;

  /// Resolve
  @override
  FutureOr<void> sqfliteOnCreate(int version) {
    assert(onCreate != null);
    assert(Log.w('Resolve: onCreate'));
    return onCreate?.call(this, version);
  }

  @override
  FutureOr<void> sqfliteOnUpgrade(int oldVersion, int newVersion) {
    return onUpgrade?.call(this, oldVersion, newVersion);
  }

  @override
  FutureOr<void> sqfliteOnDowngrade(int oldVersion, int newVersion) {
    return onDowngrade?.call(this, oldVersion, newVersion);
  }

  @override
  FutureOr<void> disposeNop() => onClose();

  @override
  void dispose() {
    super.dispose();
    rcPort?.close();
    _state = false;
    sendPortGroup = null;
    rcPort = null;
  }

  @override
  FutureOr<bool> onClose() async {
    await close();
    return true;
  }

  @override
  SendPortOwner? sendPortGroup;

  @override
  NopPrepare prepare(String sql,
      {bool persistent = false, bool vtab = true, bool checkNoTail = false}) {
    throw UnimplementedError('暂未支持sqflite');
  }

  @override
  FutureOr<void> onCloseStart() {
    sendPortGroup = null;
    // rcPort = null;
  }
}
