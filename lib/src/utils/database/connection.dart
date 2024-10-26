import 'package:note_app/src/utils/database/migrations/tables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  static const databaseName = "notes";

  static Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(Tables.noteTables);
    });
  }

  static Future<int> insert(String tableName, Map<String, dynamic> data) async {
    final db = await initDatabase();
    return await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map>> query(String query) async {
    final db = await initDatabase();
    return await db.rawQuery(query);
  }

  static Future<int> update(String tableName, Map<String, dynamic> data,
      String where, dynamic value) async {
    final db = await initDatabase();
    return db.update(tableName, data, where: '$where=?', whereArgs: [value]);
  }
}
