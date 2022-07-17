import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper {
  
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE voted(
        id INTEGER PRIMARY KEY NOT NULL
      )""");
    await database.execute("""CREATE TABLE listened(
        id INTEGER PRIMARY KEY NOT NULL
      )""");
    await database.execute("""CREATE TABLE favorites(
        id INTEGER PRIMARY KEY NOT NULL
      )""");

  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(),'preferences.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }
//-----------------------------------------------------------
  // Create new item (voted audio)
  static Future<int> createVoted(int id_) async {
    final db = await SQLHelper.db();

    final data = {'id': id_};
    final id = await db.insert('voted', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (voted audio)
  static Future<List<Map<String, dynamic>>> getVoted() async {
    final db = await SQLHelper.db();
    return db.query('voted', orderBy: "id");
  }

  // Read a single item by id (voted audio)
  static Future<List<Map<String, dynamic>>> getVotedbyId(int id) async {
    final db = await SQLHelper.db();
    return db.query('voted', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Delete (voted audio)
  static Future<void> deleteVoted(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("voted", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

//-----------------------------------------------------------
  // Create new item (listened audio)
  static Future<int> createListened(int id_) async {
    final db = await SQLHelper.db();

    final data = {'id': id_};
    final id = await db.insert('listened', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (listened audio)
  static Future<List<Map<String, dynamic>>> getListened() async {
    final db = await SQLHelper.db();
    return db.query('listened', orderBy: "id");
  }

  // Delete (listened audio)
  static Future<void> deleteListened(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("listened", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

//-----------------------------------------------------------
  // Create new item (favorite author)
  static Future<int> createFavorite(int id_) async {
    final db = await SQLHelper.db();

    final data = {'id': id_};
    final id = await db.insert('favorites', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (favorite author)
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await SQLHelper.db();
    return db.query('favorites', orderBy: "id");
  }

  // Read a single item by id (favorite author)
  static Future<List<Map<String, dynamic>>> getFavoritebyId(int id) async {
    final db = await SQLHelper.db();
    return db.query('favorites', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Delete (favorite author)
  static Future<void> deleteFavorite(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("favorites", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }


}
