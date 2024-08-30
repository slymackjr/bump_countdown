import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bump_countdown.db');

    return await openDatabase(
      path,
      version: 2, // Increment the version number to apply the migration.
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          lmpDate TEXT,
          eddDate TEXT,
          daysRemaining INTEGER,
          rating INTEGER
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE history ADD COLUMN rating INTEGER');
        }
      },
    );
  }


  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    return await db.insert('history', record);
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await database;
    return await db.query('history');
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateRecord(int id, Map<String, dynamic> record) async {
    final db = await database;
    return await db.update('history', record, where: 'id = ?', whereArgs: [id]);
  }

}
