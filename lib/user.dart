import 'package:filtration_task/services/database_helper.dart';

class User {
  late String firstname;
  late String lastname;
  late String username;
  late String password;

  static Future<void> addUser(User user) async {
    user.password = DatabaseHelper.hashPassword(user.password);

    Map<String, dynamic> row = {
      DatabaseHelper.columnFName: user.firstname,
      DatabaseHelper.columnLName: user.lastname,
      DatabaseHelper.columnUsername: user.username,
      DatabaseHelper.columnPassword: user.password,
    };
    await DatabaseHelper.insert(row);
  }
}
