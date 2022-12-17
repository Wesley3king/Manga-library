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
        "url": linkCorte1[1].replaceAll("/", "--"),
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
    debugPrint("erro no scrapingHomePage at ExtensionHqDragon: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  //const String indentify = "";

  try {
    var parser = await Chaleno()
        .load("https://hqdragon.com/hq/${link.replaceAll("--", "/")}");

    String? name;
    String? description;
    String? img;
    String? authors;
    String? state;
    // List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // final String html = parser.html!;
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
          List<String> corteDecription = text.split("Sinopse:");
          description = corteDecription[1].trim();
        } else if (text.contains("Editora")) {
          List<String> corteEditora = text.split(": ");
          authors = corteEditora[1];
        } else if (text.contains("Status")) {
          List<String> corteState = text.split(": ");
          state = corteState[1];
        }
      }
      // description = parser.querySelector(".panel-body").text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div.col-md-4 > img.img-fluid").src;
      // debugPrint("img: $img");

      // chapters
      List<Result> chaptersResult =
          parser.querySelectorAll("table.table > tbody > tr");
      // debugPrint("length de cap: ${chaptersResult.length}");

      /// remove a descrição
      chaptersResult.removeAt(0);

      for (int i = 0; i < chaptersResult.length; ++i) {
        // debugPrint("${chaptersResult[i].html}");
        Result element = chaptersResult[i].querySelector("a")!;
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
        link: "https://hqdragon.com/hq/${link.replaceAll("--", "/")}",
        idExtension: 18,
        genres: [],
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionHqDragon: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  try {
    var parser = await Chaleno()
        .load("https://hqdragon.com/leitor/${id.replaceAll("--", "/")}");

    var resultHtml = parser?.querySelectorAll("img.img-responsive");

    List<String> resultPages = [];
    if (resultHtml != null) {
      for (Result image in resultHtml) {
        String? page = image.src;
        // debugPrint("img: $page");
        if (page != null) {
          resultPages.add(page);
        }
      }
    }

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionHqDragon: $e");
    debugPrint('$s');
    return [];
  }
}

// ============== SEARCH ==============
Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    Parser? parser =
        await Chaleno().load("https://hqdragon.com/pesquisa?nome_hq=$txt");
    // Result? result = parser?.querySelector("div.row");
    // books
    List<Map<String, dynamic>> books = [];
    List<Result>? results = parser?.querySelectorAll("div.row > div.col-sm-6");
    for (Result book in results!) {
      List<Result> anchors = book.querySelectorAll("a")!;
      // name
      String? name = anchors[1].text;
      debugPrint("name: $name");
      // img
      String? img = anchors[0].querySelector("img")!.src;
      debugPrint("img: $img");
      // link
      String? link = anchors[0].href;
       debugPrint("link: $link");
      List<String> corteLink = link!.split("hq/");

      books.add({
        "name": name ?? "error",
        "link": corteLink[1].replaceAll("/", "--"),
        "img": img ??
            "https://www.gov.br/esocial/pt-br/noticias/erro-301-o-que-fazer/istock-538166792.jpg/@@images/0e47669f-288f-40b1-ac3c-77aa648636b8.jpeg",
        "idExtension": 18
      });
    }
    return books;
  } catch (e) {
    debugPrint("erro no scrapingSearch at ExtensionHqDragon: $e");
    return [];
  }
}
