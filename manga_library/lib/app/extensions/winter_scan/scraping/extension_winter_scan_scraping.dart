import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = 'https://winterscan.com/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);

    // ==================================================================
    //          -- ULTIMAS ATUALIZAÇÕES --
    List<Result>? lancamentos = parser?.querySelectorAll(
        "div.page-content-listing > div.page-listing-item > div.row > div.col-6 > div.page-item-detail");
    List<Map<String, String>> books = [];
    for (Result html in lancamentos!) {
      // name
      String? name = html
          .querySelector("div.item-summary > div.post-title > h3.h5 > a")!
          .text;
      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("div.item-thumb > a > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector("div.item-thumb > a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");

      books.add({
        "name": name!,
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Ultimas Atualizações");
    Map<String, dynamic> destaques = {
      "idExtension": 15,
      "title": "Winter Scan Ultimas Atualizações",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionWinterScan: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  final Dio dio = Dio();
  //const String indentify = "";

  try {
    var parser = await Chaleno().load("https://winterscan.com/manga/$link/");

    String? name;
    String? description;
    String? img;
    String? authors;
    String? status;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div.post-title > h1").text;
      // debugPrint("name: $name");
      // description
      description = parser
          .querySelector("div.description-summary > div.summary__content")
          .text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div.summary_image > a > img").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? listaInfo =
          parser.querySelectorAll("div.post-content > div.post-content_item");
      StringBuffer buffer = StringBuffer();
      for (Result info in listaInfo) {
        try {
          final String txt =
              info.querySelector("div.summary-heading > h5")!.text!;
          if (txt.contains("Author")) {
            final String value =
                info.querySelector("div.summary-content > div > a")!.text!;
            buffer.write(value);
          } else if (txt.contains("Tag")) {
            genres.add(
                "${info.querySelector("div.summary-content > div > a")!.text}");
          } else if (txt.contains("Genre")) {
            // genres
            List<Result>? genresResult = parser.querySelectorAll(
                "div.summary-content > div.genres-content > a");
            // print(genresResult);
            for (int i = 0; i < genresResult.length; ++i) {
              genres.add("${genresResult[i].text}");
            }
          }
        } catch (e) {
          debugPrint("não encontrado o elemento: $e");
        }
      }

      authors = buffer.toString();
      // debugPrint("authors: $authors");
      // debugPrint("genres: $genres");
      final List<Result> stateResult =
          parser.querySelectorAll("div.post-status > div.post-content_item");
      for (Result stateResultado in stateResult) {
        final String txt =
            stateResultado.querySelector("div.summary-heading > h5")!.text!;
        if (txt.contains("Status")) {
          // final String? isInHiato = parser
          //     .querySelector("div.post-title > span.manga-title-badges")
          //     .text;
          final String value =
              stateResultado.querySelector("div.summary-content")!.text!;
          status = value.trim();
        }
      }
      // debugPrint("state: $status");
      // chapters
      final Response response =
          await dio.post("https://winterscan.com/manga/$link/ajax/chapters/");
      final Parser chaptersParser = Parser(response.data);
      List<Result> chaptersResult =
          chaptersParser.querySelectorAll("ul.main > li.wp-manga-chapter");

      for (Result result in chaptersResult) {
        // debugPrint("inice: $indice / cap: ${chaptersResult.length}");
        // indice++;
        // link
        String? link = result.querySelector("a")!.href;

        List<String> corteLink1 = link!.split("manga/");
        String replacedLink = corteLink1[1].replaceAll("/", "__");
        // debugPrint("replaced link: $replacedLink");

        // name cap
        String? capName = result.querySelector("a")!.text;
        // String chapter = capName!.replaceAll("Capítulo ", "");
        // debugPrint("chapter name : $capName");
        // description
        String? capDescription =
            result.querySelector("span.chapter-release-date > i")!.text;

        chapters.add(Capitulos(
          id: replacedLink,
          capitulo: capName!.trim(),
          description: capDescription ?? "",
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [],
        ));
        // debugPrint("capitulo adicionado! $capName");
      }
      // debugPrint("length de cap> ${chapters.length}");

      return MangaInfoOffLineModel(
        name: name?.trim() ?? "erro",
        description: description?.trim() ?? "erro",
        img: img ?? "erro",
        authors: authors,
        state: status ?? "Estado desconhecido",
        link: "https://winterscan.com/manga/$link/",
        idExtension: 15,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionWinterScan: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  try {
    List<String> resultPages = [];
    var parser = await Chaleno()
        .load("https://winterscan.com/manga/${id.replaceAll("__", "/")}");
    final Result? novelParser =
        parser?.querySelector("div.reading-content > div.text-left");
    if (novelParser?.html == null) {
      final List<Result>? resultHtml = parser
          ?.querySelectorAll("div.reading-content > div.page-break > img");
      if (resultHtml != null) {
        for (Result image in resultHtml) {
          List<String> cortePage1 = image.html!.split('src="');
          List<String> cortePage2 = cortePage1[1].split('" class');
          resultPages.add(cortePage2[0].trim());
        }
      }
    } else {
      resultPages.add("== NOVEL READER ==");
      List<Result>? lines = novelParser!.querySelectorAll("p > span");
      if (lines != null && lines.isEmpty) {
        lines = novelParser.querySelectorAll("p");
        for (Result line in lines!) {
          resultPages.add('${line.text}');
        }
      } else {
        for (Result line in lines!) {
          resultPages.add('${line.text}');
        }
      }
    }

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionWinterScan: $e");
    debugPrint("$s");
    return [];
  }
}
// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    // var parser = await Chaleno().load("https://winterscan.com/?s=$txt");

    // var resultHtml = parser?.querySelector(
    //     "div.search-wrap > div.tab-content-wrap > div.c-tabs-item");
    List<Map<String, dynamic>> books = [];
    // if (resultHtml != null) {
    //   // projeto
    //   var projetoData = resultHtml.querySelectorAll("div.row");
    //   if (projetoData != null) {
    //     List<Map<String, dynamic>> projetoBooks =
    //         projetoData.map((Result data) {
    //       // name
    //       String? name = data
    //           .querySelector(
    //               "div.col-8 > div.tab-summary > div.post-title > h3.h4 > a")!
    //           .text;
    //       // debugPrint("name: $name");
    //       // img
    //       String? img =
    //           data.querySelector("div.col-4 > div.tab-thumb > a > img")!.src;
    //       // debugPrint("img: $img");
    //       // link
    //       String? link = data
    //           .querySelector(
    //               "div.col-8 > div.tab-summary > div.post-title > h3.h4 > a")!
    //           .href;
    //       // debugPrint("link: $link");
    //       List<String> corteLink = link!.split("manga/");
    //       // print(data.html);
    //       return {
    //         "name": name?.trim() ?? "error",
    //         "link": corteLink[1].replaceAll("/", ""),
    //         "img": img ?? "",
    //         "idExtension": 13
    //       };
    //     }).toList();

    //     books.addAll(projetoBooks);
    //   }
    // }
    // debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionWinterScan: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
