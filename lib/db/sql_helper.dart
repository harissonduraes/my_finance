import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
        await database.execute('''          
            CREATE TABLE receita(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              receita REAL,
              dia TEXT
            )
          ''');
        await database.execute('''
            CREATE TABLE fatura(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              fatura REAL,
              cartao TEXT,
              dia TEXT
            )
          ''');
        await database.execute('''
            CREATE TABLE despesa(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              despesa REAL,
              dia TEXT
            )
          ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'finance4.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }
}