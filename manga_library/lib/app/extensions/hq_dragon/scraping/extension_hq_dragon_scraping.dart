// import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';
// import 'package:manga_library/app/models/libraries_model.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
// import '../../../../models/search_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = 'https://hqdragon.com/';
  const String indentify = 'tbody#lista-hqs > tr';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);

    var result = parser?.querySelectorAll(indentify);
    // debugPrint("lrngth: ${result?.length}");
    List<Map<String, String>> books = [];
    for (Result html in result!) {
      List<Result>? tds = html.querySelectorAll("a");
      // name
      String? name = tds![1].text;
      List<String> splitedName = name!.split("Cap");
      // debugPrint(splitedName[0]);
      // img
      String? img = tds[0].querySelector("img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = tds[0].href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("hq/");

      books.add({
        "name": splitedName[0].trim(),
        "url": linkCorte1[1].replaceAll("/", "__"),
        "img": img ?? ""
      });
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Ultimas Atualizações");
    Map<String, dynamic> destaques = {
      "idExtension": 18,
      "title": "Hq Dragon Ultimas Atualizações",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionUnionMangas: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  //const String indentify = "";

  try {
    var parser = await Chaleno()
        .load("https://hqdragon.com/hq/${link.replaceAll("__", "/")}");

    String? name;
    String? description;
    String? img;
    String? authors;
    String? state;
    // List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      final String html = parser.html!;
      // debugPrint(html);
      // name
      name = parser.querySelector("div.col-md-12 > h3.pb-3").text;
      // debugPrint("name: $name");
      List<Result>? info =
          parser.querySelectorAll("div.blog-post div.col-md-8 > p");
      // description
      for (Result result in info) {
        String text = result.text!;
        if (text.contains("Sinopse")) {
          description = text;
        } else if (text.contains("Editora")) {
          authors = text;
        } else if (text.contains("Status")) {
          state = text;
        }
      }
      // description = parser.querySelector(".panel-body").text;
      debugPrint("description: $description");
      // img
      img = parser.querySelector("div.col-md-4 > img.img-fluid").src;
      debugPrint("img: $img");

      // chapters
      List<Result> chaptersResult =
          parser.querySelectorAll("table.table > tbody > tr");
      debugPrint("length de cap: ${chaptersResult.length}");

      /// remove a descrição
      chaptersResult.removeAt(0);

      for (int i = 0; i < chaptersResult.length; ++i) {
        Result element = chaptersResult[i].querySelector("td > a")!;
        // link
        String? link = element.href;
        // pula para o próximo em caso de já existir
        //print(link);
        // if (!link!.contains("leitor/")) continue;

        List<String> corteLink1 = link!.split("leitor/");
        String replacedLink = corteLink1[1].replaceFirst("/", "--");
        // print("replced link: $replacedLink");

        // name cap
        String? capName = element.text;
        // capName?.replaceFirst("Cap. ", "");
        // print("chapetr name : $capName");

        chapters.add(Capitulos(
          id: replacedLink,
          capitulo: capName ?? "erro",
          description: "",
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [],
        ));
        debugPrint("capitulo adicionado! $capName");
      }

      return MangaInfoOffLineModel(
        name: name?.trim() ?? "erro",
        description: description ?? "erro",
        authors: authors ?? "Autor Desconhecido",
        state: state ?? "EStado desconhecido",
        img: img ?? "erro",
        link: "https://hqdragon.com/hq/${link.replaceAll("__", "/")}",
        idExtension: 18,
        genres: [],
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionUnionMangas: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  // shounen-no-abyss_cap-tulo-01
  try {
    List<String> mangaAndChapter = id.split("--");
    var parser = await Chaleno().load(
        "https://unionleitor.top/leitor/${mangaAndChapter[0]}/${mangaAndChapter[1]}");

    var resultHtml = parser?.querySelectorAll(".img-responsive");

    List<String> resultPages = [];
    if (resultHtml != null) {
      for (int i = 0; i < 2; ++i) {
        resultHtml.removeAt(0);
      }
      for (Result image in resultHtml) {
        String? page = image.src;
        debugPrint("img: $page");
        if (page != null) {
          resultPages.add(page);
        }
      }
    }

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionUnionMangas: $e");
    debugPrint('$s');
    return [];
  }
}
