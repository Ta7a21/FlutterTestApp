import 'package:filtration_task/services/database_helper.dart';

class User {
  late String _firstname;
  late String _lastname;
  late String _username;
  late String _password;

  static Future<void> addToDatabase(User user) async {
    user._password = DatabaseHelper.hashPassword(user.getPassword());

    Map<String, dynamic> row = {
      DatabaseHelper.columnFName: user.getFName(),
      DatabaseHelper.columnLName: user.getLName(),
      DatabaseHelper.columnUsername: user.getUsername(),
      DatabaseHelper.columnPassword: user.getPassword(),
    };
    await DatabaseHelper.insert(row);
  }

  void setFName(String firstname) {
    this._firstname = firstname;
  }

  void setLName(String lastname) {
    this._lastname = lastname;
  }

  void setUsername(String username) {
    this._username = username;
  }

  void setPassword(String password) {
    this._password = password;
  }

  String getFName() {
    return _firstname;
  }

  String getLName() {
    return _lastname;
  }

  String getUsername() {
    return _username;
  }

  String getPassword() {
    return _password;
  }
}
