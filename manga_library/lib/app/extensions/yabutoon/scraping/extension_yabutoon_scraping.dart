import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
import '../../../controllers/home_page_controller.dart';

Future<List<ModelHomePage>> scrapingHomePage(int indiceCompute) async {
  const String url = 'https://yabutoons.com/';
  const String indentify = 'div.row > div.col > div.card';
  try {
    var parser = await Chaleno().load(url);
    var result = parser?.querySelectorAll(indentify);

    var lancamentos = [];
    try {
      if (result != null) {
        for (Result element in result) {
          // name
          String? name = element.querySelector("div.card-content > h4")!.text;
          debugPrint("name: $name");
          // img
          String? img =
              element.querySelector("div.card-image > a > div > img")!.src;
          debugPrint("img: $img");
          // link
          String? link = element.querySelector('div.card-image > a')!.href;
          //link e nome
          final List<String> corteLink = link!.split('toon/');
          final List<String> corteLink2 = corteLink[1].split('-capitulo');
          debugPrint("link: ${corteLink2[0]}");

          lancamentos.add({
            "name": name ?? "erro",
            "url": corteLink2[0],
            "img": img ?? "erro",
          });
        }
      }
    } catch (e) {
      HomePageController.errorMessage = 'sesão de corte- ${e.toString()}';
      debugPrint("erro nos lançamentos: $e");
      // throw Error();
    }

    /// ultimas atualizações
    List<Map> maisLidos = [];
    List<Result>? maisLidosResults =
        parser?.querySelectorAll("div.index > div.col > div.card");
    try {
      if (maisLidosResults != null) {
        for (Result element in maisLidosResults) {
          // img
          String? img = element.querySelector("a > div.card-image > img")!.src;
          debugPrint("img: $img");
          // link
          String? link = element.querySelector('a')!.href;
          //link e nome
          final List<String> corteLink = link!.split('toon/');
          debugPrint("link: ${corteLink[1]}");

          maisLidos.add({
            "name": corteLink[1].replaceFirst('/', ''),
            "url": corteLink[1].replaceFirst('/', ''),
            "img": img ?? "erro",
          });
        }
      }
    } catch (e) {
      HomePageController.errorMessage = 'sesão de corte- ${e.toString()}';
      debugPrint("erro nos lançamentos: $e");
      // throw Error();
    }

    /// montagem de models
    List<ModelHomePage> models = [];
    List<Map> lancamentosBooks = [];
    List<Map> ultimosBooks = [];
    for (int i = 0; i < lancamentos.length; ++i) {
      if (i < 18) {
        lancamentosBooks.add(lancamentos[i]);
      } else {
        ultimosBooks.add(lancamentos[i]);
      }
    }

    /// repartir os mangas

    // montar os models
    Map<String, dynamic> lancamentosData = {
      "idExtension": 12,
      "title": "YabuToons Lançamentos",
      "books": lancamentosBooks
    };
    Map<String, dynamic> ultimosAtualizadosData = {
      "idExtension": 12,
      "title": "YabuToons Ultimos atualizados",
      "books": ultimosBooks
    };
    Map<String, dynamic> maisLidosData = {
      "idExtension": 12,
      "title": "YabuToons Mais lidos",
      "books": maisLidos
    };
    models.add(ModelHomePage.fromJson(lancamentosData));
    models.add(ModelHomePage.fromJson(ultimosAtualizadosData));
    models.add(ModelHomePage.fromJson(maisLidosData));

    return models;
  } catch (e) {
    debugPrint("erro em scrapingHomePage : $e");
    HomePageController.errorMessage = e.toString();
    return [];
  }
}

Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  try {
    var parser = await Chaleno().load('https://yabutoons.com/webtoon/$link/');

    //var dados = parser?.querySelector('script#manga-info').html.toString();

    String? state;
    String name = "";
    String description = "";
    String img = "";
    List<String> genres = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div.mango-title > h1").text!;
      // description
      description =
          parser.querySelector("div.mango-data > div.mango-description").text!;
      // link
      img = parser.querySelector("div.mango-cover-left-holder > a > img").src!;
      // state - last update
      List<Result>? stateResults =
          parser.querySelectorAll("div.mango-info-right > div");
      for (Result result in stateResults) {
        String? txt = result.text;
        if (txt!.contains("Última Atualização")) {
          state = txt.replaceFirst("tag ", "");
        } else if (txt.contains("Generos")) {
          List<String> corteGeneros = txt.split("Generos: ");
          genres = corteGeneros[1].split(",");
          genres = genres.map<String>((str) => str.trim()).toList();
        }
      }
      // capitulos
      late List<Capitulos> listCapitulos;
      List<Result>? capitulos =
          parser.querySelectorAll("div.manga-chapters > div.single-chapter");

      // realiza a construção dos capitulos na nova ou antiga interface
      listCapitulos = capitulos.map((element) {
        String linkChapter = element.querySelector("a")!.href!;
        List<String> corteLink = linkChapter.split("toon/");
        return Capitulos(
          id: corteLink[1].replaceFirst("/", ""),
          capitulo: element.querySelector("a")!.text!,
          description: element.querySelector("small")!.text!,
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [],
        );
      }).toList();

      debugPrint("passou pelo model!");
      return MangaInfoOffLineModel(
          name: name.replaceFirst("Ler ", ""),
          description: description.trim(),
          img: img,
          authors: "Autor desconhecido",
          state: state?.trim() ?? "Estado desconhecido",
          link: 'https://yabutoons.com/webtoon/$link/',
          idExtension: 12,
          genres: genres,
          alternativeName: "",
          chapters: listCapitulos.length,
          capitulos: listCapitulos);
    } else {
      debugPrint(
          "deu null no scrapingMangaDetail at extension/yabutoon/scraping");
      return null;
    }
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at Yabutoon Extension: $e");
    return null;
  }
}

// ==========================================================================
//      ------------- SCRAPING LEITOR ---------------------
// ==========================================================================

Future<List<String>> scrapingLeitor(String id) async {
  try {
    Parser? parser = await Chaleno().load('https://yabutoons.com/toon/$id/');
    List<String> pages = [];
    if (parser != null) {
      List<Result>? itens =
          parser.querySelectorAll("div.manga-navigations > img");
      for (Result result in itens) {
        String? page = result.src;
        pages.add(page ??
            "https://cdn.hugocalixto.com.br/wp-content/uploads/sites/22/2020/07/error-404-1.png");
      }
    }
    return pages;
  } catch (e) {
    debugPrint("erro no scrapingLeitor at ExtensionYabutoon: $e");
    return [];
  }
}
