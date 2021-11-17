// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sqflite_event.dart';

// **************************************************************************
// Generator: IsolateEventGeneratorForAnnotation
// **************************************************************************

enum SqfliteEventMessage {
  open,
  sqfliteQuery,
  sqfliteUpdate,
  sqfliteInsert,
  sqfliteDelete,
  sqfliteExecute,
  onCreate,
  onUpgrade,
  onDowngrade
}

abstract class SqfliteEventResolveMain extends SqfliteEvent
    with Resolve, SqfliteEventResolve {
  @override
  bool resolve(resolveMessage) {
    if (remove(resolveMessage)) return true;
    if (resolveMessage is! IsolateSendMessage) return false;
    return super.resolve(resolveMessage);
  }
}

abstract class SqfliteEventMessagerMain extends SqfliteEvent
    with SqfliteEventMessager {}

mixin SqfliteEventResolve on Resolve, SqfliteEvent {
  late final _sqfliteEventResolveFuncList = List<DynamicCallback>.unmodifiable([
    _open_0,
    _sqfliteQuery_1,
    _sqfliteUpdate_2,
    _sqfliteInsert_3,
    _sqfliteDelete_4,
    _sqfliteExecute_5,
    _onCreate_6,
    _onUpgrade_7,
    _onDowngrade_8
  ]);

  @override
  bool resolve(resolveMessage) {
    if (resolveMessage is IsolateSendMessage) {
      final type = resolveMessage.type;
      if (type is SqfliteEventMessage) {
        dynamic result;
        try {
          result = _sqfliteEventResolveFuncList
              .elementAt(type.index)(resolveMessage.args);
          receipt(result, resolveMessage);
        } catch (e) {
          receipt(result, resolveMessage, e);
        }
        return true;
      }
    }
    return super.resolve(resolveMessage);
  }

  FutureOr<void> _open_0(args) => open(args[0], args[1]);
  FutureOr<List<Map<String, Object?>>?> _sqfliteQuery_1(args) =>
      sqfliteQuery(args[0], args[1]);
  Future<int?> _sqfliteUpdate_2(args) => sqfliteUpdate(args[0], args[1]);
  Future<int?> _sqfliteInsert_3(args) => sqfliteInsert(args[0], args[1]);
  Future<int?> _sqfliteDelete_4(args) => sqfliteDelete(args[0], args[1]);
  FutureOr<void> _sqfliteExecute_5(args) => sqfliteExecute(args[0], args[1]);
  FutureOr<void> _onCreate_6(args) => onCreate(args);
  FutureOr<void> _onUpgrade_7(args) => onUpgrade(args[0], args[1]);
  FutureOr<void> _onDowngrade_8(args) => onDowngrade(args[0], args[1]);
}

/// implements [SqfliteEvent]
mixin SqfliteEventMessager {
  SendEvent get sendEvent;

  FutureOr<void> open(String path, int version) async {
    return sendEvent.sendMessage(SqfliteEventMessage.open, [path, version]);
  }

  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters) async {
    return sendEvent
        .sendMessage(SqfliteEventMessage.sqfliteQuery, [sql, parameters]);
  }

  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters) async {
    return sendEvent
        .sendMessage(SqfliteEventMessage.sqfliteUpdate, [sql, paramters]);
  }

  Future<int?> sqfliteInsert(String sql, List<Object?> paramters) async {
    return sendEvent
        .sendMessage(SqfliteEventMessage.sqfliteInsert, [sql, paramters]);
  }

  Future<int?> sqfliteDelete(String sql, List<Object?> paramters) async {
    return sendEvent
        .sendMessage(SqfliteEventMessage.sqfliteDelete, [sql, paramters]);
  }

  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters) async {
    return sendEvent
        .sendMessage(SqfliteEventMessage.sqfliteExecute, [sql, paramters]);
  }

  FutureOr<void> onCreate(int version) async {
    return sendEvent.sendMessage(SqfliteEventMessage.onCreate, version);
  }

  FutureOr<void> onUpgrade(int oVersion, int nVersion) async {
    return sendEvent
        .sendMessage(SqfliteEventMessage.onUpgrade, [oVersion, nVersion]);
  }

  FutureOr<void> onDowngrade(int oVersion, int nVersion) async {
    return sendEvent
        .sendMessage(SqfliteEventMessage.onDowngrade, [oVersion, nVersion]);
  }
}
