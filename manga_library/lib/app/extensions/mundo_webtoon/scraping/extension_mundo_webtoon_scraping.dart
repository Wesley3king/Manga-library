import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = "https://mundowebtoon.com/";
  List<ModelHomePage> models = [];
  try {
    Parser? parser = await Chaleno().load(url);
    // debugPrint("${parser?.html}");
    List<Map<String, String>> books = [];
    if (parser != null) {
      // ===============================================================
      //                ------- DESTAQUES ----------
      // ===============================================================
      List<Result>? results = parser
          .querySelectorAll("div.col-lg-12 > div.row > div.manga_item > div");

      for (Result manga in results) {
        // name
        String? name = manga
            .querySelector("div.andro_product-body > h6 > small > a")!
            .text;
        // debugPrint("name: $name");
        // img
        Result? imgResult =
            manga.querySelector("div.andro_product-thumb > a > img");
        List<String> corteImg1 = imgResult!.html!.split('data-src="');
        List<String> corteImg2 = corteImg1[1].split('"');
        // debugPrint("img: $img");
        // link
        String link = manga.querySelector("div.andro_product-thumb > a")!.href!;
        // debugPrint("link: $link");
        // List<String> corteLink = link.split(".com/");
        books.add(<String, String>{
          "name": name ?? "erro",
          "url": link.replaceAll("/", "__"),
          "img": corteImg2[0]
        });
      }
      models.add(ModelHomePage.fromJson({
        "title": "Mundo Webtoon Destaques",
        "idExtension": 20,
        "books": books
      }));
      // ===============================================================
      //                ------- Ultimas Atualizações ----------
      // ===============================================================
      books = [];
      results = parser.querySelectorAll(
          "div.atualizacoes > div.manga_item > div > div.row");

      for (Result manga in results) {
        // name
        String? name = manga
            .querySelector("div.col-lg-9 > div.andro_product-body > h5 > a")!
            .text;
        // debugPrint("name: $name");
        // img
        String? img = manga
            .querySelector("div.col-lg-3 > div.andro_product-thumb > a > img")!
            .src;
        // debugPrint("img: $img");
        // link
        String link = manga
            .querySelector("div.col-lg-3 > div.andro_product-thumb > a")!
            .href!;
        // debugPrint("link: $link");
        // List<String> corteLink = link.split(".com/");
        books.add(<String, String>{
          "name": name ?? "erro",
          "url": link.replaceAll("/", "__"),
          "img": img ?? ""
        });
      }
    }
    models.add(ModelHomePage.fromJson({
      "title": "Mundo Webtoon Destaques",
      "idExtension": 20,
      "books": books
    }));
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionMundoWebtoon: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  // const String indenify = "div#info";
  try {
    var parser = await Chaleno()
        .load("https://mundowebtoon.com/${link.replaceAll("__", "/")}");
    // print(parser?.html);
    String? name;
    String? description;
    String? img;
    String? state;
    String? authors;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div.mangaTitulo h3").text;
      // debugPrint("name: $name");
      try {
        description =
            parser.querySelector("div.andro_product-excerpt > p").text;
        // debugPrint("description: $description");
        // img
        img = parser.querySelector("div.andro_product-single-thumb > img").src;
        // debugPrint("img: $img");
        // authors
        List<Result> itens = parser.querySelectorAll("div.BlDataItem");
        const String identify = "div.andro_product-meta-item > a";
        authors =
            '${itens[0].querySelector(identify)?.text?.trim()}, ${itens[1].querySelector(identify)?.text}';
        // state
        state = itens[2].querySelector(identify)?.text;
        // genres
        List<Result> generos = parser.querySelectorAll(
            "div.col-md-12 > div.row > div.col-md-12 > div.andro_product-meta-item > a");
        for (int i = 0; i < generos.length; ++i) {
          genres.add("${generos[i].text}");
        }
        // debugPrint("genres: $genres");
        // chapters
        List<Result> chapterResults = parser.querySelectorAll(
            "div.capitulos > div.andro_single-pagination-item > div.row > div.col-sm-7 > div.CapitulosListaItem");
        for (int i = 0; i < chapterResults.length; i++) {
          // debugPrint("chapter in evaluate: $i");
          List<Result> anchors =
              chapterResults[i].querySelectorAll("a.color_gray")!;
          // link
          String link = anchors[0].href!;
          String replacedLink = link.replaceAll("/", "__");
          // debugPrint("replced link: $replacedLink");

          // name cap
          String capName = anchors[0].querySelector("h5")!.text!;
          List<String> corteDescription = capName.split("(");
          // scan
          StringBuffer scan = StringBuffer();
          for (int scanIndice = 1; scanIndice < anchors.length; ++scanIndice) {
            if (scanIndice == 1) {
              scan.write("${anchors[scanIndice].text}");
            } else {
              scan.write(", ${anchors[scanIndice].text}");
            }
          }

          chapters.add(Capitulos(
            id: replacedLink,
            capitulo: corteDescription[0].trim(),
            description: '(${corteDescription[1].trim()} - ${scan.toString()}',
            download: false,
            readed: false,
            mark: false,
            downloadPages: [],
            pages: [],
          ));
          // debugPrint("capitulo adicionado! $capName");
        }
      } catch (e) {
        debugPrint("erro ao obter informações: $e");
      }
      // debugPrint("pages: ${linkChapter[1]}");

      return MangaInfoOffLineModel(
        name: name?.trim() ?? "erro",
        description: description ?? "Descrição indisponivel",
        state: state ?? "Estado desconhecido",
        authors: authors ?? "Autor desconhecido",
        img: img ?? "erro",
        link: "https://mundowebtoon.com/${link.replaceAll("__", "/")}",
        idExtension: 20,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionMundoWebtoon: $e");
    return null;
  }
}

Future<List<String>> scrapingLeitor(String url) async {
  final Dio dio = Dio(BaseOptions(
    contentType: "application/x-www-form-urlencoded",
    headers: {
    "origin": "https://mundowebtoon.com",
    "referer": "https://mundowebtoon.com/mangabr/chainsaw-man-br3-gm/102",
    "sec-ch-ua": '"Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "Linux",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "user-agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36",
    "x-requested-with": "XMLHttpRequest"
  }));
  try {
    List<String> corteId = url.split("__");
    var data = await dio.post("https://mundowebtoon.com/leitor_image.php", data: {
      "data": corteId[1],
      "num": corteId[2],
      "modo": "1",
      "busca": "img"
    });
    List<String> pages = [];
    if (data.data != null) {
      Parser parser = Parser(data.data);
      List<Result> elements = parser.querySelectorAll("img");

      for (Result page in elements) {
        pages.add(page.src!);
      }
    }
    return pages;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionMundoWebtoon: $e");
    return [];
  }
}

// ============== SEARCH ==============
Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    Parser? parser = await Chaleno().load("https://mundowebtoon.com/mangas.php?busca=$txt");
    // books
    List<Map<String, dynamic>> books = [];
    List<Result> results = parser!.querySelectorAll("div.row > div.col-lg-2 > div.andro_product");
    for (Result book in results) {
      // name
      String? name = book.querySelector("div.andro_product-body > span.andro_product-title > a")!.text;
      // debugPrint("name: $name");
      // img
      String? img = book.querySelector("div.andro_product-thumb > a > img")!.src;
      debugPrint("img: $img");
      // link
      String link = book.querySelector("div.andro_product-thumb > a")!.href!;

      books.add({
        "name": name?.trim() ?? "error",
        "link": link.replaceAll("/", "__"),
        "img": img ??
            "https://www.gov.br/esocial/pt-br/noticias/erro-301-o-que-fazer/istock-538166792.jpg/@@images/0e47669f-288f-40b1-ac3c-77aa648636b8.jpeg",
        "idExtension": 20
      });
    }
    return books;
  } catch (e) {
    debugPrint("erro no scrapingSearch at ExtensionMundoWebtoon: $e");
    return [];
  }
}
