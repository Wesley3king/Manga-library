import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

final Map<String, dynamic> header = {
  "cookie": null,
  "sec-ch-ua":
      '"Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"',
  "sec-ch-ua-mobile": "?0",
  "sec-ch-ua-platform": '"Linux"',
  "sec-fetch-dest": "document",
  "sec-fetch-mode": "navigate",
  "sec-fetch-site": "none",
  "sec-fetch-user": "?1",
  "upgrade-insecure-requests": "1",
  "user-agent":
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
};
final Dio dio = Dio(BaseOptions(
  headers: header,
));

Future<void> fetchToken() async {
  if (header["cookie"] == null) {
    try {
      
    } catch (e) {
      debugPrint("erro no fetchToken at ExtensionNHen.net: $e");
    }
    var data = await dio.get("https://wesley3king.github.io/reactJS/token/token_n.json");
    debugPrint("token: ${data.data['cookie']}");
    header["cookie"] = data.data['cookie'];
    dio.options.headers = header;
  } else {
    debugPrint("token found!");
  }
}

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String indentify = "div.index-container";
  List<ModelHomePage> models = [];

  /// verify token
  await fetchToken();
  try {
    var dataResponse = await dio.get("https://nhentai.net/");
    Parser parser = Parser(dataResponse.data);

    List<Result>? result = parser.querySelectorAll(indentify);
    // debugPrint("${result![0].html}");

    List<Result>? data = result[0].querySelectorAll("div.gallery");

    // inicio do processamento individual
    List<Map<String, String>> books = [];
    for (Result book in data!) {
      // debugPrint("book: ${book.html}");
      // name
      String? name = book.querySelector("div.caption")!.text;
      // img
      List<String> corteNoscript = book.html!.split("<noscript><img");
      List<String> corteImg1 = corteNoscript[1].split('" width="');
      List<String> corteImg2 = corteImg1[0].split('src="');
      String? img = corteImg2[1];
      // link
      String? link = book.querySelector("a.cover")!.href;
      // cortar o link
      List<String> corteLink = link!.split("g/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": corteLink[1].replaceAll("/", ""),
        "img": img
      });
    }

    models.add(ModelHomePage.fromJson(
        {"title": "NHentai Destaques", "books": books, "idExtension": 19}));
    data = result[1].querySelectorAll("div.gallery");

    // reseta os livros
    books = [];
    for (Result book in data!) {
      // name
      String? name = book.querySelector("div.caption")!.text;
      // img
      //String? img = book.querySelector("noscript > img")!.src;
      List<String> corteNoscript = book.html!.split("<noscript><img");
      List<String> corteImg1 = corteNoscript[1].split('" width="');
      List<String> corteImg2 = corteImg1[0].split('src="');
      String? img = corteImg2[1];
      // link
      String? link = book.querySelector("a.cover")!.href;
      // cortar o link
      List<String> corteLink = link!.split("g/");
      // montar o model ModelHomeBook
      books.add(<String, String>{
        "name": name ?? "erro",
        "url": corteLink[1].replaceAll("/", ""),
        "img": img
      });
    }

    models.add(ModelHomePage.fromJson({
      "title": "NHentai Ultimos Adicionados",
      "books": books,
      "idExtension": 19
    }));

    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at nhen.net: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  const String indenify = "div#info";
  /// verify token
  await fetchToken();
  try {
    var dataResponse = await dio.get("https://nhentai.net/g/$link/");
    Parser parser = Parser(dataResponse.data);
    // print(parser?.html);

    String? name;
    String? description;
    String? img;
    StringBuffer authors = StringBuffer();
    String? state;
    List<String> genres = [];
    List<String> paginas = [];
    // name
    name = parser.querySelector("$indenify h1").text;
    // debugPrint("name: $name");
    description = parser.querySelector("$indenify h2").text;
    // debugPrint("description: $description");
    // img
    Result imgParser = parser.querySelector("div#cover a");
    List<String> corteNoscript = imgParser.html!.split("<noscript><img");
    List<String> corteImg1 = corteNoscript[1].split('" width="');
    List<String> corteImg2 = corteImg1[0].split('src="');
    img = corteImg2[1];
    // debugPrint("img: $img");
    // genres
    List<Result>? genresResult =
        parser.querySelectorAll("div.tag-container"); // $indenify div#tags
    // print(genresResult);
    List<Result>? generos =
        genresResult[2].querySelectorAll("a > span.name"); // span.tags
    // print(generos);

    for (int i = 0; i < generos!.length; ++i) {
      genres.add("${generos[i].text}");
    }
    // debugPrint("genres: $genres");
    // authors
    List<Result>? artists = genresResult[3].querySelectorAll("a");
    for (int i = 0; i < artists!.length; ++i) {
      authors.write('${artists[i].text}');
    }
    // state
    state = parser.querySelector("span.tags > time").text;
    debugPrint("state: $state");

    // chapters
    List<Result>? pages = parser.querySelectorAll("div.thumb-container > a");
    // debugPrint("imgs: $pages");

    for (int i = 0; i < pages.length; ++i) {
      List<String> corteNoscript = pages[i].html!.split("<noscript><img");
      debugPrint("html: ${pages[i].html}");
      List<String> corteImg1 = corteNoscript[1].split('" width="');
      List<String> corteImg2 = corteImg1[0].split('src="');
      String page = corteImg2[1];
      // retirar a versão pequena
      List<String> cortePage = page.split("/");
      String modificatedImage = cortePage[5].replaceAll("t", "");
      List<String> domain = cortePage[2].split(".");
      String domainNum = domain[0].replaceFirst("t", "");
      paginas.add(
          "${cortePage[0]}//i$domainNum.nhentai.net/${cortePage[3]}/${cortePage[4]}/$modificatedImage");
    }
    // debugPrint("pages: $paginas");

    return MangaInfoOffLineModel(
      name: name ?? "erro",
      description: description ?? "erro",
      img: img,
      authors: authors.toString(),
      state: state ?? "Estado desconhecido",
      link: "https://nhentai.net/g/$link/",
      idExtension: 19,
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
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionNhen.net: $e");
    return null;
  }
}

// ----------------------------------------------------------------------------
//                     === SEARCH ===

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    /// verify token
    await fetchToken();
    var dataResponse = await dio.get("https://nhentai.net/search/?q=$txt");
    Parser parser = Parser(dataResponse.data);

    var resultHtml = parser.querySelector("div.index-container");
    List<Map<String, dynamic>> books = [];

    // projeto
    var projetoData = resultHtml.querySelectorAll("div.gallery");
    if (projetoData != null) {
      List<Map<String, dynamic>> projetoBooks = projetoData.map((Result data) {
        // name
        String? name = data.querySelector("a div.caption")!.text;
        // debugPrint("name: $name");
        // img
        // Result imgResult = data.querySelector("a img")!;
        List<String> corteNoscript = data.html!.split("<noscript><img");
        List<String> corteImg1 = corteNoscript[1].split('" width="');
        List<String> corteImg2 = corteImg1[0].split('src="');
        String img = corteImg2[1];
        // debugPrint("img: $img");
        // link
        String? link = data.querySelector("a")!.href;
        List<String> corteLink = link!.split("g/");
        // debugPrint("link: ${corteLink[1]}");
        // print(data.html);
        return {
          "name": name ?? "error",
          "link": corteLink[1].replaceAll("/", ""),
          "img": img,
          "idExtension": 19
        };
      }).toList();

      books.addAll(projetoBooks);
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionNhen.net: $e");
    debugPrint('$s');
    return [];
  }
}
