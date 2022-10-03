import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/home_page_model.dart';

Future<List<ModelHomePage>> scrapingHomePage() async {
  const String url = 'https://silencescan.com.br/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    // var result = parser?.querySelectorAll(indentify);
    // debugPrint("lrngth: ${result?.length}");
    // ==================================================================
    //          -- LANCAMENTOS --
    Result? lancamentos = parser?.querySelector("div.listupd");
    List<Result>? lancametosItens = lancamentos?.querySelectorAll("");
    List<Map<String, String>> books = [];
    for (Result html in lancametosItens!) {
      // name
      String? name = html.querySelector("span a")!.text;
      name!.replaceAll("...", "");
      name.replaceAll(" - ...", "");
      // debugPrint(name);
      // img
      String? img = html.querySelector(".img-thumbnail")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector(".link-titulo")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");

      books.add({"name": name, "url": linkCorte1[1], "img": img ?? ""});
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Destaques");
    Map<String, dynamic> destaques = {
      "idExtension": 4,
      "title": "Union Mangas Destaques",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    // hoje
    var result2 = parser?.querySelectorAll(".col-md-12");
    books = [];
    // remover falhas de corte
    for (int i = 0; i < 9; ++i) {
      result2?.removeAt(0);
    }

    for (Result html in result2!) {
      try {
        // name
        // print(html.html);
        List<Result>? nameList = html.querySelectorAll(".link-titulo");
        // print(nameList);
        // nameList!.forEach((element) =>
        //     print("${element.html} \n --------------------------------"));
        String? name = nameList![1].text;
        // name!.replaceAll("...", "");
        // name.replaceAll(" - ...", "");
        // debugPrint(name);
        // img
        String? img = html.querySelector(".link-titulo img")!.src;
        // debugPrint("img: $img");
        // link
        String? link = html.querySelector(".link-titulo")!.href;
        // debugPrint("link: $link");
        List<String> linkCorte1 = link!.split("manga/");
        // debugPrint("link cortado: ${linkCorte1[1]}");

        books.add(
            {"name": name ?? "erro", "url": linkCorte1[1], "img": img ?? ""});
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
        "idExtension": 4,
        "title": "Union Mangas Atualizações",
        "books": books
      };
      models.add(ModelHomePage.fromJson(today));
    }
    // print(result!.length);
    // result.forEach((element) =>
    //     print("${element.html} \n --------------------------------"));
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionUnionMangas: $e");
    return [];
  }
}
