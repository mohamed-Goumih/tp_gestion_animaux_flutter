// sqlDataBase.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'liste_animaux.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'animaux.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 1);
    return mydb;
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE "type_animaux" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "nom" TEXT NOT NULL,
      "espece" TEXT NOT NULL
    )
   ''');
    await batch.commit();
  }

  Future<int?> insertTypeAnimal(String nom, String espece) async {
    final dbClient = await db;
    try {
      final row = {
        'nom': nom,
        'espece': espece,
      };
      return await dbClient!.insert('type_animaux', row);
    } catch (e) {
      return null;
    }
  }
  Future<List<TypeAnimal>> getTypeAnimaux() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query('type_animaux');
    return List.generate(maps.length, (i) {
        return TypeAnimal(
          id: maps[i]['id'], 
          nom: maps[i]['nom'],
          espece: maps[i]['espece'],
        );
      });
  }
  Future<int> updateData(String sql) async {
    final dbClient = await db;
    return await dbClient!.rawUpdate(sql);
  }

  Future<int> deleteData(String sql) async {
    final dbClient = await db;
    return await dbClient!.rawDelete(sql);
  }
  Future<TypeAnimal?> getTypeAnimalById(int id) async {
    final dbClient = await db;
    final maps = await dbClient!.query(
      'type_animaux',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TypeAnimal.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
