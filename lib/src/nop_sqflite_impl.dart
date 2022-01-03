import 'dart:async';

import 'package:nop_db/nop_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:utils/utils.dart';

import 'sqflite_event.dart';
import 'sqflite_main_isolate.dart';

abstract class NopDatabaseSqflite extends NopDatabase {
  NopDatabaseSqflite(String path) : super(path);
  @override
  Future<void> execute(String sql, [List<Object?> paramters = const []]) =>
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
    required DatabaseOnCreate? onCreate,
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
    DatabaseOnCreate? onCreate,
    int version = 1,
    DatabaseUpgrade? onUpgrade,
    DatabaseUpgrade? onDowngrade,
  }) async {
    sqfliteFfiInit();
    db = await databaseFactoryFfi.openDatabase(path);
    final oldVersion = await getVersion();

    Log.e('oldVersion: $oldVersion', onlyDebug: false);
    if (oldVersion == 0) {
      await onCreate!(this, version);
      await setVersion(version);
    } else {
      try {
        if (oldVersion < version) {
          await setVersion(version);
          await onUpgrade?.call(this, oldVersion, version);
        } else if (oldVersion > version) {
          await setVersion(version);
          await onDowngrade?.call(this, oldVersion, version);
        }
      } catch (e) {
        Log.e('sqflite 可能没有初始化完成?');
      }
    }
  }

  Future<int> getVersion() async {
    var version = 0;
    try {
      final data = await rawQuery('PRAGMA user_version');
      final value = data.first.values.first;
      version = value as int? ?? 0;
    } catch (e) {
      Log.i('get version error!!');
    }
    return version;
  }

  Future<void> setVersion(int version) async {
    return execute('PRAGMA user_version = $version');
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
    Log.w('close sqflite', onlyDebug: false);
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
        SendEvent,
        ListenMixin,
        Resolve,
        SendEventResolve,
        SendEventMixin,
        SendCacheMixin,
        SendInitCloseMixin,
        SqfliteEventResolve,
        SqfliteEventMessager,
        SendMultiServerMixin,
        MultiSqfliteEventDefaultMessagerMixin {
  NopDatabaseSqfliteMain(String path) : super(path);

  @override
  Future<void> open({
    DatabaseOnCreate? onCreate,
    int version = 1,
    DatabaseUpgrade? onUpgrade,
    DatabaseUpgrade? onDowngrade,
  }) async {
    await init();
    await sqfliteOpen(path);
    final oldVersion = await getVersion();

    Log.e('oldVersion: $oldVersion', onlyDebug: false);
    if (oldVersion == 0) {
      await onCreate!(this, version);
      await setVersion(version);
    } else {
      try {
        if (oldVersion < version) {
          await setVersion(version);
          await onUpgrade?.call(this, oldVersion, version);
        } else if (oldVersion > version) {
          await setVersion(version);
          await onDowngrade?.call(this, oldVersion, version);
        }
      } catch (e) {
        Log.e('sqflite 可能没有初始化完成?');
      }
    }
  }

  Future<int> getVersion() async {
    var version = 0;
    try {
      final data = await rawQuery('PRAGMA user_version');
      final value = data.first.values.first;
      version = value as int? ?? 0;
    } catch (e) {
      Log.i('get version error!!');
    }
    return version;
  }

  Future<void> setVersion(int version) async {
    return execute('PRAGMA user_version = $version');
  }

  // 本地(相对)调用
  @override
  FutureOr<void> disposeNop() => close();

  /// 不使用[Resolve]的[onResumeListen]实现
  @override
  Future<RemoteServer> createRemoteServerSqfliteEventDefault() async {
    /// 主隔离端口已经开启了，只需向端口发送[SendPortName]
    SqfliteMainIsolate.nopDatabaseSqfliteMainSendPort!.send(SendHandleName(
        sqfliteEventDefault, localSendHandle,
        protocols: getMessagerProtocols(sqfliteEventDefault)));
    return LocalRemoteServer();
  }

  @override
  FutureOr<void> onClose() async {
    Log.e('此对象才是创建者，主隔离只是代理，没有权限关闭', onlyDebug: false);
    return super.onClose();
  }

  @override
  SendHandle? get remoteSendHandle =>
      getSendHandleOwner(sqfliteEventDefault)?.localSendHandle;

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
  NopPrepare prepare(String sql,
      {bool persistent = false, bool vtab = true, bool checkNoTail = false}) {
    throw UnimplementedError('暂未支持sqflite');
  }
}
