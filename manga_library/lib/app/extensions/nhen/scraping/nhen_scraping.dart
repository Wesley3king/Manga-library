import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = "https://nhentai.to/";
  try {
    Parser? parser = await Chaleno().load(url);

    List<Result>? data = parser?.querySelectorAll("div.gallery");

    // inicio do processamento individual
    List<Map<String, String>> books = [];
    for (Result book in data!) {
      // name
      String? name = book.querySelector("div.caption")!.text;
      // img
      String? img = book.querySelector("img")!.src;
      // https://cdn.dogehls.xyz/galleries/2216538/thumb.jpg
      // link
      String? link = book.querySelector("a.cover")!.href;
      // cortar o link
      List<String> corteLink = link!.split("g/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": corteLink[1].replaceAll("/", ""),
        "img": img ?? ""
      });
    }

    ModelHomePage model = ModelHomePage.fromJson(
        {"title": "NHentai", "books": books, "idExtension": 5});

    return [model];
  } catch (e) {
    debugPrint("erro no scrapingHomePage at nhen: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  const String indenify = "div#info";
  try {
    var parser = await Chaleno().load("https://nhentai.to/g/$link");
    // print(parser?.html);

    String? name;
    String? description;
    String? img;
    StringBuffer authors = StringBuffer();
    String? state;
    List<String> genres = [];
    List<String> paginas = [];
    if (parser != null) {
      // name
      name = parser.querySelector("$indenify h1").text;
      // debugPrint("name: $name");
      description = parser.querySelector("$indenify h2").text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div#cover a img").src;
      // debugPrint("img: $img");
      // genres and author
      List<Result>? genresResult =
          parser.querySelectorAll("div.tag-container"); // $indenify div#tags
      // print(genresResult);
      List<Result>? generos;
      for (Result result in genresResult) {
        if (result.text!.contains("Tags")) {
          generos = result.querySelectorAll("a > span.name");// span.tags
        } else if (result.text!.contains("Artists")) {
          // authors
          List<Result>? artists = result.querySelectorAll("a > span.name");
          for (int i = 0; i < artists!.length; ++i) {
            authors.write('${artists[i].text}');
          }
        }
      }
      // print(generos);

      for (int i = 0; i < generos!.length; ++i) {
        genres.add("${generos[i].text?.trim()}");
      }
      debugPrint("genres: $genres");
      // state
      state = "uploaded: ${parser.querySelector("span.tags > time").text}";

      // chapters
      Result? chapterPages = parser.querySelector("div#thumbnail-container");
      // debugPrint("length de cap: ${chapterPages.html}");
      List<Result>? pages = chapterPages.querySelectorAll("img");
      // debugPrint("imgs: $pages");

      for (int i = 0; i < pages!.length; ++i) {
        String? page = pages[i].src;
        // retirar a versão pequena
        List<String> cortePage = page!.split(
            "/"); // https://cdn.dogehls.xyz/galleries/2216481/1t.jpg // https://cdn.dogehls.xyz/galleries/2216481/1.jpg
        // cortePage = cortePage.reversed.toList();
        String modificatedImage = cortePage[5].replaceAll("t", "");
        paginas.add(
            "${cortePage[0]}//${cortePage[2]}/${cortePage[3]}/${cortePage[4]}/$modificatedImage");
      }
      // debugPrint("pages: $paginas");

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        authors: authors.toString(),
        state: state,
        link: "https://nhentai.to/g/$link",
        idExtension: 5,
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
    debugPrint("erro no scrapingMangaDetail at ExtensionNHent: $e");
    return null;
  }
}

// ----------------------------------------------------------------------------
//                     === SEARCH ===

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://nhentai.to/search?q=$txt");

    var resultHtml = parser?.querySelector("div.index-container");
    List<Map<String, dynamic>> books = [];

    if (resultHtml != null) {
      // projeto
      var projetoData = resultHtml.querySelectorAll("div.gallery");
      // print(projetoData);
      if (projetoData != null) {
        List<Map<String, dynamic>> projetoBooks =
            projetoData.map((Result data) {
          // name
          String? name = data.querySelector("a div.caption")!.text;
          // debugPrint("name: $name");
          // img
          String? img = data.querySelector("a > img")?.src;
          debugPrint("img: $img");
          // link
          String? link = data.querySelector("a")!.href;
          List<String> corteLink = link!.split("g/");
          debugPrint("link: ${corteLink[1]}");
          // print(data.html);
          return {
            "name": name ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "img": img,
            "idExtension": 5
          };
        }).toList();

        books.addAll(projetoBooks);
      }
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionNHen: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
