import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/home_page_model.dart';
import '../../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage() async {
  const String url = "https://universohentai.com/";
  try {
    Parser? parser = await Chaleno().load(url);
    // debugPrint("${parser?.html}");
    List<Map<String, String>> books = [];
    if (parser != null) {
      List<Result>? results =
          parser.querySelectorAll("div.video div.video-thumb");
      // retirar anuncios
      results.removeAt(0);

      for (Result manga in results) {
        // print("==============================================================");
        // print(manga.html);
        // name
        String? name = manga.querySelector("span.video-titulo")!.text;
        // img
        String? img = manga.querySelector("a img")!.src;
        // link
        String? link = manga.querySelector("a")!.href;
        // debugPrint("link: $link");
        List<String> corteLink = link!.split(".com/");
        books.add(<String, String>{
          "name": name ?? "erro",
          "url": corteLink[1].replaceAll("/", ""),
          "img": img ?? ""
        });
      }
    }
    return [
      ModelHomePage.fromJson(
          {"title": "Universo Hentai", "idExtension": 6, "books": books})
    ];
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionUniversoHen: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  // const String indenify = "div#info";
  try {
    var parser = await Chaleno().load("https://universohentai.com/$link/");
    // print(parser?.html);
    String? name;
    String? description;
    String? img;
    String? authors;
    List<String> genres = [];
    List<String> linkChapter = [];
    if (parser != null) {
      Result? postInfo = parser.querySelector("ul.paginaPostItens");
      List<Result>? itens = postInfo.querySelectorAll("li");
      debugPrint("itens: $itens");
      // name
      name = parser.querySelector("div.paginaPostInfo h1").text;
      debugPrint("name: $name");
      description = itens![0].querySelector("i")?.text;
      debugPrint("description: $description");
      // img
      img = parser.querySelector("div.paginaPostThumb img").src;
      debugPrint("img: $img");
      // authors
      authors = itens[2].querySelector("a")?.text;
      // genres
      for (int cat = 3; cat < itens.length; ++cat) {
        List<Result>? generos = itens[cat].querySelectorAll("a");

        if (generos != null) {
          for (int i = 0; i < generos.length; ++i) {
            genres.add("${generos[i].text}");
          }
        }
      }
      debugPrint("genres: $genres");
      // chapters
      String? chapterPages =
          parser.querySelector("ul.paginaPostBotoes > li > a").href; //  li a
      debugPrint("linkchapter: $chapterPages");
      // debugPrint("length de cap: ${parser.querySelector("ul.paginaPostBotoes").html}");
      linkChapter = chapterPages!.split("id=");
      // debugPrint("pages: ${linkChapter[1]}");

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "Descrição indisponivel",
        state: "Finalizado",
        authors: authors ?? "Autor desconhecido",
        img: img ?? "erro",
        link: "https://universohentai.com/$link/",
        idExtension: 6,
        genres: genres,
        alternativeName: false,
        chapters: 1,
        capitulos: [
          Capitulos(
            id: linkChapter[1].replaceAll("/", ""),
            capitulo: "1",
            download: false,
            description: "",
            readed: false,
            disponivel: true,
            downloadPages: [],
            pages: [],
          ),
        ],
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionUniversoHen: $e");
    return null;
  }
} // https://universohentai.com/galeria/?id=14859

Future<List<String>> scrapingLeitor(String url) async {
  try {
    Parser? parser =
        await Chaleno().load("https://universohentai.com/galeria/?id=$url");
    List<String> pages = [];
    if (parser != null) {
      Result? result = parser.querySelector("div.galeria-foto");
      List<Result>? elements = result.querySelectorAll("a");

      if (elements != null) {
        for (Result page in elements) {
          pages.add(page.href ?? "erro");
        }
      }
    }
    return pages;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionUniversoHen: $e");
    return [];
  }
}

// ============== SEARCH ==============
Future<List<Map<String, String>>> scrapingSearch(String txt) async {
  try {
    Parser? parser = await Chaleno().load("https://universohentai.com/?s=$txt");
    Result? result = parser?.querySelector("div.videos");
    // books
    List<Map<String, String>> books = [];
    List<Result>? results = result?.querySelectorAll("div.video-thumb");
    for (Result book in results!) {
      // name
      String? name = book.querySelector("a span.video-titulo")!.text;
      // debugPrint("name: $name");
      // img
      String? img = book.querySelector("a img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = book.querySelector("a")!.href;
      //  debugPrint("link: $link");
      List<String> corteLink = link!.split("com/");

      books.add({
        "name": name ?? "error",
        "link": corteLink[1].replaceAll("/", ""),
        "img": img ??
            "https://www.gov.br/esocial/pt-br/noticias/erro-301-o-que-fazer/istock-538166792.jpg/@@images/0e47669f-288f-40b1-ac3c-77aa648636b8.jpeg"
      });
    }
    return books;
  } catch (e) {
    debugPrint("erro no scrapingSearch at ExtensionUniversoHen: $e");
    return [];
  }
}
