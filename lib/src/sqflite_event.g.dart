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
    with SendEvent, SendMessage, SqfliteEventMessager {}

mixin SqfliteEventResolve on Resolve implements SqfliteEvent {
  Iterable<MapEntry<String, Type>> getResolveProtocols() sync* {
    yield const MapEntry('sqfliteEventDefault', SqfliteEventMessage);
    yield* super.getResolveProtocols();
  }

  Iterable<MapEntry<Type, List<Function>>> resolveFunctionIterable() sync* {
    yield MapEntry(SqfliteEventMessage, [
      (args) => sqfliteOpen(args[0], args[1]),
      (args) => sqfliteQuery(args[0], args[1]),
      (args) => sqfliteUpdate(args[0], args[1]),
      (args) => sqfliteInsert(args[0], args[1]),
      (args) => sqfliteDelete(args[0], args[1]),
      (args) => sqfliteExecute(args[0], args[1]),
      sqfliteOnCreate,
      (args) => sqfliteOnUpgrade(args[0], args[1]),
      (args) => sqfliteOnDowngrade(args[0], args[1])
    ]);
    yield* super.resolveFunctionIterable();
  }
}

/// implements [SqfliteEvent]
mixin SqfliteEventMessager on SendEvent, SendMessage {
  String get sqfliteEventDefault => 'sqfliteEventDefault';
  Iterable<MapEntry<String, Type>> getProtocols() sync* {
    yield MapEntry(sqfliteEventDefault, SqfliteEventMessage);
    yield* super.getProtocols();
  }

  FutureOr<void> sqfliteOpen(String path, int version) {
    return sendMessage(SqfliteEventMessage.sqfliteOpen, [path, version],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters) {
    return sendMessage(SqfliteEventMessage.sqfliteQuery, [sql, parameters],
        isolateName: sqfliteEventDefault);
  }

  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteUpdate, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  Future<int?> sqfliteInsert(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteInsert, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  Future<int?> sqfliteDelete(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteDelete, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteExecute, [sql, paramters],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteOnCreate(int version) {
    return sendMessage(SqfliteEventMessage.sqfliteOnCreate, version,
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteOnUpgrade(int oVersion, int nVersion) {
    return sendMessage(
        SqfliteEventMessage.sqfliteOnUpgrade, [oVersion, nVersion],
        isolateName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteOnDowngrade(int oVersion, int nVersion) {
    return sendMessage(
        SqfliteEventMessage.sqfliteOnDowngrade, [oVersion, nVersion],
        isolateName: sqfliteEventDefault);
  }
}
mixin MultiSqfliteEventDefaultMessagerMixin
    on SendEvent, ListenMixin, SendMultiServerMixin /*impl*/ {
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
