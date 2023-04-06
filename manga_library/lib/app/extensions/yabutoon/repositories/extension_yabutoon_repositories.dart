import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class YabutoonRepositories {
  final Dio dio = Dio(BaseOptions(receiveTimeout: const Duration(seconds: 30)));

  Future<List<Map<String, dynamic>>> search(String txt) async {
    try {
      var data = await dio.post(
          'https://manga-search-server.onrender.com/yabutoon/search',
          data: {"txt": txt});
      // debugPrint(data.data['data']);

      var decoded = List.from(data.data);
      return decoded.map<Map<String, dynamic>>((e) {
        if (e["cover"].contains("https")) {
          return {
            "name": e["title"],
            "img": e["cover"],
            "link": e["slug"],
            "idExtension": 12
          };
        }
        return {
          "name": e["title"],
          "img": 'https://yabutoons.com/${e["cover"]}',
          "link": e["slug"],
          "idExtension": 12
        };
      }).toList();
    } catch (e) {
      debugPrint("erro no search at YabutoonRepositories: $e");
      return [];
    }
  }
}
