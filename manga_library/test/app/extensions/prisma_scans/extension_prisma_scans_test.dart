import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/prisma_scan/extension_prisma_scans.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionPrismaScan extend = ExtensionPrismaScan();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('suco-da-selva-22');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    //shounen-no-abyss-capitulo-114  shounen-no-abyss_cap-tulo-109
    var data = await extend.getPages("suco-da-selva-22__cap-83-5__", [
      Capitulos(
        capitulo: "83",
        id: "suco-da-selva-22__cap-83-5__",
        description: "",
        mark: false,
        download: false,
        downloadPages: [],
        pages: [],
        readed: false
      )
    ]);
    debugPrint('${data.pages}');
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("ju");
    debugPrint('$data');
  });
}
