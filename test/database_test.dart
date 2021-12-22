// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'nop_db_test_impl.dart';

void main() async {
// ensureInitialized();
  final db = BookDatabase();
  db.test = true;
  await db.initDb();

  final genMyCacheTable = db.myCache;
  final indexsTable = db.indexs;
  test('database', () async {
    final i = genMyCacheTable.insert
        .insertTable(MyCache(name: 'genMyCache', indexs: 9));
    print(i);
    i.go;
    genMyCacheTable.insert
        .insertTable(MyCache(name: 'genMyCache2', indexs: 10))
        .go;

    indexsTable.insert.insertTable(Indexs(chapterName: 'index', indexs: 1)).go;

    indexsTable.insert.insertTable(Indexs(chapterName: 'index2', indexs: 2)).go;

    indexsTable.insert
        .insertTable(Indexs(chapterName: 'index3', indexs: 10))
        .go; // q // t
    indexsTable.insert
        .insertTable(Indexs(chapterName: 'indexTable x', indexs: 100))
        .go;

    indexsTable.insert
        .insertTable(Indexs(chapterName: 'one', indexs: 9))
        .go; // q
    indexsTable.insert
        .insertTable(Indexs(chapterName: 'genMyCache', indexs: 9))
        .go; // q genMyCache => hello world2
    indexsTable.insert
        .insertTable(Indexs(chapterName: 'one', indexs: 10))
        .go; // q
    indexsTable.insert
        .insertTable(Indexs(chapterName: 'indexhello', indexs: 9))
        .go; // q // t

    final query = genMyCacheTable.query;
    query.join(indexsTable)..on.genMyCache_name.eq.genIndexs_chapterName;

    print(query);

    dashed;
    print(query.goToTable);

    final q = genMyCacheTable.query;
    q.join(indexsTable)
      ..select.count.all
      ..using.genIndexs_indexs
      ..where.genIndexs_id.greateThan(1)
      ..orderBy.genIndexs_indexs
      ..joinEnd.let((e) => print('e    |: $e'));
    // q.order.orderBy.genMyCache_id;
    // print('q: $q');
    dashed;

    print(q.go);
    final qx = genMyCacheTable.query.genMyCache_name.join(indexsTable)
      ..on.genIndexs_chapterName.like('index')
      ..out
      ..where.genIndexs_indexs.lessThan(12)
      ..or.genMyCache_indexs.lessThan(1);

    print(qx.joinEnd);
    final gl = qx.joinEnd.go;
    if (gl is Future<List<Map<String, Object?>>>) {
      print('\n\n\n ');
      gl.then((v) => print('hello ......\n\n\n $v'));
    } else {
      print(gl);
    }
    genMyCacheTable.query.genMyCache_id.where
      ..genMyCache_id.lessThan(1000).and
      ..priority.genMyCache_name.like('hello')
      ..or.genMyCache_indexs.greateThan(1).out
      ..and.genMyCache_id.equalTo(100)
      ..having.count.genMyCache_id
      ..whereEnd.let((s) {
        expect(s.updateItems.toString(), '{MyCache.id}', reason: 'P: $s');
        s
          ..where.coverWith([1, 'nihao', 2, 3])
          ..let((s) => print('cover|: $s'));
      });
    genMyCacheTable.query
      ..select.count.genMyCache_id.push.genMyCache_id.push
      ..let((s) {
        expect(
            s.toString(),
            'sql: "SELECT COUNT(MyCache.id), MyCache.id FROM MyCache", [] | '
            'tables: [MyCache] | updateItems: {MyCache.id}');

        s.go;
      });

    genMyCacheTable.query.join(indexsTable)
      ..select.let((select) => select
        ..count.genMyCache_id.push
        ..count.genIndexs_chapterName.push
        ..count.all.push)
      ..where.genMyCache_indexs.eq.genMyCache_id
      ..and.genIndexs_chapterName.like('hallal')
      ..orderBy.genIndexs_indexs.asc
      ..limit.withValue(2).offset(2)
      ..joinEnd.let((s) {
        print('x2   |: $s');
        print(s.goToTable);
      });

    final using = genMyCacheTable.query.join(indexsTable)
      ..select.genMyCache_id.as('MyCacheId')
      ..let((exp) => exp.using.indexs.id);

    expect(
        using.joinEnd.toString(),
        'sql: "SELECT MyCache.id AS MyCacheId FROM MyCache INNER JOIN Indexs'
        ' USING (indexs,id)", [] | tables: [MyCache, Indexs] | updateItems: '
        '{MyCache.indexs, Indexs.indexs, MyCache.id, Indexs.id}',
        reason: using.toString());
    dashed;

    q.watch.listen((event) => print('q_____listen: ${event.join('\n')}'));

    await Future.delayed(Duration.zero);

    final u = indexsTable.update.chapterName.set('hello world')
      ..where.id.equalTo(4);

    print(u);
    u.go;
    dashed;
    genMyCacheTable.query.join(indexsTable).where
      ..genMyCache_name.lessThan(111)
      ..or.genIndexs_chapterName.greateThan(1).back.joinEnd.let((s) {
        print('join: $s');
      });

    indexsTable.update.let((s) => s
      ..chapterName.set('hello world2')
      ..where.id.equalTo(3))
      ..let((s) {
        print('update: $s');
        s.go;
      });
    indexsTable.query.indexs.where
      ..genIndexs_id.lessThan(10)
      ..and.genIndexs_chapterName.lessThan(1)
      ..whereEnd.let((s) => print('x: $s'));

    final table2q = indexsTable.query.indexs.let((s) => s.where
      ..genIndexs_id.lessThan(10)
      ..and.genIndexs_chapterName.isNotNull
      ..whereEnd.let((s) => print('table2q: $s')));

    final t = genMyCacheTable.query.let((s) {
      s.where
        ..indexs.in_.query(table2q).out
        ..and.genMyCache_indexs.greateThanOrEqualTo(0);
    });

    print(t);
    final tgo = t.go;
    if (tgo is Future<List<Map<String, Object?>>>) {
      dashed;
      dashed;
      await tgo.then((value) => print('\n\n_________:: $value'));
      await Future.delayed(Duration.zero);
    } else {
      print('.........aaaaaaaaaa ....');
      print(tgo);
    }
    // expect(t.go.length, 2, reason: t.go.toString() + table2q.go.toString());
    dashed;

    table2q.genIndexs_id.genIndexs_chapterName.go;
    // print(g.join('\n'));
    // expect(g.length, 8, reason: g.toString());

    genMyCacheTable.query.all..let((s) => print('hahha: $s'));
    await Future.delayed(Duration.zero);
  });

  test('is null', () {
    genMyCacheTable.query.all
      ..where.genMyCache_id.is_.null_
      ..let((s) {
        print(s);
      });
  });
  test('Type is', () {
    final ax = M(112);
    ax.pa();
  });
}

void get dashed => print('.............');

class M<T> {
  M(this.a);
  final T a;
  void pa() {
    print(T is int);
    print(T == int);
  }
}
