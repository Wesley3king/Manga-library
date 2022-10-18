import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionMundoMangaKun extend = ExtensionMundoMangaKun();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    //print(data);
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('shounen-no-abyss');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    var data = await extend.getPages("shounen-no-abyss_cap-tulo-109", [
      Capitulos(
        capitulo: "01",
        id: "shounen-no-abyss_cap-tulo-109",
        description: "",
        disponivel: false,
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
    debugPrint(data.books[0].name);
  });
}
