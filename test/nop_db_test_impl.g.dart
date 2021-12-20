// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nop_db_test_impl.dart';

// **************************************************************************
// Generator: GenNopGeneratorForAnnotation
// **************************************************************************

// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: non_constant_identifier_names

abstract class _GenBookDatabase extends $Database {
  late final _tables = <DatabaseTable>[myCache, indexs];

  @override
  List<DatabaseTable> get tables => _tables;

  late final myCache = GenMyCache(this);
  late final indexs = GenIndexs(this);
}

Map<String, dynamic> _MyCache_toJson(MyCache table) {
  return {'id': table.id, 'indexs': table.indexs, 'name': table.name};
}

class GenMyCache extends DatabaseTable<MyCache, GenMyCache> {
  GenMyCache($Database db) : super(db);

  @override
  final table = 'MyCache';
  final id = 'id';
  final indexs = 'indexs';
  final name = 'name';

  void updateMyCache(
      UpdateStatement<MyCache, GenMyCache> update, MyCache myCache) {
    if (myCache.id != null) update.id.set(myCache.id);

    if (myCache.indexs != null) update.indexs.set(myCache.indexs);

    if (myCache.name != null) update.name.set(myCache.name);
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS $table ($id INTEGER PRIMARY KEY, $indexs '
        'INTEGER, $name TEXT)';
  }

  static MyCache mapToTable(Map<String, dynamic> map) => MyCache(
      id: map['id'] as int?,
      indexs: map['indexs'] as int?,
      name: map['name'] as String?);

  @override
  List<MyCache> toTable(Iterable<Map<String, Object?>> query) =>
      query.map((e) => mapToTable(e)).toList();
}

extension ItemExtensionMyCache<T extends ItemExtension<GenMyCache>> on T {
  T get id => item(table.id) as T;

  T get indexs => item(table.indexs) as T;

  T get name => item(table.name) as T;

  T get genMyCache_id => id;

  T get genMyCache_indexs => indexs;

  T get genMyCache_name => name;
}

extension JoinItemMyCache<J extends JoinItem<GenMyCache>> on J {
  J get genMyCache_id => joinItem(joinTable.id) as J;

  J get genMyCache_indexs => joinItem(joinTable.indexs) as J;

  J get genMyCache_name => joinItem(joinTable.name) as J;
}

Map<String, dynamic> _Indexs_toJson(Indexs table) {
  return {
    'id': table.id,
    'indexs': table.indexs,
    'chapterName': table.chapterName
  };
}

class GenIndexs extends DatabaseTable<Indexs, GenIndexs> {
  GenIndexs($Database db) : super(db);

  @override
  final table = 'Indexs';
  final id = 'id';
  final indexs = 'indexs';
  final chapterName = 'chapterName';

  void updateIndexs(UpdateStatement<Indexs, GenIndexs> update, Indexs indexs) {
    if (indexs.id != null) update.id.set(indexs.id);

    if (indexs.indexs != null) update.indexs.set(indexs.indexs);

    if (indexs.chapterName != null) update.chapterName.set(indexs.chapterName);
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS $table ($id INTEGER PRIMARY KEY, $indexs '
        'INTEGER, $chapterName TEXT)';
  }

  static Indexs mapToTable(Map<String, dynamic> map) => Indexs(
      id: map['id'] as int?,
      indexs: map['indexs'] as int?,
      chapterName: map['chapterName'] as String?);

  @override
  List<Indexs> toTable(Iterable<Map<String, Object?>> query) =>
      query.map((e) => mapToTable(e)).toList();
}

extension ItemExtensionIndexs<T extends ItemExtension<GenIndexs>> on T {
  T get id => item(table.id) as T;

  T get indexs => item(table.indexs) as T;

  T get chapterName => item(table.chapterName) as T;

  T get genIndexs_id => id;

  T get genIndexs_indexs => indexs;

  T get genIndexs_chapterName => chapterName;
}

extension JoinItemIndexs<J extends JoinItem<GenIndexs>> on J {
  J get genIndexs_id => joinItem(joinTable.id) as J;

  J get genIndexs_indexs => joinItem(joinTable.indexs) as J;

  J get genIndexs_chapterName => joinItem(joinTable.chapterName) as J;
}
