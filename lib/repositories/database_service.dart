import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/repository.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'repositories.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE repositories (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            stargazers_count INTEGER,
            html_url TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertRepositories(List<Repository> repositories) async {
    final db = await database;
    final batch = db.batch();

    for (var repo in repositories) {
      batch.insert(
        'repositories',
        repo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print("Inserted ${repositories.length} repositories into the database.");
  }

  Future<List<Repository>> getRepositories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('repositories');

    if (maps.isEmpty) {
      print("No repositories found in the database.");
    } else {
      print("Fetched ${maps.length} repositories from the database.");
    }

    return List.generate(maps.length, (i) {
      return Repository.fromJson(maps[i]);
    });
  }
}
