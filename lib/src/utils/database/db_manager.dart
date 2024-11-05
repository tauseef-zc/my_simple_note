import 'package:note_app/src/utils/database/connection.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  late final Future<Database> database;

  DatabaseManager.defaultDatabase() {
    database = DatabaseConnection().database;
  }

  DatabaseManager.testDatabase(this.database);

  Future<int> insert(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map>> query(String query) async {
    final db = await database;
    return await db.rawQuery(query);
  }

  Future<int> update(String tableName, Map<String, dynamic> data, String where,
      dynamic value) async {
    final db = await database;
    return db.update(tableName, data, where: '$where=?', whereArgs: [value]);
  }

  Future<int> delete(String tableName, String where, dynamic value) async {
    final db = await database;
    return db.delete(tableName, where: '$where=?', whereArgs: [value]);
  }
}
