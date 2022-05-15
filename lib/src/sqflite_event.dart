import 'dart:async';
import 'package:nop/nop.dart';
part 'sqflite_event.g.dart';

@NopServerEvent()
abstract class SqfliteEvent {
  FutureOr<void> sqfliteOpen(String path);
  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters);

  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters);

  Future<int?> sqfliteInsert(String sql, List<Object?> paramters);

  Future<int?> sqfliteDelete(String sql, List<Object?> paramters);
  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters);
}
