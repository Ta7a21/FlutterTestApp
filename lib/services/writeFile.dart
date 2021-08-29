import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileUtils {
  static Future<String> get getFilePath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/myfile.txt');
  }

  static Future<File> saveToFile(List<int> dataRecieved) async {
    String dataToWrite = '';
    dataRecieved.forEach((element) {
      dataToWrite += element.toString() + ' ';
    });
    final file = await getFile;
    return file.writeAsString(dataToWrite);
  }
}
