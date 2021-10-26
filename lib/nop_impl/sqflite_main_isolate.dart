import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:nop_db/database/nop.dart';
import 'package:nop_db/nop_db.dart';
import 'package:utils/utils.dart';

import './nop_sqflite_impl.dart';
import 'sqflite_event.dart';

const _sqfliteMainNopDb = '_sqflite_main_nop_db';
const _sqfliteIsolateNopDb = '_sqflite_isolate_nop_db';

/// 在 main Isolate 创建
///
/// 因为 sqflite 要与平台通信，只能在 main Isoalte 创建
///
/// 目前实现为单例模式，一个数据库文件路径
///
/// 与[SqfliteDbIsolate]比较：调用的函数时一一对应的，`Messager`是默认实现，所以最重要的
/// 是`Resolve`的覆盖实现（因为mixin`SqfliteEventMessager`所以不会由错误提示）
class SqfliteMainIsolate extends SqfliteEventResolveMain
    with SqfliteEventMessager, SendEventPortMixin {
  NopDatabaseSqfliteImpl? _db;
  NopDatabaseSqfliteImpl get db => _db!;
  SqfliteMainIsolate();
  @override
  late SendEvent sendEvent = this;
  static SqfliteMainIsolate? _instence;
  static SqfliteMainIsolate get instance {
    return _instence ??= SqfliteMainIsolate();
  }

  static void initMainDb() {
    instance.init();
  }

  void init() {
    rcPort?.close();
    IsolateNameServer.removePortNameMapping(_sqfliteMainNopDb);

    final _rcPort = ReceivePort();
    IsolateNameServer.registerPortWithName(_rcPort.sendPort, _sqfliteMainNopDb);
    rcPort = _rcPort;
    _rcPort.listen(_listen);
  }

  void _listen(message) {
    if (resolve(message)) return;
  }

  ReceivePort? rcPort;

  @override
  final sp = null;

  /// resolve
  @override
  Future<int?> sqfliteDelete(String sql, List<Object?> paramters) {
    return db.innerDelete(sql, paramters);
  }

  @override
  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters) {
    return db.innerExecute(sql, paramters);
  }

  @override
  Future<int?> sqfliteInsert(String sql, List<Object?> paramters) {
    return db.innerInsert(sql, paramters);
  }

  @override
  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters) {
    return db.innerQuery(sql, parameters);
  }

  @override
  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters) {
    return db.innerUpdate(sql, paramters);
  }

  @override
  FutureOr<void> open(String path, int version) async {
    Log.e('main: open sqflite3....', onlyDebug: false);
    await _db?.dispose();
    _db = NopDatabaseSqfliteImpl(path);
    return db.open(
      version: version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
      useFfi: false,
    );
  }

  /// messager
  FutureOr<void> _onCreate(NopDatabase db, int version) {
    Log.w('messager: onCreate');
    return onCreate(version);
  }

  FutureOr<void> _onUpgrade(NopDatabase db, int oldVersin, int newVersion) {
    return onUpgrade(oldVersin, newVersion);
  }

  FutureOr<void> _onDowngrade(NopDatabase db, int oldVersion, int newVersion) {
    return onDowngrade(oldVersion, newVersion);
  }

  late SendPort sendPort =
      IsolateNameServer.lookupPortByName(_sqfliteIsolateNopDb)!;

  @override
  void send(message) {
    sendPort.send(message);
  }

  @override
  Future<void> dispose() {
    super.dispose();
    rcPort?.close();
    rcPort = null;
    return db.dispose();
  }
}

/// Isolate
/// 由隔离开启端口
class SqfliteDbIsolate extends SqfliteEventResolveMain
    with SqfliteEventMessager, SendEventPortMixin {
  // SqfliteDbIsolate(String path) : super(path);;
  SqfliteDbIsolate._(this.db);

  static SqfliteDbIsolate? _instance;
  static SqfliteDbIsolate create(NopDatabaseSqfliteMain db) {
    return _instance ??= SqfliteDbIsolate._(db);
  }

  void init() {
    rcPort?.close();
    IsolateNameServer.removePortNameMapping(_sqfliteIsolateNopDb);

    final _receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, _sqfliteIsolateNopDb);
    rcPort = _receivePort;
    _receivePort.listen(listen);
  }

  ReceivePort? rcPort;
  void listen(message) {
    if (resolve(message)) return;
  }

  /// messager
  Future<int> innerDelete(String sql,
      [List<Object?> paramters = const []]) async {
    final d = await sqfliteDelete(sql, paramters);
    return d ?? 0;
  }

  Future<int> innerInsert(String sql,
      [List<Object?> paramters = const []]) async {
    final i = await sqfliteInsert(sql, paramters);
    return i ?? 0;
  }

  Future<int> innerUpdate(String sql,
      [List<Object?> paramters = const []]) async {
    final u = await sqfliteUpdate(sql, paramters);
    return u ?? 0;
  }

  Future<void> innerExecute(String sql,
      [List<Object?> paramters = const []]) async {
    return sqfliteExecute(sql, paramters);
  }

  Future<List<Map<String, Object?>>> innerQuery(String sql,
      [List<Object?> parameters = const []]) async {
    final q = await sqfliteQuery(sql, parameters);
    return q ?? const [];
  }

  @override
  SendEvent get sendEvent => this;

  @override
  void send(message) {
    sendPort.send(message);
  }

  /// Resolve
  @override
  FutureOr<void> onCreate(int version) {
    assert(db.onCreate != null);
    Log.w('Resolve: onCreate');
    return db.onCreate?.call(db, version);
  }

  @override
  FutureOr<void> onUpgrade(int oldVersion, int newVersion) {
    return db.onUpgrade?.call(db, oldVersion, newVersion);
  }

  @override
  FutureOr<void> onDowngrade(int oldVersion, int newVersion) {
    return db.onDowngrade?.call(db, oldVersion, newVersion);
  }

  late SendPort sendPort =
      IsolateNameServer.lookupPortByName(_sqfliteMainNopDb)!;

  final NopDatabaseSqfliteMain db;

  @override
  final sp = null;

  @override
  void dispose() {
    super.dispose();
    rcPort?.close();
    rcPort = null;
  }
}
