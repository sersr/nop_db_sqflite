// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sqflite_event.dart';

// **************************************************************************
// Generator: ServerEventGeneratorForAnnotation
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

/// 主入口
abstract class MultiSqfliteEventDefaultMessagerMain
    with
        SqfliteEvent,
        ListenMixin,
        SendEventMixin,
        SendMultiServerMixin,
        SqfliteEventMessager {
  RemoteServer get sqfliteEventDefaultRemoteServer;
  Map<String, RemoteServer> regRemoteServer() {
    return super.regRemoteServer()
      ..['sqfliteEventDefault'] = sqfliteEventDefaultRemoteServer;
  }
}

/// sqfliteEventDefault Server
abstract class MultiSqfliteEventDefaultResolveMain
    with ListenMixin, Resolve, SqfliteEventResolve {
  MultiSqfliteEventDefaultResolveMain(
      {required ServerConfigurations configurations})
      : remoteSendHandle = configurations.sendHandle;
  final SendHandle remoteSendHandle;
}

mixin SqfliteEventResolve on Resolve implements SqfliteEvent {
  Map<String, List<Type>> getResolveProtocols() {
    return super.getResolveProtocols()
      ..putIfAbsent('sqfliteEventDefault', () => []).add(SqfliteEventMessage);
  }

  Map<Type, List<Function>> resolveFunctionIterable() {
    return super.resolveFunctionIterable()
      ..[SqfliteEventMessage] = [
        sqfliteOpen,
        (args) => sqfliteQuery(args[0], args[1]),
        (args) => sqfliteUpdate(args[0], args[1]),
        (args) => sqfliteInsert(args[0], args[1]),
        (args) => sqfliteDelete(args[0], args[1]),
        (args) => sqfliteExecute(args[0], args[1])
      ];
  }
}

/// implements [SqfliteEvent]
mixin SqfliteEventMessager on SendEvent, Messager {
  String get sqfliteEventDefault => 'sqfliteEventDefault';
  Map<String, List<Type>> getProtocols() {
    return super.getProtocols()
      ..putIfAbsent(sqfliteEventDefault, () => []).add(SqfliteEventMessage);
  }

  FutureOr<void> sqfliteOpen(String path) {
    return sendMessage(SqfliteEventMessage.sqfliteOpen, path,
        serverName: sqfliteEventDefault);
  }

  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters) {
    return sendMessage(SqfliteEventMessage.sqfliteQuery, [sql, parameters],
        serverName: sqfliteEventDefault);
  }

  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteUpdate, [sql, paramters],
        serverName: sqfliteEventDefault);
  }

  Future<int?> sqfliteInsert(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteInsert, [sql, paramters],
        serverName: sqfliteEventDefault);
  }

  Future<int?> sqfliteDelete(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteDelete, [sql, paramters],
        serverName: sqfliteEventDefault);
  }

  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters) {
    return sendMessage(SqfliteEventMessage.sqfliteExecute, [sql, paramters],
        serverName: sqfliteEventDefault);
  }
}
