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
  Iterable<MapEntry<String, Type>> getResolveProtocols() sync* {
    yield const MapEntry('sqfliteEventDefault', SqfliteEventMessage);
    yield* super.getResolveProtocols();
  }

  Iterable<MapEntry<Type, List<Function>>> resolveFunctionIterable() sync* {
    yield MapEntry(SqfliteEventMessage, [
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
    yield* super.resolveFunctionIterable();
  }

  _sqfliteOpen_0(args) => sqfliteOpen(args[0], args[1]);
  _sqfliteQuery_1(args) => sqfliteQuery(args[0], args[1]);
  _sqfliteUpdate_2(args) => sqfliteUpdate(args[0], args[1]);
  _sqfliteInsert_3(args) => sqfliteInsert(args[0], args[1]);
  _sqfliteDelete_4(args) => sqfliteDelete(args[0], args[1]);
  _sqfliteExecute_5(args) => sqfliteExecute(args[0], args[1]);
  _sqfliteOnCreate_6(args) => sqfliteOnCreate(args);
  _sqfliteOnUpgrade_7(args) => sqfliteOnUpgrade(args[0], args[1]);
  _sqfliteOnDowngrade_8(args) => sqfliteOnDowngrade(args[0], args[1]);
}

/// implements [SqfliteEvent]
mixin SqfliteEventMessager on SendEvent {
  SendEvent get sendEvent;
  String get sqfliteEventDefault => 'sqfliteEventDefault';
  Iterable<MapEntry<String, Type>> getProtocols() sync* {
    yield MapEntry(sqfliteEventDefault, SqfliteEventMessage);
    yield* super.getProtocols();
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
}

abstract class MultiSqfliteEventDefaultResolveMain
    with SendEvent, ListenMixin, Resolve, ResolveMultiRecievedMixin {}
