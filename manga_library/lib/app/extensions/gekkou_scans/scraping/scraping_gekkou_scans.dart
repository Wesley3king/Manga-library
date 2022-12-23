// import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
// import 'package:manga_library/app/models/libraries_model.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
// import '../../../../models/search_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = 'https://gekkou.com.br/';
  const String indentify = 'div.fx-wrap';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    // debugPrint("HTML: ${parser?.html}");

    var result = parser?.querySelectorAll(indentify);
    // debugPrint("lrngth: ${result?.length}");
    List<Map<String, String>> books = [];
    for (Result html in result!) {
      // debugPrint("html: ${html.html}");
      // name
      String? name = html.querySelector("h4 > a > strong > p")!.text;
      // debugPrint(name);
      // img
      // String? img = html.querySelector(".img-thumbnail")!.src;
      String txt = html.html!;
      List<String> imgCorte1 = txt.split('data-href="');
      List<String> imgCorte2 = imgCorte1[1].split('">');
      // debugPrint("img: ${imgCorte2[0]}");
      // link
      String? link = html.querySelector("h4 > a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");

      books.add({
        "name": name ?? "erro",
        "url": linkCorte1[1],
        "img": 'https://gekkou.com.br/${imgCorte2[0]}'
      });
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Destaques");
    Map<String, dynamic> destaques = {
      "idExtension": 11,
      "title": "Gekkou Scans Ultimas atualizações",
      "books": books
    };

    models.add(ModelHomePage.fromJson(destaques));
    // hoje
    var result2 = parser?.querySelectorAll("ul > li.list-group-item");
    books = [];

    for (Result html in result2!) {
      try {
        // name
        // print(html.html);
        String name = html.querySelector("h5 > a > strong")!.text!;
        // img
        String? img = html.querySelector("a > img")!.src;
        // debugPrint("img: $img");
        // link
        String? link = html.querySelector("a")!.href;
        // debugPrint("link: $link");
        List<String> linkCorte1 = link!.split("manga/");
        // debugPrint("link cortado: ${linkCorte1[1]}");

        books.add({"name": name, "url": linkCorte1[1], "img": img ?? ""});
        debugPrint("book adicionado!!!");
      } catch (e) {
        debugPrint("não é um manga! at hoje: $e");
      }
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model Atualizações");
      Map<String, dynamic> today = {
        "idExtension": 11,
        "title": "Gekkou Scans Mais lidos",
        "books": books
      };
      models.add(ModelHomePage.fromJson(today));
    }
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
    var parser = await Chaleno().load("https://gekkou.com.br/manga/$link");

    String name = "";
    String? description;
    String? img;
    String authors = "";
    String? state;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      // name = link;
      // List<String> corteName = htmlName!.split(
      //     '<div class="col-md-12">'); // <div class="row"><div class="col-md-8 perfil-manga"><div class="row"> <h2>
      // print(corteName);
      // name = "";
      // print("name: $name");
      // description
      description = parser.querySelector("div.well > p").text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("img.img-responsive").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? infoDataResult =
          parser.querySelectorAll("dl.dl-horizontal > dd");
      List<Result>? infoResult =
          parser.querySelectorAll("dl.dl-horizontal > dt");

      for (int i = 0; i < infoResult.length; i++) {
        // debugPrint("${infoResult[i].text}");
        String txt = infoResult[i].text!;
        if (txt == "Autor(s)") {
          authors = '${infoDataResult[i].text?.trim()}';
        } else if (txt == "Artista(s)") {
          authors += ', ${infoDataResult[i].text?.trim()}';
        } else if (txt == "Status") {
          state = '${infoDataResult[i].text?.trim()}';
        } else if (txt == "Categorias") {
          // debugPrint("gg : ${infoDataResult[i].text}");
          List<String> genresPieces = infoDataResult[i].text!.split("/");
          for (String str in genresPieces) {
            genres.add(str.trim());
          }
        }
      }
      // chapters
      List<Result> chaptersResult =
          parser.querySelectorAll("ul.domaintld > li");
      // debugPrint("length de cap: ${chaptersResult.length}");

      for (int i = 0; i < chaptersResult.length; ++i) {
        if (i == 0) {
          // name =
          String value = chaptersResult[i].querySelector("a")!.text!;
          List<String> pieces = value.split(" ").reversed.toList();
          for (int index = 1; index < pieces.length; ++index) {
            name += '${pieces[index]} ';
          }
        }

        //link
        String? link = chaptersResult[i].querySelector("a")!.href;
        // // pula para o próximo em caso de já existir
        // //print(link);
        // if (!link!.contains("leitor/")) continue;

        List<String> corteLink1 = link!.split("manga/");
        String replacedLink = corteLink1[1].replaceAll("/", "--");
        // print("replced link: $replacedLink");

        // name cap
        String? capName = chaptersResult[i].querySelector("a")!.text;
        // capName?.replaceFirst("Cap. ", "");

        chapters.add(Capitulos(
          id: replacedLink,
          capitulo: capName ?? "erro",
          description: '',
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [],
        ));
        // debugPrint("capitulo adicionado! $capName");
      }

      return MangaInfoOffLineModel(
        name: name.trim(),
        description: description ?? "erro",
        authors: authors,
        state: state ?? "EStado desconhecido",
        img: img ?? "erro",
        link: "https://gekkou.com.br/manga/$link",
        idExtension: 11,
        genres: genres,
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
  // https://hentai.gekkouscans.com.br/manga/summer2/01/1
  // https://gekkou.com.br/manga/summer2/01/3
  try {
    var parser = await Chaleno()
        .load("https://gekkou.com.br/manga/${id.replaceAll("--", "/")}");

    var results = parser?.querySelectorAll("div#all > img");
    // debugPrint("result: ${results?.html}");

    List<String> resultPages = [];

    for (Result image in results!) {
      String page = image.html!;
      List<String> cortePage1 = page.split('data-src="');
      List<String> cortePage2 = cortePage1[1].split('" alt=');
      resultPages.add(cortePage2[0].trim());
      // debugPrint("img: ${cortePage2[0].replaceFirst("com.br//", "com.br/").trim()}");
    }
    // https://gekkou.com.br//uploads/manga/eleceed/chapters/1/01.jpg
    // https://gekkou.com.br//uploads/manga/eleceed/chapters/1/01.jpg
    // bool isOk = true;
    // try {
    //    await Dio(BaseOptions(
    //   headers: {
    //     "cookie": "cf_clearance=beRkkliZa_oDeD9sVJ3g8alGhXWDkTMdEydyM_TdVdQ-1664823047-0-150; _ga=GA1.3.1765495821.1664823050; __gads=ID=c742cba7cc7ab987-228cd762fa7e003b:T=1664823050:RT=1664823050:S=ALNI_MaHYwDGg4w_JHUVwXp-j8MKabizmw; HstCfa4658307=1664823295697; __dtsu=51A0164372492599D7863ED261253C7B; _cc_id=904481d0e7ca73e696106b90b3de23; HstCmu4658307=1671624926751; _gid=GA1.3.323795942.1671722594; __gpi=UID=00000873d36b0e94:T=1664823050:RT=1671722594:S=ALNI_MaZa8PMjxA2XXsC5o2qKvyIoyedUA; __cf_bm=qfsH35cQYGKU4dHo91qFs6P6NCz8qy0lMf7s_cTDh2M-1671722594-0-Ab711OzVcZ+KpsQUCuIVfm4FTcOeXBjSdHa8pMTxhSjZuoKlgnxzE8FPMC3YTaYcuc0XYhf2uAmKBy7pkPjhsncfS0PMxTLJDoi9juMyRMTmDYhn79tyB5f68y8mhdo+wt5WukX7Oeqc6uHQyu5QUYw=; HstCla4658307=1671722603665; HstPn4658307=1; HstPt4658307=18; HstCnv4658307=4; HstCns4658307=9; panoramaId_expiry=1672327408242; panoramaId=de96a9a33478236fa115efc5475416d53938bc40ace7f3c0a299de1125427a3b; XSRF-TOKEN=eyJpdiI6InFYTzk0UmRhanJlaUx5ZkxxM2NxN2c9PSIsInZhbHVlIjoiRjg3TGgxbDJhSU5Qd0swSGhadmdyUXV5K05DZGpPN2dNaHBVNmlXaUEraTREWlNMTDhYUkVyaFYrRnYxZ0VMM2NYN0xLd010UERzY1JuVlFacUgyNXc9PSIsIm1hYyI6ImZhMTY4NjY2MjZiNTI5ZjQzOTFmY2U5YzFhMjVmYWYwZDZkZTg5NTkyMzBiYTQzN2FiYjQ0MGIwZDQwZGVmYTkifQ%3D%3D; laravel_session=eyJpdiI6ImFHNTJnaUdkY0NUOU80bkN6ZHdUdkE9PSIsInZhbHVlIjoidVZXTmxzU3hwWlwvU1hQXC9ydXFnb2wzZHZMZm5pUkxoTW9taUtIYWNrbUFDWUYyZzg4WmZsK0VKTW1KSXdDSWg0THdzSHFBYlpyK0JrNjR1M2xHa2t3QT09IiwibWFjIjoiY2JlYzA4NmQxNjE4Y2EwOWQxNjQ0NDI3NDFmMWQxZGZmNGQzNTA1NzIyNWQ0NzY4YTMwZTBiNGMzY2Q0NjA4MSJ9",
    //     "referer": "https://gekkou.com.br/manga/eleceed/1/1",
    //     "sec-ch-ua": '"Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"',
    //     "sec-ch-ua-mobile": "?0",
    //     "sec-ch-ua-platform": "Linux",
    //     "sec-fetch-dest": "image",
    //     "sec-fetch-mode": "no-cors",
    //     "sec-fetch-site": "same-origin",
    //     "user-agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
    //   },
    //   connectTimeout: 60000,
    // )).get(resultPages[0]);
    // debugPrint("");
    // } catch (e) {
    //   debugPrint(
    //       "erro no teste de imagem no scrapingLeitor at ExtensionUnionMangas: $e");
    //   isOk = false;
    // }
    // if (!isOk) {
    //     resultPages = [];
    //     parser = await Chaleno().load(
    //         "https://hentai.gekkouscans.com.br/manga/${id.replaceAll("--", "/")}");
    //     results = parser?.querySelectorAll("div#all > img");
    //     for (Result image in results!) {
    //       String page = image.html!;
    //       List<String> cortePage1 = page.split('data-src="');
    //       List<String> cortePage2 = cortePage1[1].split('" alt=');
    //       resultPages.add(cortePage2[0].trim());
    //     }
    //   }
    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionUnionMangas: $e");
    debugPrint('$s');
    return [];
  }
}
