import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
// import 'package:manga_library/app/models/leitor_pages.dart';

class YabuFetchServices {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: 40000,
    sendTimeout: 40000,
  ));

  Future<List<Map<String, dynamic>>> search(String txt) async {
    try {
      var data = await dio.post(
          'https://manga-search-server.onrender.com/search',
          data: {"txt": txt});
      // debugPrint(data.data['data']);

      var decoded = List.from(data.data);
      return decoded
          .map<Map<String, dynamic>>(
              (e) => {"name": e["title"], "img": e["cover"], "link": e["slug"], "idExtension": 1})
          .toList();
    } catch (e, s) {
      debugPrint('error no search! $e');
      debugPrint('$s');
      return [];
    }
  }
}
