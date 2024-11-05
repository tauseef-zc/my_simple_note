import 'package:note_app/src/utils/database/migrations/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestDatabase {
  static final TestDatabase _instance = TestDatabase._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  TestDatabase._internal();

  factory TestDatabase() {
    return _instance;
  }

  Future<Database> initDatabase() async {
    return await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (Database db, int version) async {
              await db.execute(Tables.noteTables);
            }));
  }
}
