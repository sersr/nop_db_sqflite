import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:nop_db/nop_db.dart';
import 'package:utils/utils.dart';

import './nop_sqflite_impl.dart';
import 'sqflite_event.dart';

const _sqfliteMainNopDb = '_sqflite_main_nop_db';
const _sqfliteIsolateNopDb = '_sqflite_isolate_nop_db';

/// 由本地调用
class SqfliteMainIsolate extends SqfliteEventResolveMain
    with
        SendEvent,
        SendEventMixin,
        SendCacheMixin,
        SendInitCloseMixin,
        SqfliteEventMessager {
  SqfliteMainIsolate();

  NopDatabaseSqfliteImpl? _db;
  NopDatabaseSqfliteImpl? get db => _db;

  /// 本地调用
  static SendPort? get sqfliteMainIsolateSendPort =>
      IsolateNameServer.lookupPortByName(_sqfliteIsolateNopDb);

  /// 远程隔离调用
  static SendPort? get nopDatabaseSqfliteMainSendPort =>
      IsolateNameServer.lookupPortByName(_sqfliteMainNopDb);

  /// 远程隔离调用
  static SendPortOwner? getNopDatabaseSqfliteMainOwner(SendPort sendPort) {
    IsolateNameServer.removePortNameMapping(_sqfliteIsolateNopDb);
    IsolateNameServer.registerPortWithName(sendPort, _sqfliteIsolateNopDb);

    final localSendPort = nopDatabaseSqfliteMainSendPort;
    if (localSendPort != null) {
      return SendPortOwner(
          localSendPort: localSendPort, remoteSendPort: sendPort);
    }
  }

  static SqfliteMainIsolate? _instence;
  static SqfliteMainIsolate get instance {
    return _instence ??= SqfliteMainIsolate();
  }

  static Future<void> initMainDb() async => instance.init();
  @override
  FutureOr<void> initTask() => run();
  @override
  FutureOr<void> closeTask() => onClose();

  @override
  void initStateListen(void Function(FutureOr<void> work) add) {
    IsolateNameServer.removePortNameMapping(_sqfliteMainNopDb);
    IsolateNameServer.registerPortWithName(localSendPort, _sqfliteMainNopDb);
    super.initStateListen(add);
  }

  @override
  bool listen(message) {
    if (add(message)) return true;
    return super.listen(message);
  }

  @override
  void onError(msg, error) {
    Log.e(error, onlyDebug: false);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    sendPortOwner = null;
    final old = db;
    _db = null;
    return old?.disposeNop();
  }

  @override
  FutureOr<bool> onClose() async {
    await dispose();
    return super.onClose();
  }

  SendPortOwner? sendPortOwner;

  @override
  SendPort? get remoteSendPort => sendPortOwner?.localSendPort;

  @override
  void onResumeListen() {
    onResume();
    super.onResumeListen();
  }

  @override
  SendPortOwner? getSendPortOwner(key) {
    return sendPortOwner ?? super.getSendPortOwner(key);
  }

  /// messager : 发送消息
  FutureOr<void> _onCreate(NopDatabase db, int version) {
    Log.w('messager: onCreate');
    return sqfliteOnCreate(version);
  }

  FutureOr<void> _onUpgrade(NopDatabase db, int oldVersin, int newVersion) {
    return sqfliteOnUpgrade(oldVersin, newVersion);
  }

  FutureOr<void> _onDowngrade(NopDatabase db, int oldVersion, int newVersion) {
    return sqfliteOnDowngrade(oldVersion, newVersion);
  }

  /// ------------------ message end ----------------

  /// resolve : 处理消息
  @override
  Future<int?> sqfliteDelete(String sql, List<Object?> paramters) async {
    return db?.innerDelete(sql, paramters);
  }

  @override
  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters) async {
    return db?.innerExecute(sql, paramters);
  }

  @override
  Future<int?> sqfliteInsert(String sql, List<Object?> paramters) async {
    return db?.innerInsert(sql, paramters);
  }

  @override
  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters) async {
    return db?.innerQuery(sql, parameters);
  }

  @override
  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters) async {
    return db?.innerUpdate(sql, paramters);
  }

  @override
  FutureOr<void> sqfliteOpen(String path, int version) async {
    Log.e('main: open sqflite3', onlyDebug: false);
    try {
      final remoteSendPort = sqfliteMainIsolateSendPort;
      if (remoteSendPort != null) {
        sendPortOwner = SendPortOwner(
            localSendPort: remoteSendPort, remoteSendPort: localSendPort);
        onResumeListen();
      }
    } catch (e) {
      Log.w(e, onlyDebug: false);
    }

    final oldDb = _db;
    _db = null;
    await oldDb?.disposeNop();
    _db = NopDatabaseSqfliteImpl(path);
    return db!.open(
      version: version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
      // useFfi: false,
    );
  }

  /// --------------- resolve end -------------

}
