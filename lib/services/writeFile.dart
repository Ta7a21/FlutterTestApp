import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> get __getFilePath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  static Future<File> get _getFile async {
    final path = await __getFilePath;
    return File('$path/myfile.txt');
  }

  static Future<File> saveToFile(List<int> dataRecieved) async {
    String dataToWrite = '';
    dataRecieved.forEach((element) {
      dataToWrite += element.toString() + ' ';
    });
    final file = await _getFile;
    return file.writeAsString(dataToWrite);
  }
}
