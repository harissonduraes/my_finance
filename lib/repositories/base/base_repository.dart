import 'package:my_finance/db/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/base/base_model.dart';

typedef FromMap<T> = T Function(Map<String, dynamic> map);

class BaseRepository<T extends BaseModel> {
   final String tableName;
   final FromMap<T> fromMap;

   BaseRepository({required this.tableName, required this.fromMap});

   Future<Database> get _db async => await SQLHelper.db();

   Future<List<T>> getAllAsync() async {
    final db = await _db;
    final result = await db.query(tableName);
    return result.map((e) => fromMap(e)).toList();
   }

   Future<T?> getAsync(int id) async {
    final db = await _db;
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (result.isEmpty) return null;
    return fromMap(result.first);
   }

   Future<int> insertAsync(T entity) async {
    final db = await _db;
    return await db.insert(tableName, entity.toMap());
   }

   Future<int> updateAsync(T entity) async {
    if (entity.id == null) {
     throw Exception('ID cannot be null');
    }

    final db = await _db;

    return await db.update(
     tableName,
     entity.toMap(),
     where: 'id = ?',
     whereArgs: [entity.id],
    );
   }

   Future<int> deleteAsync(T entity) async {
    final db = await _db;

    return await db.delete(tableName, where: 'id = ?', whereArgs: [entity.id]);
   }
}