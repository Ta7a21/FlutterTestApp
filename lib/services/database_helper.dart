import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:filtration_task/user.dart';

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

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   Database db = await instance.database;
  //   return await db.query(table);
  // }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var hashedPassword = sha1.convert(bytes);
    return hashedPassword.toString();
  }

  static bool isPassMatching(String storedPassword, String password) {
    return hashPassword(password) == storedPassword;
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

  static Future<bool> checkAuthorization(
      String username, String password) async {
    List<Map> resultSet = await checkUsername(username);
    if (resultSet.isNotEmpty) {
      String storedPassword = resultSet.first['password'];
      return isPassMatching(storedPassword, password);
    } else
      return false;
  }

  static Future<void> addUser(User user) async {
    user.password = hashPassword(user.password);
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnFName: user.firstname,
      DatabaseHelper.columnLName: user.lastname,
      DatabaseHelper.columnUsername: user.username,
      DatabaseHelper.columnPassword: user.password,
    };
    await insert(row);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  //Future<int> queryRowCount() async {
  //Database db = await instance.database;
  //return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  //}

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
}
