// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sqflite_event.dart';

// **************************************************************************
// Generator: IsolateEventGeneratorForAnnotation
// **************************************************************************

// ignore_for_file: annotate_overrides
// ignore_for_file: curly_braces_in_flow_control_structures
enum SqfliteEventMessage {
  sqfliteOpen,
  sqfliteQuery,
  sqfliteUpdate,
  sqfliteInsert,
  sqfliteDelete,
  sqfliteExecute,
  sqfliteOnCreate,
  sqfliteOnUpgrade,
  sqfliteOnDowngrade
}

abstract class SqfliteEventResolveMain extends SqfliteEvent
    with ListenMixin, Resolve, SqfliteEventResolve {}

abstract class SqfliteEventMessagerMain extends SqfliteEvent
    with SendEvent, SqfliteEventMessager {}

mixin SqfliteEventResolve on Resolve implements SqfliteEvent {
  late final _sqfliteEventResolveFuncList = List<DynamicCallback>.unmodifiable([
    _sqfliteOpen_0,
    _sqfliteQuery_1,
    _sqfliteUpdate_2,
    _sqfliteInsert_3,
    _sqfliteDelete_4,
    _sqfliteExecute_5,
    _sqfliteOnCreate_6,
    _sqfliteOnUpgrade_7,
    _sqfliteOnDowngrade_8
  ]);
  bool onSqfliteEventResolve(message) => false;
  @override
  bool resolve(resolveMessage) {
    if (resolveMessage is IsolateSendMessage) {
      final type = resolveMessage.type;
      if (type is SqfliteEventMessage) {
        dynamic result;
        try {
          if (onSqfliteEventResolve(resolveMessage)) return true;
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

  FutureOr<void> _sqfliteOpen_0(args) => sqfliteOpen(args[0], args[1]);
  FutureOr<List<Map<String, Object?>>?> _sqfliteQuery_1(args) =>
      sqfliteQuery(args[0], args[1]);
  Future<int?> _sqfliteUpdate_2(args) => sqfliteUpdate(args[0], args[1]);
  Future<int?> _sqfliteInsert_3(args) => sqfliteInsert(args[0], args[1]);
  Future<int?> _sqfliteDelete_4(args) => sqfliteDelete(args[0], args[1]);
  FutureOr<void> _sqfliteExecute_5(args) => sqfliteExecute(args[0], args[1]);
  FutureOr<void> _sqfliteOnCreate_6(args) => sqfliteOnCreate(args);
  FutureOr<void> _sqfliteOnUpgrade_7(args) =>
      sqfliteOnUpgrade(args[0], args[1]);
  FutureOr<void> _sqfliteOnDowngrade_8(args) =>
      sqfliteOnDowngrade(args[0], args[1]);
}

/// implements [SqfliteEvent]
mixin SqfliteEventMessager on SendEvent {
  SendEvent get sendEvent;
  String get sqfliteEventDefault => 'sqfliteEventDefault';
  Iterable<Type> getProtocols(String name) sync* {
    if (name == sqfliteEventDefault) yield SqfliteEventMessage;
    yield* super.getProtocols(name);
  }

  FutureOr<void> sqfliteOpen(String path, int version) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteOpen, [path, version],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteQuery, [sql, parameters],
        isolateName: sqfliteEventDefault);
  }

  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteUpdate, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  Future<int?> sqfliteInsert(String sql, List<Object?> paramters) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteInsert, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  Future<int?> sqfliteDelete(String sql, List<Object?> paramters) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteDelete, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteExecute, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteOnCreate(int version) {
    return sendEvent.sendMessage(SqfliteEventMessage.sqfliteOnCreate, version,
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteOnUpgrade(int oVersion, int nVersion) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteOnUpgrade, [oVersion, nVersion],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteOnDowngrade(int oVersion, int nVersion) {
    return sendEvent.sendMessage(
        SqfliteEventMessage.sqfliteOnDowngrade, [oVersion, nVersion],
        isolateName: sqfliteEventDefault);
  }
}
mixin MultiSqfliteEventDefaultMessagerMixin
    on SendEvent, ListenMixin, SendMultiServerMixin /*impl*/ {
  String get defaultSendPortOwnerName => 'sqfliteEventDefault';
  Future<RemoteServer> createRemoteServerSqfliteEventDefault();

  Iterable<MapEntry<String, CreateRemoteServer>>
      createRemoteServerIterable() sync* {
    yield MapEntry(
        'sqfliteEventDefault', createRemoteServerSqfliteEventDefault);
    yield* super.createRemoteServerIterable();
  }

  Iterable<MapEntry<String, List<Type>>> allProtocolsItreable() sync* {
    yield const MapEntry('sqfliteEventDefault', [SqfliteEventMessage]);
    yield* super.allProtocolsItreable();
  }
}

abstract class MultiSqfliteEventDefaultResolveMain
    with
        ListenMixin,
        Resolve,
        MultiSqfliteEventDefaultMixin,
        SqfliteEventResolve {}

mixin MultiSqfliteEventDefaultMixin on Resolve {
  void onResumeListen() {
    if (remoteSendPort != null)
      remoteSendPort!.send(SendPortName(
        'sqfliteEventDefault',
        localSendPort,
        protocols: [SqfliteEventMessage],
      ));
    super.onResumeListen();
  }
}
