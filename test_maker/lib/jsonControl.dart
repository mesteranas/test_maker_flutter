import 'package:path_provider/path_provider.dart' as path_bro;
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> get() async {
  Directory systemDIR = await path_bro.getApplicationDocumentsDirectory();
  File file = File("${systemDIR.path}/questions.json");

  if (await file.exists()) {
    final data = await file.readAsString();
    Map<String,dynamic> dartData = jsonDecode(data);
    return dartData;
  } else {
    return {};
  }
}

Future<void> save(Map<String, dynamic > object) async {
  Directory systemDIR = await path_bro.getApplicationDocumentsDirectory();
  File file = File("${systemDIR.path}/questions.json");
  String data = jsonEncode(object);
  await file.writeAsString(data);
}
