import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String _databaseName = "database.db";
  int _databaseVersion = 1;
  static String _table = 'User';
  static String _columnFName = 'fname';
  static String _columnLName = 'lname';
  static String _columnUsername = 'username';
  static String _columnPassword = 'password';

  static String getColumnFName() {
    return _columnFName;
  }

  static String getColumnLName() {
    return _columnLName;
  }

  static String getColumnUsername() {
    return _columnUsername;
  }

  static String getColumnPassword() {
    return _columnPassword;
  }

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  late Database _database;
  Future<Database> get database async {
    // instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    return await db.execute(
        'CREATE TABLE $_table ($_columnUsername VARCHAR(20) PRIMARY KEY,$_columnFName VARCHAR(20) NOT NULL,$_columnLName VARCHAR(20) NOT NULL,$_columnPassword TEXT NOT NULL)');
  }

  static Future<int> insertHelper(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_table, row);
  }

  static Future<bool> grantAuthorization(
      String username, String password) async {
    List<Map> resultSet = await getUsername(username);
    if (resultSet.isNotEmpty) {
      String storedPassword = resultSet.first['password'];
      return comparePasswords(storedPassword, password);
    } else
      return false;
  }

  static Future<List<Map>> getUsername(String username) async {
    Database db = await DatabaseHelper.instance.database;
    List<String> columns = [_columnUsername, _columnPassword];
    String row = '$_columnUsername = ?';
    List<dynamic> requiredRow = [username];

    List<Map> resultSet = await db.query(_table,
        columns: columns, where: row, whereArgs: requiredRow);
    return resultSet;
  }

  static bool comparePasswords(String storedPassword, String password) {
    return hashPassword(password) == storedPassword;
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var hashedPassword = sha1.convert(bytes);
    return hashedPassword.toString();
  }
}
