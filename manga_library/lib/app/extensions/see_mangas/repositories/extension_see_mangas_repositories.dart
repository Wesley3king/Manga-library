// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

Future<List<String>> getImagesForLeitor(String id) async {
  final Dio dio = Dio();
  Response responseToken = await dio.get("https://wesley3king.github.io/reactJS/token/token_see_manga.json");
  List<String> corteLink1 = id.split(responseToken.data["token"]);
  try {
    var data = await dio.post("https://seemangas.com/wp-admin/admin-ajax.php",
        data: {
          "action": "get_image_list",
          "id_serie": corteLink1[1],
          "secury": "x2a6sx28sa"
        },
        options:
            Options(contentType: "application/x-www-form-urlencoded", headers: {
          "referer": "https://seemangas.com/ler/$id",
          "origin": "https://seemangas.com",
          "user-agent":
              "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
        }));
    final List<Map> convertData = List.from(data.data['images']);
    return convertData.map<String>((map) => map['url']).toList();
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionSeeMangas: $e");
    debugPrint("$s");
    return [];
  }
}
// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, dynamic>>> searchMangas(String txt) async {
  final Dio dio = Dio();
  try {
    List<Map<String, dynamic>> books = [];
    var data = await dio.get(
        'https://seemangas.com/wp-json/site/search/?keyword=$txt&type=undefined&nonce=e154db27c2');
    debugPrint("sucesso no scraping");
    List<String> keys = data.data.keys.toList();
    for (String key in keys) {
      final List<String> corteLink = data.data[key]['url'].split("manga/");
      books.add({
        "name": data.data[key]['title'],
        "img": data.data[key]['img'],
        "link": corteLink[1].replaceAll("/", ""),
        "idExtension": 16
      });
    }
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
