import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class HqNowRepositories {
  final Dio dio = Dio(BaseOptions(headers: {
    "content-type": "application/json",
    "origin": "https://www.hq-now.com",
    "referer": "https://www.hq-now.com/",
    "sec-fetch-site": "same-site"
  }));

  /// get homePage
  Future<List<ModelHomePage>> homePage(int computeIndex) async {
    List<ModelHomePage> models = [];
    try {
      /// destaques
      var destaquesData =
          await dio.post("https://admin.hq-now.com/graphql", data: {
        "operationName": "getCarouselOfHqs",
        "query":
            "query getCarouselOfHqs {\n  getCarouselOfHqs {\n    name\n    hqId\n    hqCover\n  }\n}\n"
      });
      List<ModelHomeBook> books =
          List.from(destaquesData.data['data']['getCarouselOfHqs'])
              .map<ModelHomeBook>((json) => ModelHomeBook.fromJson({
                    "name": json['name'],
                    "url": json['hqId'].toString(),
                    "img": json['hqCover'],
                    "idExtension": 17
                  }))
              .toList();
      models.add(ModelHomePage(
          title: "Hq Now Sugestões", books: books, idExtension: 17));
      // books.clear();

      /// ultimas atualizações
      var ultimasAtualizacoesData =
          await dio.post("https://admin.hq-now.com/graphql", data: {
        "operationName": "getRecentlyUpdatedHqs",
        "query":
            "query getRecentlyUpdatedHqs {\n  getRecentlyUpdatedHqs {\n    name\n    hqCover\n    id\n  }\n}\n",
        "variables": {}
      });
      //  updatedAt\n    updatedChapters\n
      //\n    synopsis
      books = [];
      books = List.from(
              ultimasAtualizacoesData.data['data']['getRecentlyUpdatedHqs'])
          .map<ModelHomeBook>((json) => ModelHomeBook.fromJson({
                "name": json['name'],
                "url": json['id'].toString(),
                "img": json['hqCover'],
                "idExtension": 17
              }))
          .toList();
      models.add(ModelHomePage(
          title: "Hq Now Ultimas Atualizações", books: books, idExtension: 17));
    } catch (e) {
      debugPrint("erro no homePage at HqNowRepositories: $e");
    }
    return models;
  }

  Future<MangaInfoOffLineModel?> getMangaDetail(String id) async {
    try {
      var data = await dio.post("https://admin.hq-now.com/graphql", data: {
        "operationName": "getHqsById",
        "query":
            'query getHqsById(\$id: Int!) {\n  getHqsById(id: \$id) {\n    id\n    name\n    synopsis\n    editoraId\n    status\n    publisherName\n    hqCover\n    impressionsCount\n    capitulos {\n      name\n      id\n      number\n    }\n  }\n}\n',
        "variables": {"id": int.parse(id)}
      });
      final Map<String, dynamic> processedData =
          Map<String, dynamic>.from(data.data['data']['getHqsById'][0]);

      /// chapters
      List<Capitulos> capitulos = List.from(processedData['capitulos'])
          .map<Capitulos>((json) => Capitulos(
              id: json['id'].toString(),
              capitulo: 'Cap. ${json['number']}',
              description: "",
              download: false,
              readed: false,
              mark: false,
              downloadPages: [],
              pages: []))
          .toList();

      return MangaInfoOffLineModel(
          name: processedData['name'],
          authors: processedData['publisherName'],
          state: processedData['status'],
          description: processedData['synopsis'],
          img: processedData['hqCover'],
          link: "https://www.hq-now.com/hq/$id/",
          idExtension: 17,
          genres: [],
          alternativeName: false,
          chapters: capitulos.length,
          capitulos: capitulos.reversed.toList());
    } catch (e) {
      debugPrint("erro no getMangaDetail at HqNowRepositories: $e");
      return null;
    }
  }

  /// getPages
  Future<List<String>> getPages(String id) async {
    List<String> pages = [];
    try {
      var data = await dio.post("https://admin.hq-now.com/graphql", data: {
        "operationName": "getChapterById",
        "query":
            "query getChapterById(\$chapterId: Int!) {\n  getChapterById(chapterId: \$chapterId) {\n    name\n    number\n    oneshot\n    pictures {\n      pictureUrl\n    }\n    hq {\n      id\n      name\n      capitulos {\n        id\n        number\n      }\n    }\n  }\n}\n",
        "variables": {"chapterId": int.parse(id)}
      });
      pages = List.from(data.data['data']['getChapterById']['pictures'])
          .map<String>((json) => json['pictureUrl'])
          .toList();
    } catch (e) {
      debugPrint("erro no getPages at HqNowRepositories: $e");
    }
    return pages;
  }

  /// search
  Future<List<Map<String, dynamic>>> search(String txt) async {
    List<Map<String, dynamic>> books = [];
    try {
      var data = await dio.post("https://admin.hq-now.com/graphql", data: {
        "operationName": "getHqsByName",
        "query":
            "query getHqsByName(\$name: String!) {\n  getHqsByName(name: \$name) {\n    id\n    name\n    editoraId\n    status\n    publisherName\n    impressionsCount\n  }\n}\n",
        "variables": {"name": txt}
      });
      books = List.from(data.data['data']['getHqsByName']).map<
          Map<String, dynamic>>((json) => {
          "name": json['name'],
          "link": json['id'].toString(),
          "img": 'https://1.bp.blogspot.com/-xlPr2UhNhSw/XzLpoWQV-zI/AAAAAAABOPk/8kaHudcGY_85k3TeTpdPn4bm2-tqN8v2QCNcBGAsYHQ/s1600/molde-hqs2-anos-2000-parte-1.jpg',
          "idExtension": 17
        }).toList();
    } catch (e) {
      debugPrint("erro no search at HqNowRepositories: $e");
    }
    return books;
  }
}
