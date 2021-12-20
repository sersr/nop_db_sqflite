import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:nop_db/nop_db.dart';
import 'package:utils/utils.dart';

import './nop_sqflite_impl.dart';
import 'sqflite_event.dart';

const _sqfliteMainNopDb = '_sqflite_main_nop_db';

/// 由本地调用
class SqfliteMainIsolate extends SqfliteEventResolveMain
    with
        SendEvent,
        SendEventMixin,
        SendCacheMixin,
        SendInitCloseMixin,
        ResolveMultiRecievedMixin // 需要接收[SendPortName]
{
  SqfliteMainIsolate();

  NopDatabaseSqfliteImpl? _db;
  NopDatabaseSqfliteImpl? get db => _db;

  /// 注册端口
  /// 远程隔离调用
  static SendPort? get nopDatabaseSqfliteMainSendPort =>
      IsolateNameServer.lookupPortByName(_sqfliteMainNopDb);

  static SqfliteMainIsolate? _instence;
  static SqfliteMainIsolate get _privateInstance {
    return _instence ??= SqfliteMainIsolate();
  }

  /// 提供单一实例
  /// 只提供初始化接口
  static Future<void> initMainDb() async => _privateInstance.init();

  // 添加条件判定
  bool _state = false;

  @override
  FutureOr<void> initTask() async {
    if (_state || sendPortOwners.isNotEmpty) return;
    _state = true;
    return run();
  }

  /// 权能转移到[onClose]
  @override
  FutureOr<void> closeTask() => throw UnimplementedError('unimplemented');

  @override
  FutureOr<void> onInitStart() {
    final sendPort = localSendPort.sendPort;
    if (sendPort is SendPort) {
      IsolateNameServer.removePortNameMapping(_sqfliteMainNopDb);
      IsolateNameServer.registerPortWithName(sendPort, _sqfliteMainNopDb);
    }
    return super.onInitStart();
  }

  @override
  void onError(msg, error) {
    Log.e(error, onlyDebug: false);
  }

  @override
  FutureOr<void> onClose() async {
    final old = db;
    _db = null;
    remoteSendPort = null;
    _state = false;
    dispose();
    await old?.disposeNop();
    return super.onClose();
  }

  @override
  SendHandle? remoteSendPort;

  /// 从远程接收[SendPortName]
  /// [remoteSendPort]可用
  /// 远程还在等待一个[SendPortName]
  /// 调用[onResumeListen]
  @override
  void onResume() {
    super.onResume();
    remoteSendPort = sendPortOwners.values.first.localSendPort;
    onResumeListen();
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
  FutureOr<void> sqfliteOpen(String path) async {
    Log.e('main: open sqflite3', onlyDebug: false);
    assert(remoteSendPort != null);
    final oldDb = _db;
    _db = null;
    await oldDb?.disposeNop();
    _db = NopDatabaseSqfliteImpl(path);
    return db!.open();
  }
}
