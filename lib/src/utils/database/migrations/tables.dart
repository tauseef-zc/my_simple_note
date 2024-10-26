class Tables {
  static String noteTableTitle = "notes";
  static String labelTableTitle = "labels";

  static String noteTables = '''
    CREATE TABLE IF NOT EXISTS $noteTableTitle (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      note TEXT,
      archived TINYINT(1) DEFAULT 0,
      trashed TINYINT(1) DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    
    CREATE TABLE IF NOT EXISTS $labelTableTitle (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      label TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
   ''';
}
