import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class YabutoonRepositories {
  final Dio dio = Dio(BaseOptions(receiveTimeout: 40000));

  // Future<List<ModelHomePage>> homePage() async {
  //   try {
  //     var response = await dio.get('https://yabutoons.com/api/show2.php');
  //     List<dynamic> decoded = List.from(response.data);
  //     List<ModelHomeBook> books =
  //         decoded.map<ModelHomeBook>((data) => ModelHomeBook(
  //           idExtension: 12,
  //           img: 'https://yabutoons.com/${data['cover']}',
  //           name: data['title'],
  //           url: data['slug']
  //         )).toList();
  //     return [];
  //   } catch (e) {
  //     debugPrint("erro no homepage at YabutoonRepositories: $e");
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>> search(String txt) async {
     try {
      var data = await dio.post(
          'https://manga-search-server.herokuapp.com/search',
          data: {"txt": txt});
      // debugPrint(data.data['data']);

      var decoded = List.from(data.data);
      return decoded
          .map<Map<String, dynamic>>(
              (e) => {"name": e["title"], "img": 'https://yabutoons.com/${e["cover"]}', "link": e["slug"], "idExtension": 12})
          .toList();
    } catch (e) {
      debugPrint("erro no search at YabutoonRepositories: $e");
      return [];
    }
  }
}
