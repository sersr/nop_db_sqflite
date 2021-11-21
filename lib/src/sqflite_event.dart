import 'dart:async';

import 'package:nop_annotations/nop_annotations.dart';
import 'package:nop_db/nop_db.dart';

part 'sqflite_event.g.dart';

@NopIsolateEvent()
abstract class SqfliteEvent {
  FutureOr<void> sqfliteOpen(String path, int version);
  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters);

  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters);

  Future<int?> sqfliteInsert(String sql, List<Object?> paramters);

  Future<int?> sqfliteDelete(String sql, List<Object?> paramters);
  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters);

  /// another
  FutureOr<void> sqfliteOnCreate(int version);
  FutureOr<void> sqfliteOnUpgrade(int oVersion, int nVersion);
  FutureOr<void> sqfliteOnDowngrade(int oVersion, int nVersion);
}
