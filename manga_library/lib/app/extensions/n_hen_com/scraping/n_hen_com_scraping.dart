import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  // const String url = "https://hentaihand.com/en/";
  final Dio dio = Dio();
  List<ModelHomePage> models = [];
  try {
    /// ------------------- popularity
    Response popularityResult = await dio.get(
        "https://nhentai.com/api/comics?lang=en&sort=popularity&duration=week&per_page=12&nsfw=false");

    // inicio do processamento individual
    List<Map<String, String>> books = [];
    for (Map book in popularityResult.data["data"]) {
      // name
      String? name = book["title"];
      // img
      String? img = book["image_url"];
      // link
      String? link = book["slug"];
      // cortar o link
      // List<String> corteLink = link!.split("/g/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": link ?? "erro",
        "img": img ?? ""
      });
    }

    models.add(ModelHomePage.fromJson(
        {"title": "N Hentai.com Populares", "books": books, "idExtension": 24}));

    /// ------------------------- latest
    Response latestResult = await dio.get(
        "https://nhentai.com/api/comics?lang=en&latest=true&per_page=12&nsfw=false");

    books = [];
    for (Map book in latestResult.data) {
      // name
      String? name = book["title"];
      // img
      String? img = book["image_url"];
      // link
      String? link = book["slug"];
      // cortar o link
      //List<String> corteLink = link!.split("/g/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": link ?? "erro",
        "img": img ?? ""
      });
    }

    models.add(ModelHomePage.fromJson(
        {"title": "N Hentai.com Recentes", "books": books, "idExtension": 24}));

    /// ------------------------- discover
    Response discoverResult = await dio.get(
        "https://nhentai.com/api/comics?lang=en&discover=true&per_page=12&nsfw=false");

    books = [];
    for (Map book in discoverResult.data) {
      // name
      String? name = book["title"];
      // img
      String? img = book["image_url"];
      // link
      String? link = book["slug"];
      // cortar o link
      //List<String> corteLink = link!.split("/g/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": link ?? "erro",
        "img": img ?? ""
      });
    }

    models.add(ModelHomePage.fromJson(
        {"title": "N Hentai.com Descobrir", "books": books, "idExtension": 24}));

    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at NHen.com: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  final Dio dio = Dio();
  try {
    Response data = await dio
        .get("https://nhentai.com/api/comics/$link?lang=en&nsfw=false");

    String? name;
    String? description;
    String? img;
    String? authors;
    List<String> genres = [];
    List<String> paginas = [];
    if (data.data != null) {
      // name
      name = data.data['title'];
      // debugPrint("name: $name");
      description = data.data['meta_description'];
      // debugPrint("description: $description");
      // img
      img = data.data['image_url'];
      // debugPrint("img: $img");
      // genres
      for (Map genre in data.data['tags']) {
        genres.add("${genre['name']}");
      }
      debugPrint("genres: $genres");
      // authors
      if (data.data['artists'].isNotEmpty) {
        authors ??= "";
        // authors;
        for (Map author in data.data['artists']) {
          if (authors != null) {
            authors += "${author['name']}, ";
          }
        }
      }
      // chapters
      Response imagesData = await dio.get(
          'https://nhentai.com/api/comics/$link/images?lang=en&nsfw=false');
      for (Map page in imagesData.data['images']) {
        paginas.add('${page['source_url']}');
      }
      debugPrint("pages: $paginas");

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        state: data.data['uploaded_at'],
        authors: authors ?? "Autor desconhecido",
        link: "https://nhentai.com/en/comic/$link",
        idExtension: 24,
        genres: genres,
        alternativeName: false,
        chapters: 1,
        capitulos: [
          Capitulos(
            id: "cap1",
            capitulo: "Capítulo 1",
            download: false,
            description: "",
            readed: false,
            mark: false,
            downloadPages: [],
            pages: paginas,
          ),
        ],
      );
    }
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionNHen.com: $e");
    return null;
  }
}

// ----------------------------------------------------------------------------
//                     === SEARCH ===

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  final Dio dio = Dio();
  try {
    var parser = await dio.get(
        "https://nhentai.com/api/comics?q=$txt&per_page=6&lang=en&nsfw=false");
    List<Map<String, dynamic>> books = [];

    if (parser.data != null) {
      List<Map<String, dynamic>> projetoBooks = List<Map>.from(parser.data['data']).map((Map data) {
        // name
        String? name = data['title'];
        debugPrint("name: $name");
        // img
        String? img = data['image_url'];
        debugPrint("img: $img");
        // link
        String link = data['slug'];

        return {
          "name": name ?? "error",
          "link": link,
          "img": img,
          "idExtension": 24
        };
      }).toList();

      books.addAll(projetoBooks);
    }
    // debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionNHen.com: $e");
    debugPrint('$s');
    return [];
  }
}
