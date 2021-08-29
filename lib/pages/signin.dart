import 'package:flutter/material.dart';
import 'package:filtration_task/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';


class SignIn extends StatelessWidget {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  Future <int?> _query() async {
    Database db = await DatabaseHelper.instance.database;
    List <String> columns = [DatabaseHelper.columnUsername,DatabaseHelper.columnPassword];
    String row = '${DatabaseHelper.columnUsername} = ?';
    List <dynamic> reqRow = [_usernameController.text];

    List <Map> result = await db.query(DatabaseHelper.table, columns: columns,where: row, whereArgs: reqRow);
    if (result.isNotEmpty) {
      var bytes = utf8.encode(_passwordController.text);
      var hashedPassword = sha1.convert(bytes);
      if (hashedPassword.toString() == result.first['password']){
        return 1;
      }
      else{
        return 0;
      }
    }
    //final allRows = await dbHelper.database.query();
    // print('query all rows:');
    // allRows.forEach(print);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-in'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        child: Padding(
            padding: EdgeInsets.fromLTRB(100, 140, 100, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  controller: _usernameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text('Sign-up'))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async{
                      int? flag = await _query();
                      print(flag);
                      if (flag == 1) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text('Submit'))
              ],
            )),
      ),
    );
  }
}
