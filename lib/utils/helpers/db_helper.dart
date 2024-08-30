import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shopping_exam/screen/cart/model/db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static DBHelper helper = DBHelper._();

  DBHelper._();

  Database? database;

  Future<Database>? checkDb() async {
    if (database != null) {
      return database!;
    } else {
      return await initDb();
    }
  }

  Future<Database> initDb() async {
    Directory dir = await getApplicationSupportDirectory();
    String path = join(dir.path, "product.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String productQuary =
            "CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,price TEXT,dec TEXT,image TEXT)";
        db.execute(productQuary);
      },
    );
  }

  Future<void> insertQuery(DBModel model) async {
    database = await checkDb();
    database!.insert(
      "products",
      {
        "name": model.name,
        "dec": model.dec,
        "price": model.price,
        "image": model.image,
      },
    );
  }

  Future<List<DBModel>> read() async {
    database = await checkDb();
    String quotes = "SELECT * FROM products";
    List<Map> list = await database!.rawQuery(quotes);
    List<DBModel> l1 = list.map((e) => DBModel.mapToModel(e)).toList();
    return l1;
  }

  Future<void> delete(int id) async {
    database = await checkDb();
    database!.delete("products", where: "id=?", whereArgs: [id]);
  }

  Future<void>update(DBModel model) async {
    database = await checkDb();
    database!.update(
        "products",
        {
          "name": model.name,
          "dec": model.dec,
          "price": model.price,
          "image": model.image,
        },
        where: "id=?",
        whereArgs: [model.id]);
  }
}