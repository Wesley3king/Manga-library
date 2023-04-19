import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = "https://hentais.net.br/";
  try {
    Parser? parser = await Chaleno().load(url);
    // debugPrint("${result![0].html}");

    List<Result>? data = parser?.querySelectorAll("ul.videos > li > div.video-conteudo");
    // retirar os anuncios
    // data!.removeAt(0);

    // inicio do processamento individual
    List<Map<String, String>> books = [];
    for (Result book in data!) {
      // name
      String? name = book.querySelector("a > h2")!.text;
      // if (name!.contains("[Site de Quadrinhos Er")) continue;
      // img
      String? img = book.querySelector("div.thumb-conteudo > a > img")!.src;
      // link
      Result? links = book.querySelector("a");
      String? link = links!.href;
      // cortar o link
      List<String> corteLink = link!.split("net.br/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": corteLink[1].replaceAll("/", ""),
        "img": img ?? ""
      });
    }

    ModelHomePage model = ModelHomePage.fromJson(
        {"title": "Hentai.net.br", "books": books, "idExtension": 22});

    return [model];
  } catch (e) {
    debugPrint("erro no scrapingHomePage at hen.net.br: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  const String indenify = "div.post > div.post-conteudo";
  try {
    var parser = await Chaleno().load("https://hentais.net.br/$link/");
    // print(parser?.html);

    String? name;
    String? description;
    String? img;
    List<String> genres = [];
    List<String> paginas = [];
    if (parser != null) {
      // name
      name = parser.querySelector("$indenify > h1").text;
      // debugPrint("name: $name");
      description = parser
          .querySelector("$indenify > div.post-info > div.post-texto")
          .text?.trim();
      debugPrint("description: $description");
      // genres
      List<Result>? genresResult = parser.querySelectorAll(
          "$indenify > div.post-info > div.post-footer > div.post-tags > a");

      for (int i = 0; i < genresResult.length; ++i) {
        // String? type = genresResult[i].querySelector("strong")?.text;
        // List<Result>? generos = genresResult[i].querySelectorAll("a");
        // for (Result result in generos!) {
        //   genres.add("${result.text}");
        // }
        genres.add("${genresResult[i].text}");
      }
      debugPrint("genres: $genres");
      // chapters
      Result? chapterPages = parser.querySelector("div.post-info > div.fotos");
      // debugPrint("length de cap: ${chapterPages.html}");
      List<Result>? pages = chapterPages.querySelectorAll("div.foto > a");
      // debugPrint("imgs: $pages");

      for (int i = 0; i < pages!.length; ++i) {
        // img
        if (i == 0) img = pages[i].href;
        // debugPrint("img: $img");
        String? page = pages[i].href;
        paginas.add(page ?? "image null");
      }
      debugPrint("pages: $paginas");

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        state: "Finalizado",
        authors: "Autor desconhecido",
        link: "https://hentais.net.br/$link/",
        idExtension: 22,
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
    debugPrint("erro no scrapingMangaDetail at ExtensionHent.net.br: $e");
    return null;
  }
}

// ----------------------------------------------------------------------------
//                     === SEARCH ===

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://hentais.net.br/?s=$txt");
    List<Map<String, dynamic>> books = [];

    if (parser != null) {
      // projeto
      var projetoData = parser.querySelectorAll("ul.videos > li > div.video-conteudo");
      // print(projetoData);
      List<Map<String, dynamic>> projetoBooks = projetoData.map((Result data) {
        // List<Result>? result = data.querySelectorAll("div.thumb-conteudo > a");
        // name
        String? name = data.querySelector("a > h2")!.text;
        // debugPrint("name: $name");
        // img
        String? img = data.querySelector("div.thumb-conteudo > a > img")!.src;
        // debugPrint("img: $img");
        // link
        String? link = data.querySelector("a")?.href;
        List<String> corteLink = link!.split("net.br/");
        // debugPrint("link: ${corteLink[1]}");

        return {
          "name": name ?? "error",
          "link": corteLink[1].replaceAll("/", ""),
          "img": img,
          "idExtension": 22
        };
      }).toList();
      books.addAll(projetoBooks);
    }
    // debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionHent.net.br: $e");
    debugPrint('$s');
    return [];
  }
}
