import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = "https://hentaiseason.com/";
  try {
    Parser? parser = await Chaleno().load(url);
    // debugPrint("${parser?.html}");
    List<Map<String, String>> books = [];
    if (parser != null) {
      Result? divArea = parser.querySelector("div.lista ul");
      List<Result>? results = divArea.querySelectorAll("li div.thumb-conteudo");
      // retirar anuncios
      // results.removeAt(0);

      for (Result manga in results!) {
        // name
        String? name = manga.querySelector("a span.thumb-titulo")!.text;
        // debugPrint("name: $name");
        // img
        String? img = manga.querySelector("a > span.thumb-imagem > img")!.src;
        // debugPrint("img: $img");
        // link
        String? link = manga.querySelector("a")!.href;
        // debugPrint("link: $link");
        // debugPrint("link: $link");
        List<String> corteLink = link!.split(".com/");
        // String retiraUltimaBarra = corteLink[1].replaceRange(, end, replacement)
        String modicaredLink = corteLink[1].replaceAll("/", "_");
        // int lengthOfModificated = modicaredLink.length -1;
        // print(modicaredLink.substring(lengthOfModificated));
        // modicaredLink = modicaredLink.replaceRange(
        //     lengthOfModificated, (lengthOfModificated+1), "");
        // debugPrint("mod: $modicaredLink");
        books.add(<String, String>{
          "name": name ?? "erro",
          "url": modicaredLink,
          "img": img ?? ""
        });
      }
    }
    return [
      ModelHomePage.fromJson(
          {"title": "Hentai Seanson", "idExtension": 7, "books": books})
    ];
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionHenSeason: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  try {
    var parser = await Chaleno().load("https://hentaiseason.com/$link");
    // print(parser?.html);
    String? name;
    String? description;
    String? img;
    String? author;
    String? tradutor;
    List<String> genres = [];
    List<String> pagesChapter = [];
    if (parser != null) {
      List<Result>? postBoxes = parser.querySelectorAll("div.post-box");
      Result? postInfo = postBoxes[0];
      // List<Result>? itens = postInfo.querySelectorAll("li");
      // name
      name = postInfo.querySelector("h1")!.text;
      debugPrint("name: $name");
      description = postInfo.querySelector("div.post-texto > p > strong")!.text;
      debugPrint("description: $description");
      // img
      img = postInfo.querySelector("div.post-capa img")?.src;
      debugPrint("img: $img");
      // genres
      List<Result>? generos = postInfo.querySelectorAll("ul.post-itens > li");
      // print(generos);

      try {
        for (int i = 0; i < 2; ++i) {
          List<Result>? classeDeGenero = generos![i].querySelectorAll("a");
          for (Result result in classeDeGenero!) {
            genres.add("${result.text}");
          }
        }
      } catch (e) {
        debugPrint("não tem duas classes: $e");
      }
      // author & tradutor
      for (Result resultado in generos!) {
        String? txt = resultado.querySelector("strong")?.text;
        if (txt == "Artista") {
          List<Result>? lista = resultado.querySelectorAll("a");
          StringBuffer buffer = StringBuffer();
          for (Result result in lista ?? []) {
            buffer.write('${result.text}');
          }
          author = buffer.toString();
        } else if (txt == "Tradutor") {
          List<Result>? lista = resultado.querySelectorAll("a");
          StringBuffer buffer = StringBuffer();
          for (Result result in lista ?? []) {
            buffer.write('${result.text}');
          }
          tradutor = buffer.toString();
        }
      }
      // debugPrint("genres: $genres");
      // chapters
      List<Result>? chapterPages =
          postBoxes[1].querySelectorAll("ul.post-fotos > li > a"); //  li a

      for (Result result in chapterPages!) {
        String? chapter = result.querySelector("img")!.src;
        chapter = chapter?.replaceFirst("-241x334", "");
        // https://hentaiseason.com/wp-content/uploads/2022/08/pack_genshin_v2_02-241x334.jpg
        pagesChapter.add(chapter ?? "erro: a imagem é null");
      }
      // debugPrint("pages: $pagesChapter");

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        state: 'Finalizado',
        authors: author ?? "Autor desconhecido",
        img: img ?? "erro",
        link: "https://hentaiseason.com/$link",
        idExtension: 7,
        genres: genres,
        alternativeName: false,
        chapters: 1,
        capitulos: [
          Capitulos(
            id: "chap1",
            capitulo: "1",
            download: false,
            description: tradutor ?? "",
            readed: false,
            disponivel: true,
            downloadPages: [],
            pages: pagesChapter,
          ),
        ],
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionHenSeason: $e");
    return null;
  }
}

// ============== SEARCH ==============
Future<List<Map<String, String>>> scrapingSearch(String txt) async {
  try {
    Parser? parser = await Chaleno().load(
        "https://hentaiseason.com/?s=$txt"); // https://hentaiseason.com/?s=do
    Result? result = parser?.querySelector("div.lista > ul");
    // books
    List<Map<String, String>> books = [];
    List<Result>? results = result?.querySelectorAll("li div.thumb-conteudo");
    for (Result book in results!) {
      // name
      String? name = book.querySelector("a span.thumb-titulo")!.text;
      debugPrint("name: $name");
      // img
      String? img = book.querySelector("a span.thumb-imagem > img")!.src;
      debugPrint("img: $img");
      // link
      String? link = book.querySelector("a")!.href;
      debugPrint("link: $link");
      List<String> corteLink = link!.split("com/");
      String modicaredLink = corteLink[1].replaceAll("/", "_");

      books.add({
        "name": name ?? "error",
        "link": modicaredLink,
        "img": img ?? "erro: imagem"
      });
    }
    return books;
  } catch (e) {
    debugPrint("erro no scrapingSearch at ExtensionUniversoHen: $e");
    return [];
  }
}
