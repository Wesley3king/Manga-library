import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeInd) async {
  const String url = 'https://neoxscans.net/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    // ==================================================================
    //          -- LANCAMENTOS --
    // Result? lancamentos =
    //     parser?.querySelector("div.row-eq-height > div.col-6 > div.page-item-detail");
    List<Result>? lancametosItens = parser?.querySelectorAll(
        "div.row-eq-height > div.col-6 > div.page-item-detail");
    List<Map<String, String>> books = [];
    for (Result html in lancametosItens!) {
      // name
      String? name = html
          .querySelector("div.item-summary > div.post-title > h3.h5 > a")!
          .text;
      // name!.replaceAll("...", "");
      // name.replaceAll(" - ...", "");
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
    debugPrint("montando o model Lançamentos");
    Map<String, dynamic> destaques = {
      "idExtension": 14,
      "title": "Neox Scans Ultimas atualizações",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    // ============================================================
    // ======================== recomendacoes =============================
    List<Result>? novosItens = parser?.querySelectorAll(
        "div.popular-slider > div.slider__container > div.slider__item > div.item__wrap");
    books.clear();

    for (Result html in novosItens!) {
      // name
      String? name = html
          .querySelector(
              "div.slider__content > div.slider__content_item > div.post-title > h4 > a")!
          .text;
      // debugPrint("name: $name");
      // img
      String? img = html
          .querySelector(
              "div.slider__thumb > div.slider__thumb_item > a > img")!
          .src;
      // debugPrint("img: $img");
      // link
      String? link = html
          .querySelector(
              "div.slider__content > div.slider__content_item > div.post-title > h4 > a")!
          .href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");
      // debugPrint("link cortado: ${linkCorte1[1]}");

      books.add({
        "name": name ?? "erro",
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
      debugPrint("book adicionado!!!");
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model Novos");
      Map<String, dynamic> novos = {
        "idExtension": 14,
        "title": "Neox Scans Destaques",
        "books": books
      };
      models.add(ModelHomePage.fromJson(novos));
    }
    // ====================== mais lidos do dia ==========================
    List<Result>? maisLidosItens = parser?.querySelectorAll(
        "div.c-widget-content > div.widget-content > div.popular-item-wrap");
    books = [];

    for (Result html in maisLidosItens!) {
      // name
      String? name =
          html.querySelector("div.popular-content > h5.widget-title > a")!.text;
      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("div.popular-img > a > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link =
          html.querySelector("div.popular-content > h5.widget-title > a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");
      // debugPrint("link cortado: ${linkCorte1[1]}");

      books.add({
        "name": name ?? "erro",
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
      debugPrint("book adicionado!!!");
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model Mais lidos da semana");
      Map<String, dynamic> maislidos = {
        "idExtension": 14,
        "title": "Neox Scans Mais lidos do dia",
        "books": books
      };
      models.add(ModelHomePage.fromJson(maislidos));
    }
    // // montar o model
    // // debugPrint("$mangas");
    // Map<String, dynamic> lancamentos = {
    //   "idExtension": 3,
    //   "title": "Mundo Mangá Kun Lançamentos",
    //   "books": mangas
    // };
    // models.add(ModelHomePage.fromJson(lancamentos));

    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionNeoxScans: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  final Dio dio = Dio();
  try {
    var parser = await Chaleno().load("https://neoxscans.net/manga/$link/");

    String? name;
    String? description;
    String? img;
    String? state;
    String? authors;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div.post-title > h1").text;
      // debugPrint("name: $name");
      // description
      description = parser.querySelector("div.manga-excerpt > p").text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div.summary_image > a > img").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? listaInfo =
          parser.querySelectorAll("div.post-content > div.post-content_item");
      for (Result info in listaInfo) {
        try {
          final String txt =
              info.querySelector("div.summary-heading > h5")!.text!;
          if (txt.contains("Autor") || txt.contains("Estudio")) {
            final String value =
                info.querySelector("div.summary-content > div > a")!.text!;
            authors = value;
          } else if (txt.contains("Gênero")) {
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
      // debugPrint("authors: $authors");
      // debugPrint("genres: $genres");
      final List<Result> stateResult = parser.querySelectorAll(
          "div.post-content > div.post-status > div.post-content_item");
      for (Result stateResultado in stateResult) {
        final String txt =
            stateResultado.querySelector("div.summary-heading > h5")!.text!;
        if (txt.contains("Status")) {
          final String? isInHiato = parser
              .querySelector("div.post-title > span.manga-title-badges")
              .text;
          final String value =
              stateResultado.querySelector("div.summary-content")!.text!;
          state = "${value.trim()}${isInHiato == null ? "" : ", $isInHiato"}";
        }
      }
      // debugPrint("genres: $genres");
      // chapters
      List<Result> chaptersResult = parser.querySelectorAll("ul.main > li.wp-manga-chapter");

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

      return MangaInfoOffLineModel(
        name: name?.trim() ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        state: state ?? "Estado desconhecido",
        authors: authors ?? "Autor desconhecido",
        link: "https://neoxscans.net/manga/$link/",
        idExtension: 14,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionMundoMangaKun: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  // shounen-no-abyss_cap-tulo-01 https://mundomangakun.com.br/shounen-no-abyss-capitulo-114/
  try {
    var parser = await Chaleno().load("https://mundomangakun.com.br/$id/");

    List<Result>? area = parser?.querySelectorAll("div.wrapper > script");
    // area?.forEach((element) {
    //   debugPrint("area: ${element.html}");
    // });

    List<String> corteForDecode1 = area![0].html!.split('"images":["');
    List<String> corteForDecode2 = corteForDecode1[1].split('"]}]');
    // debugPrint('result: $resultHtml');

    List<String> bruteResultPages = corteForDecode2[0].split('","');
    List<String> resultPages =
        bruteResultPages.map((img) => img.replaceAll('\\', '')).toList();

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    debugPrint("$s");
    return [];
  }
}
// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://mundomangakun.com.br/?s=$txt");

    var resultHtml = parser?.querySelector("div.bixbox > div.listupd");
    List<Map<String, dynamic>> books = [];
    if (resultHtml != null) {
      // projeto
      var projetoData = resultHtml.querySelectorAll("div.bs > div.bsx");
      // print(projetoData);
      if (projetoData != null) {
        List<Map<String, dynamic>> projetoBooks =
            projetoData.map((Result data) {
          // name
          String? name = data.querySelector("a > div.bigor > div.tt")!.text;
          // debugPrint("name: $name");
          // img
          String? img = data.querySelector("a > div.limit > img")!.src;
          // debugPrint("img: $img");
          // link
          String? link = data.querySelector("a")!.href;
          // debugPrint("link: $link");
          List<String> corteLink = link!.split("manga/");
          // print(data.html);
          return {
            "name": name?.trim() ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "img": img ?? "",
            "idExtension": 3
          };
        }).toList();

        books.addAll(projetoBooks);
      }
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
