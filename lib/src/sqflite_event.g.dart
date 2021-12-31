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
  sqfliteExecute
}

abstract class SqfliteEventResolveMain extends SqfliteEvent
    with ListenMixin, Resolve, SqfliteEventResolve {}

abstract class SqfliteEventMessagerMain extends SqfliteEvent
    with SendEvent, SendMessage, SqfliteEventMessager {}

mixin SqfliteEventResolve on Resolve implements SqfliteEvent {
  List<MapEntry<String, Type>> getResolveProtocols() {
    return super.getResolveProtocols()
      ..add(const MapEntry('sqfliteEventDefault', SqfliteEventMessage));
  }

  List<MapEntry<Type, List<Function>>> resolveFunctionIterable() {
    return super.resolveFunctionIterable()
      ..add(MapEntry(SqfliteEventMessage, [
        sqfliteOpen,
        (args) => sqfliteQuery(args[0], args[1]),
        (args) => sqfliteUpdate(args[0], args[1]),
        (args) => sqfliteInsert(args[0], args[1]),
        (args) => sqfliteDelete(args[0], args[1]),
        (args) => sqfliteExecute(args[0], args[1])
      ]));
  }
}

/// implements [SqfliteEvent]
mixin SqfliteEventMessager on SendEvent, SendMessage {
  String get sqfliteEventDefault => 'sqfliteEventDefault';
  List<MapEntry<String, Type>> getProtocols() {
    return super.getProtocols()
      ..add(MapEntry(sqfliteEventDefault, SqfliteEventMessage));
  }

  FutureOr<void> sqfliteOpen(String path) {
    return sendMessage(SqfliteEventMessage.sqfliteOpen, path,
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
}
mixin MultiSqfliteEventDefaultMessagerMixin
    on SendEvent, ListenMixin, SendMultiServerMixin /*impl*/ {
  Future<RemoteServer> createRemoteServerSqfliteEventDefault();

  List<MapEntry<String, CreateRemoteServer>> createRemoteServerIterable() {
    return super.createRemoteServerIterable()
      ..add(MapEntry(
          'sqfliteEventDefault', Left(createRemoteServerSqfliteEventDefault)));
  }
}

abstract class MultiSqfliteEventDefaultResolveMain
    with SendEvent, ListenMixin, Resolve, ResolveMultiRecievedMixin {}
