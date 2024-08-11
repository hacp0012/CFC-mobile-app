import 'package:cfc_christ/database/models/auth_model.dart';
import 'package:cfc_christ/database/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DbMigrations {
  Database db;
  int version;

  DbMigrations(this.db, this.version);

  Future<void> migrate() async {
    await _user();
    await _auth();
  }

  Future<void> _user() async {
    await db.execute("""
     CREATE TABLE ${UserModel.tableName} (
        ${UserModel.id}             INTEGER PRIMARY KEY AUTOINCREMENT,
        ${UserModel.identifierKey}  TEXT DEFAULT ${UserModel.identifierKey},
        ${UserModel.data}           TEXT,
     );
    """);
  }

  Future<void> _auth() async {
    await db.execute("""
     CREATE TABLE ${AuthModel.tableName} (
        ${AuthModel.id}         INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AuthModel.token}      TEXT NOT NULL,
        ${AuthModel.expireAt}   TEXT,
        ${AuthModel.updatedAt}  TEXT,
        ${AuthModel.createdAt}  TEXT
     );
    """);
  }
}
