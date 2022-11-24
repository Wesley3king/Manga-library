import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

Future<List<Map<String, dynamic>>> searchService(String txt) async {
  final Dio dio = Dio();
  try {
    var dados = await dio.get("https://gekkou.com.br/search?query=$txt");
    List<Map<String, dynamic>> data = [];
    for (dynamic result in dados.data["suggestions"]) {
      data.add(
          {"name": result['value'], "img": "https://gekkou.com.br//uploads/logo.png", "link": result['data'], "idExtension": 11});
    }
    return data;
  } catch (e) {
    debugPrint("erro no search service at ExtensionGekkouScans: $e");
    return [];
  }
}
