import 'dart:async';

import 'package:nop_annotations/nop_annotations.dart';
import 'package:nop_db/nop_db.dart';

part 'sqflite_event.g.dart';

@NopIsolateEvent()
abstract class SqfliteEvent {
  FutureOr<void> open(String path, int version);
  FutureOr<List<Map<String, Object?>>?> sqfliteQuery(
      String sql, List<Object?> parameters);

  Future<int?> sqfliteUpdate(String sql, List<Object?> paramters);

  Future<int?> sqfliteInsert(String sql, List<Object?> paramters);

  Future<int?> sqfliteDelete(String sql, List<Object?> paramters);
  FutureOr<void> sqfliteExecute(String sql, List<Object?> paramters);

  /// another
  FutureOr<void> onCreate(int version);
  FutureOr<void> onUpgrade(int oVersion, int nVersion);
  FutureOr<void> onDowngrade(int oVersion, int nVersion);
}
