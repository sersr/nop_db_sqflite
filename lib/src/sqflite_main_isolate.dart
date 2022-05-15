import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:nop/nop.dart';

import './nop_sqflite_impl.dart';
import 'sqflite_event.dart';

const _sqfliteMainNopDb = '_sqflite_main_nop_db';

/// 由本地调用
class SqfliteMainIsolate
    with
        SendEventMixin,
        SendCacheMixin,
        SendInitCloseMixin,
        ListenMixin,
        Resolve,
        SqfliteEventResolve,
        ResolveMultiRecievedMixin {
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
  static Future<void> initMainDb() => _privateInstance.init();
  static bool native = true;

  // 添加条件判定
  bool _state = false;

  @override
  FutureOr<void> initTask() async {
    if (_state) return;
    _state = true;
    return run();
  }

  /// 权能转移到[onClose]
  @override
  FutureOr<void> closeTask() => throw UnimplementedError('unimplemented');

  @override
  FutureOr<void> onInitStart() {
    final sendPort = localSendHandle.sendPort;
    if (sendPort is SendPort) {
      IsolateNameServer.removePortNameMapping(_sqfliteMainNopDb);
      IsolateNameServer.registerPortWithName(sendPort, _sqfliteMainNopDb);
    }
    return super.onInitStart();
  }

  @override
  bool onListenReceivedSendHandle(SendHandleName sendHandleName) {
    if (receivedSendHandleOwners.keys.contains(sendHandleName.name)) {
      return true;
    }
    final result = super.onListenReceivedSendHandle(sendHandleName);
    remoteSendHandle = receivedSendHandleOwners.values.first.localSendHandle;
    remoteSendHandle!.send(SendHandleName(sendHandleName.name, localSendHandle,
        protocols: getResolveProtocols()[sendHandleName.name]));
    return result;
  }

  @override
  void onError(msg, error) {
    Log.e(error, onlyDebug: false);
  }

  @override
  FutureOr<void> onClose() async {
    final old = db;
    _db = null;
    remoteSendHandle = null;
    _state = false;
    dispose();
    await old?.disposeNop();
    return super.onClose();
  }

  @override
  SendHandle? remoteSendHandle;

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
    assert(remoteSendHandle != null);
    final oldDb = _db;
    _db = null;
    await oldDb?.disposeNop();
    _db =
        native ? NopDatabaseSqfliteNative(path) : NopDatabaseSqfliteImpl(path);
    return db!.open();
  }
}
