import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper{
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "events";

  static Future<void> initDb() async{
    if (_db != null){
      return;
    }
    try {
      String path = await getDatabasesPath() + 'events.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version){
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name STRING, description TEXT, date STRING, "
            "time STRING, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch(e) {
      print(e);
    }
  }
  static Future<int> insert(Task? task) async{
    return await _db?.insert(_tableName, task!.toJson())??1;
  }

  static Future<List<Map<String, dynamic>>> query() async{
    return await _db!.query(_tableName);
  }

  static delete(Task task) async{
    await _db!.delete(_tableName, where:'id=?', whereArgs: [task.id]);
  }

  static update(int id) async{
    return await _db!.rawUpdate('''
      UPDATE events
      SET isCompleted = ?
      WHERE id =?
    ''', [1, id]);
  }
}