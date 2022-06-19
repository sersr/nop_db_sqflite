import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nop/nop.dart';
import 'package:nop_db/nop_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'sqflite_event.dart';
import 'sqflite_main_isolate.dart';

abstract class NopDatabaseSqflite extends NopDatabase {
  NopDatabaseSqflite(String path) : super(path);
  @override
  Future<void> execute(String sql, [List<Object?> parameters = const []]) =>
      innerExecute(sql, parameters);
  @override
  FutureOr<List<Map<String, Object?>>> rawQuery(String sql,
          [List<Object?> parameters = const []]) =>
      innerQuery(sql, parameters);
  @override
  FutureOr<int> rawUpdate(String sql, [List<Object?> parameters = const []]) =>
      innerUpdate(sql, parameters);
  @override
  FutureOr<int> rawDelete(String sql, [List<Object?> parameters = const []]) =>
      innerDelete(sql, parameters);
  @override
  FutureOr<int> rawInsert(String sql, [List<Object?> parameters = const []]) =>
      innerInsert(sql, parameters);

  factory NopDatabaseSqflite.create({required String path}) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return NopDatabaseSqfliteMain(path);
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return NopDatabaseSqfliteImpl(path);
      default:
        throw UnsupportedError('不支持${defaultTargetPlatform.name}平台');
    }
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

  Future<int> innerUpdate(String sql, [List<Object?> parameters = const []]);

  Future<int> innerInsert(String sql, [List<Object?> parameters = const []]);

  Future<int> innerDelete(String sql, [List<Object?> parameters = const []]);

  Future<void> innerExecute(String sql, [List<Object?> parameters = const []]);
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
    if (oldVersion == 0 && onCreate != null) {
      await onCreate(this, version);
      await setVersion(version);
    } else {
      try {
        if (oldVersion < version && onUpgrade != null) {
          await setVersion(version);
          await onUpgrade.call(this, oldVersion, version);
        } else if (oldVersion > version && onDowngrade != null) {
          await setVersion(version);
          await onDowngrade.call(this, oldVersion, version);
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
  Future<int> innerUpdate(String sql, [List<Object?> parameters = const []]) {
    return db.rawUpdate(sql, parameters);
  }

  @override
  Future<int> innerInsert(String sql, [List<Object?> parameters = const []]) {
    return db.rawInsert(sql, parameters);
  }

  @override
  Future<int> innerDelete(String sql, [List<Object?> parameters = const []]) {
    return db.rawDelete(sql, parameters);
  }

  @override
  Future<void> innerExecute(String sql, [List<Object?> parameters = const []]) {
    return db.execute(sql, parameters);
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

class NopDatabaseSqfliteNative extends NopDatabaseSqfliteImpl {
  NopDatabaseSqfliteNative(String path) : super(path);
  @override
  Future<void> open(
      {DatabaseOnCreate? onCreate,
      int version = 1,
      DatabaseUpgrade? onUpgrade,
      DatabaseUpgrade? onDowngrade}) async {
    Log.e('native: sqlite3');
    db = await openDatabase(path);
  }
}

/// 连接 main Isolate
class NopDatabaseSqfliteMain extends NopDatabaseSqflite
    with
        SqfliteEvent,
        ListenMixin,
        SendEventMixin,
        Resolve,
        SendMultiServerMixin,
        SqfliteEventMessager,
        SendCacheMixin,
        SendInitCloseMixin {
  NopDatabaseSqfliteMain(String path, {this.sendPortName}) : super(path);
  final String? sendPortName;
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

  @override
  Map<String, RemoteServer> regRemoteServer() {
    return super.regRemoteServer()..[sqfliteEventDefault] = RemoteServerBase();
  }

  @override
  FutureOr<void> onInitStart() {
    final sendHandleName = SendHandleName(
      sqfliteEventDefault,
      localSendHandle,
      protocols: getMessagerProtocols(sqfliteEventDefault),
      isToRemote: true, // 当前 Isolate 为 local 方,所以是要发送给remote设为true
    );

    /// 主隔离端口已经开启了，只需向端口发送[SendPortName]
    SqfliteMainIsolate.nopDatabaseSqfliteMainSendPort(name: sendPortName)!
        .send(sendHandleName);

    return super.onInitStart();
  }

  @override
  SendHandle? get remoteSendHandle =>
      sendHandleOwners[sqfliteEventDefault]?.localSendHandle;

  /// messager
  @override
  Future<int> innerDelete(String sql,
      [List<Object?> parameters = const []]) async {
    final d = await sqfliteDelete(sql, parameters);
    return d ?? 0;
  }

  @override
  Future<int> innerInsert(String sql,
      [List<Object?> parameters = const []]) async {
    final i = await sqfliteInsert(sql, parameters);
    return i ?? 0;
  }

  @override
  Future<int> innerUpdate(String sql,
      [List<Object?> parameters = const []]) async {
    final u = await sqfliteUpdate(sql, parameters);
    return u ?? 0;
  }

  @override
  Future<void> innerExecute(String sql,
      [List<Object?> parameters = const []]) async {
    return sqfliteExecute(sql, parameters);
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
