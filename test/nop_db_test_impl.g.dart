// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nop_db_test_impl.dart';

// **************************************************************************
// Generator: GenNopGeneratorForAnnotation
// **************************************************************************

abstract class _GenBookDatabase extends $Database {
  late final _tables = <DatabaseTable>[myCache, indexs];

  @override
  List<DatabaseTable> get tables => _tables;

  late final myCache = _GenMyCache(this);
  late final indexs = _GenIndexs(this);
}

Map<String, dynamic> _MyCache_toJson(MyCache table) {
  return {'id': table.id, 'indexs': table.indexs, 'name': table.name};
}

class _GenMyCache extends DatabaseTable<MyCache, _GenMyCache> {
  _GenMyCache($Database db) : super(db);

  @override
  final table = 'MyCache';
  final id = 'id';
  final indexs = 'indexs';
  final name = 'name';

  void updateMyCache(
      UpdateStatement<MyCache, _GenMyCache> update, MyCache myCache) {
    if (myCache.id != null) update.id.set(myCache.id);

    if (myCache.indexs != null) update.indexs.set(myCache.indexs);

    if (myCache.name != null) update.name.set(myCache.name);
  }

  @override
  String createTable() {
    return 'CREATE TABLE $table ($id INTEGER PRIMARY KEY, $indexs INTEGER, '
        '$name TEXT)';
  }

  MyCache _toTable(Map<String, dynamic> map) => MyCache(
      id: map['id'] as int?,
      indexs: map['indexs'] as int?,
      name: map['name'] as String?);

  @override
  List<MyCache> toTable(Iterable<Map<String, Object?>> query) =>
      query.map((e) => _toTable(e)).toList();
}

extension ItemExtensionMyCache<T extends ItemExtension<_GenMyCache>> on T {
  T get id => item(table.id) as T;

  T get indexs => item(table.indexs) as T;

  T get name => item(table.name) as T;

  T get myCache_id => id;

  T get myCache_indexs => indexs;

  T get myCache_name => name;
}

extension JoinItemMyCache<J extends JoinItem<_GenMyCache>> on J {
  J get myCache_id => joinItem(joinTable.id) as J;

  J get myCache_indexs => joinItem(joinTable.indexs) as J;

  J get myCache_name => joinItem(joinTable.name) as J;
}

Map<String, dynamic> _Indexs_toJson(Indexs table) {
  return {
    'id': table.id,
    'indexs': table.indexs,
    'chapterName': table.chapterName
  };
}

class _GenIndexs extends DatabaseTable<Indexs, _GenIndexs> {
  _GenIndexs($Database db) : super(db);

  @override
  final table = 'Indexs';
  final id = 'id';
  final indexs = 'indexs';
  final chapterName = 'chapterName';

  void updateIndexs(UpdateStatement<Indexs, _GenIndexs> update, Indexs indexs) {
    if (indexs.id != null) update.id.set(indexs.id);

    if (indexs.indexs != null) update.indexs.set(indexs.indexs);

    if (indexs.chapterName != null) update.chapterName.set(indexs.chapterName);
  }

  @override
  String createTable() {
    return 'CREATE TABLE $table ($id INTEGER PRIMARY KEY, $indexs INTEGER, '
        '$chapterName TEXT)';
  }

  Indexs _toTable(Map<String, dynamic> map) => Indexs(
      id: map['id'] as int?,
      indexs: map['indexs'] as int?,
      chapterName: map['chapterName'] as String?);

  @override
  List<Indexs> toTable(Iterable<Map<String, Object?>> query) =>
      query.map((e) => _toTable(e)).toList();
}

extension ItemExtensionIndexs<T extends ItemExtension<_GenIndexs>> on T {
  T get id => item(table.id) as T;

  T get indexs => item(table.indexs) as T;

  T get chapterName => item(table.chapterName) as T;

  T get indexs_id => id;

  T get indexs_indexs => indexs;

  T get indexs_chapterName => chapterName;
}

extension JoinItemIndexs<J extends JoinItem<_GenIndexs>> on J {
  J get indexs_id => joinItem(joinTable.id) as J;

  J get indexs_indexs => joinItem(joinTable.indexs) as J;

  J get indexs_chapterName => joinItem(joinTable.chapterName) as J;
}
