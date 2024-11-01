import 'package:note_app/src/utils/database/migrations/tables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  static const databaseName = "notes";
  static final DatabaseConnection _instance = DatabaseConnection._internal();
  static Database? _database;

  DatabaseConnection._internal();

  factory DatabaseConnection() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(Tables.noteTables);
    });
  }
}
