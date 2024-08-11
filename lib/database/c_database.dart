import 'package:cfc_christ/database/configs/db_migrations.dart';
import 'package:cfc_christ/database/configs/db_seeders.dart';
import 'package:cfc_christ/env.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CDatabase {
  CDatabase._();

  static final CDatabase _instance = CDatabase._();

  factory CDatabase() => _instance;

  // BODY ---------------------------------------------- >

  Database? instance;
  String? dbPath;
  String? tempDir;

  Future<void> initialize() async {
    tempDir = (await getApplicationCacheDirectory()).path;
    dbPath = await getDatabasesPath();

    instance = await openDatabase(
      join(dbPath ?? '/', '${Env.APP_DATABSE_NAME}.db'),
      version: Env.APP_DATABSE_VERSION,
      singleInstance: true,
      onCreate: (db, v) {
        DbMigrations(db, v).migrate().then((voidValue) => DbSeeders(db, v).seed());
      },
    );
  }

  static void removeDatabase() async {
    String path = await getDatabasesPath();
    path = join(path, '${Env.APP_DATABSE_NAME}.db');

    if (await databaseExists(path)) {
      deleteDatabase(path);
    }
  }
}
