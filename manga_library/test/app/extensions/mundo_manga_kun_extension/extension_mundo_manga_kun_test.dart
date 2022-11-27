import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionMundoMangaKun extend = ExtensionMundoMangaKun();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('shounen-no-abyss'); // the-legendary-moonlight-sculptor shounen-no-abyss
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    //shounen-no-abyss-capitulo-114  shounen-no-abyss_cap-tulo-109
    var data = await extend.getPages("shounen-no-abyss-capitulo-114", [
      Capitulos(
        capitulo: "114",
        id: "shounen-no-abyss-capitulo-114",
        description: "",
        mark: false,
        download: false,
        downloadPages: [],
        pages: [],    // https://drive.google.com/uc?export=view&id=1yH3aSar0XO6h3qpLPJzliiXmRVJP_-eo
        readed: false // https://drive.google.com/uc?export=view&id=1yH3aSar0XO6h3qpLPJzliiXmRVJP_-eo
      )
    ]);
    debugPrint('${data.pages}');
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("sho");
    debugPrint(data[0].name);
  });
}
