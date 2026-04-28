import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static Future<Database> db() async {
    return openDatabase(
      join(await getDatabasesPath(), 'finance.db'),
      version:2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE finance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ganhoDia05 REAL,
            ganhoDia20 REAL,
            faturaDia05 REAL,
            faturaDia20 REAL,
            despesaFixaDia05 REAL,
            despesaFixaDia20 REAL
          )
        ''');
      },
    );
  }
}