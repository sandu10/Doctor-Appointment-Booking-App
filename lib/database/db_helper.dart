import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'doctor_app.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE doctors(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            specialty TEXT,
            imageUrl TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE appointments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            doctorName TEXT,
            specialty TEXT,
            date TEXT,
            time TEXT,
            reason TEXT,
            type TEXT
          )
        ''');

        // Insert sample doctors
        await db.insert('doctors', {
          "name": "Dr. Sneha Nu",
          "specialty": "Cardiologist",
          "imageUrl": "https://i.imgur.com/BoN9kdC.png"
        });

        await db.insert('doctors', {
          "name": "Dr. Vargo Ho",
          "specialty": "Neurologist",
          "imageUrl": "https://i.imgur.com/0y8Ftya.png"
        });
      },
    );
  }

  // ---------- USER AUTH ----------
  static Future<int> registerUser(String email, String password) async {
    final db = await database;
    return await db.insert('users', {"email": email, "password": password});
  }

  static Future<bool> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    return result.isNotEmpty;
  }

  // ---------- DOCTORS ----------
  static Future<List<Map<String, dynamic>>> getDoctors() async {
    final db = await database;
    return await db.query('doctors');
  }

  // ---------- APPOINTMENTS ----------
  static Future<int> insertAppointment(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('appointments', data);
  }

  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final db = await database;
    return await db.query('appointments');
  }

  static Future<int> updateAppointment(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db
        .update('appointments', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAppointment(int id) async {
    final db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }
}
