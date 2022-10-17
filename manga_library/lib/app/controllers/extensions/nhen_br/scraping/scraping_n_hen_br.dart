import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/home_page_model.dart';
import '../../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage() async {
  const String url = "https://nhentaibr.com/";
  const String indentify = "div.lista ul";
  try {
    Parser? parser = await Chaleno().load(url);

    Result? result = parser?.querySelector(indentify);
    // debugPrint("${result![0].html}");

    List<Result>? data = result?.querySelectorAll("li");
    // retirar os anuncios
    data!.removeAt(0);

    // inicio do processamento individual
    List<Map<String, String>> books = [];
    for (Result book in data) {
      // name
      String? name = book.querySelector("div > a > span.thumb-titulo")!.text;
      // img
      String? img = book.querySelector("div > a> span.thumb-imagem > img")!.src;
      // link
      List<Result>? links = book.querySelectorAll("div > a");
      String? link = links![1].href;
      // cortar o link
      List<String> corteLink = link!.split("com/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": corteLink[1].replaceAll("/", ""),
        "img": img ?? ""
      });
    }

    ModelHomePage model = ModelHomePage.fromJson(
        {"title": "N Hentai Br", "books": books, "idExtension": 8});

    return [model];
  } catch (e) {
    debugPrint("erro no scrapingHomePage at nhen Br: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  const String indenify = "div.post-box";
  try {
    var parser = await Chaleno().load("https://nhentaibr.com/$link/");
    // print(parser?.html);

    String? name;
    String? description;
    String? img;
    String? authors;
    List<String> genres = [];
    List<String> paginas = [];
    if (parser != null) {
      // name
      name = parser.querySelector("$indenify > div.post-conteudo > h1").text;
      // debugPrint("name: $name");
      description = parser
          .querySelector("$indenify > div.post-conteudo > div.tituloOriginal")
          .text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("$indenify > div.post-capa > img").src;
      // debugPrint("img: $img");
      // genres
      List<Result>? genresResult = parser.querySelectorAll(
          "$indenify > div.post-conteudo > ul.post-itens > li");

      for (int i = 0; i < genresResult.length; ++i) {
        List<Result>? generos = genresResult[i].querySelectorAll("a");
        if (i == 4 && (generos!.length == 1)) {
          authors = generos[0].text;
        } else {
          for (Result result in generos!) {
            genres.add("${result.text}");
          }
        }
      }
      debugPrint("genres: $genres");
      // chapters
      Result? chapterPages = parser.querySelector("ul.post-fotos");
      // debugPrint("length de cap: ${chapterPages.html}");
      List<Result>? pages = chapterPages.querySelectorAll("li > a > img");
      // debugPrint("imgs: $pages");

      for (int i = 0; i < pages!.length; ++i) {
        String? page = pages[i].src;
        paginas.add(page ?? "erro: imageé null");
        // retirar a versão pequena
        //List<String> cortePage = page!.split(
        //    "/"); // https://cdn.dogehls.xyz/galleries/2216481/1t.jpg // https://cdn.dogehls.xyz/galleries/2216481/1.jpg
        // cortePage = cortePage.reversed.toList();
        // String modificatedImage = cortePage[5].replaceAll("t", "");
        // paginas.add(
        //     "${cortePage[0]}//${cortePage[2]}/${cortePage[3]}/${cortePage[4]}/$modificatedImage");
      }
      debugPrint("pages: $paginas");

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        state: "Estado desconhecido",
        authors: authors ?? "Autor desconhecido",
        link: "https://nhentaibr.com/$link/",
        idExtension: 8,
        genres: genres,
        alternativeName: false,
        chapters: 1,
        capitulos: [
          Capitulos(
            id: "cap1",
            capitulo: "1",
            download: false,
            description: "",
            readed: false,
            disponivel: true,
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

Future<List<Map<String, String>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://nhentaibr.com/?s=$txt");
    List<Map<String, String>> books = [];

    if (parser != null) {
      // projeto
      var projetoData = parser.querySelectorAll("div.lista > ul > li");
      // print(projetoData);
      if (projetoData != null) {
        List<Map<String, String>> projetoBooks = projetoData.map((Result data) {
          List<Result>? result =
              data.querySelectorAll("div.thumb-conteudo > a");
          // name
          String? name = result![1].querySelector("span.thumb-titulo")!.text;
          debugPrint("name: $name");
          // img
          String? img = result[1].querySelector("span.thumb-imagem > img")!.src;
          debugPrint("img: $img");
          // link
          String? link = result[1].href;
          List<String> corteLink = link!.split("com/");
          debugPrint("link: ${corteLink[1]}");

          return {
            "nome": name ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "capa1": "https://cdn.dogehls.xyz/$img"
          };
        }).toList();

        books.addAll(projetoBooks);
      }
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    print(s);
    return [];
  }
}
