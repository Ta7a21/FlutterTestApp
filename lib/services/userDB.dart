import 'package:authentication_app/services/database_helper.dart';
import 'package:authentication_app/userModel.dart';

class UserDB extends User {
  static Future<void> add(User user) async {
    Map<String, dynamic> userRow = _createUserRow(user);
    await DatabaseHelper.insertHelper(userRow);
  }

  static Map<String, dynamic> _createUserRow(User user) {
    user.password = DatabaseHelper.hashPassword(user.password);
    Map<String, dynamic> userRow = {
      DatabaseHelper.getColumnFName(): user.firstname,
      DatabaseHelper.getColumnLName(): user.lastname,
      DatabaseHelper.getColumnUsername(): user.username,
      DatabaseHelper.getColumnPassword(): user.password,
    };

    return userRow;
  }
}
