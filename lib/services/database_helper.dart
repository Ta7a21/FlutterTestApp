import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class DatabaseHelper {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;
  static final table = 'User';
  static final columnFName = 'fname';
  static final columnLName = 'lname';
  static final columnUsername = 'username';
  static final columnPassword = 'password';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  late Database _database;
  Future<Database> get database async {
    //if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
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
        'CREATE TABLE $table ($columnUsername VARCHAR(20) PRIMARY KEY,$columnFName VARCHAR(20) NOT NULL,$columnLName VARCHAR(20) NOT NULL,$columnPassword TEXT NOT NULL)');
  }

  static Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  static Future<bool> checkAuthorization(
      String username, String password) async {
    List<Map> resultSet = await checkUsername(username);
    if (resultSet.isNotEmpty) {
      String storedPassword = resultSet.first['password'];
      return isPassMatching(storedPassword, password);
    } else
      return false;
  }

  static Future<List<Map>> checkUsername(String username) async {
    Database db = await DatabaseHelper.instance.database;
    List<String> columns = [
      DatabaseHelper.columnUsername,
      DatabaseHelper.columnPassword
    ];
    String row = '${DatabaseHelper.columnUsername} = ?';
    List<dynamic> reqiredRow = [username];

    List<Map> resultSet = await db.query(DatabaseHelper.table,
        columns: columns, where: row, whereArgs: reqiredRow);
    return resultSet;
  }

  static bool isPassMatching(String storedPassword, String password) {
    return hashPassword(password) == storedPassword;
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var hashedPassword = sha1.convert(bytes);
    return hashedPassword.toString();
  }
}
