import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_effective_mobile/models/item.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'items.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database _database, int version) async {
    await _database.execute('''CREATE TABLE cache_items (
      id INTEGER PRIMARY KEY, 
      name TEXT NOT NULL, 
      image TEXT NOT NULL, 
      status TEXT NOT NULL, 
      date TEXT NOT NULL);''');

    await _database.execute('''CREATE TABLE favorite_items (
      id INTEGER PRIMARY KEY, 
      name TEXT NOT NULL, 
      image TEXT NOT NULL, 
      status TEXT NOT NULL, 
      date TEXT NOT NULL);''');
  }

  Future<void> deleteCache() async {
    final db = await database;
    await db.execute('DELETE FROM cache_items');
  }

  Future<List<Item>> getCachedItems() async {
    final db = await database;
    final items = await db.rawQuery('''
      SELECT 
        cache_items.id AS id,
        cache_items.name AS name,
        cache_items.image AS image,
        cache_items.status AS status,
        cache_items.date AS date,
        CASE WHEN favorite_items.id IS NOT NULL THEN 1 ELSE 0 END AS favorite
      FROM cache_items
      LEFT JOIN favorite_items ON cache_items.id = favorite_items.id
    ''');

    final itemsList = items
        .map(
          (element) => Item(
            id: element['id'] as int,
            name: element['name'].toString(),
            image: element['image'].toString(),
            status: element['status'].toString(),
            date: element['date'].toString(),
            favorite: element['favorite'] as int == 1,
          ),
        )
        .toList();
    return itemsList;
  }

  Future<List<Item>> getFavoriteItems() async {
    final db = await database;
    final items = await db.query('favorite_items', orderBy: 'date DESC');
    final itemsList = items
        .map(
          (element) => Item(
            id: element['id'] as int,
            name: element['name'].toString(),
            image: element['image'].toString(),
            status: element['status'].toString(),
            date: element['date'].toString(),
            favorite: true,
          ),
        )
        .toList();
    return itemsList;
  }

  Future<void> cacheItems(List<Item> items) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final item in items) {
        await txn.insert('cache_items', {
          'id': item.id,
          'name': item.name,
          'image': item.image,
          'status': item.status,
          'date': item.date,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> addFavoriteItem(Item item) async {
    final db = await database;
    await db.insert('favorite_items', {
      'id': item.id,
      'name': item.name,
      'image': item.image,
      'status': item.status,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteFavoriteItem(int id) async {
    final db = await database;
    await db.delete('favorite_items', where: 'id = ?', whereArgs: [id]);
  }
}
