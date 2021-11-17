import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nop_annotations/nop_annotations.dart';
import 'package:nop_db/nop_db.dart';
import 'package:nop_db_sqflite/nop_db_sqflite.dart';

part 'nop_db_test_impl.g.dart';

class MyCache extends Table {
  MyCache({this.id, this.name, this.indexs});
  @NopItem(primaryKey: true)
  final int? id;

  final int? indexs;
  final String? name;

  @override
  Map<String, dynamic> toJson() => _MyCache_toJson(this);
}

class Indexs extends Table {
  Indexs({this.indexs, this.chapterName, this.id});
  @NopItem(primaryKey: true)
  final int? id;

  final int? indexs;
  final String? chapterName;

  @override
  Map<String, dynamic> toJson() => _Indexs_toJson(this);
}

@Nop(tables: [MyCache, Indexs])
class BookDatabase extends _GenBookDatabase {
  String path = NopDatabase.memory;

  @visibleForTesting
  bool test = false;
  bool? _useFfi;

  bool get useFfi => _useFfi ??= _getUseFfi();

  bool _getUseFfi() {
    var _uf = false;
    if (test) _uf = true;
    if (!_uf) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.windows:
        case TargetPlatform.linux:
          _uf = true;
          break;
        default:
          _uf = false;
      }
    }
    return _uf;
  }

  FutureOr<void> initDb() {
    return _initSqfitedb().then(setDb);
  }

  Future<NopDatabase> _initSqfitedb() {
    return NopDatabaseSqflite.openSqfite(path,
        version: version, onCreate: onCreate, useFfi: useFfi);
  }

  int get version => 1;
}
