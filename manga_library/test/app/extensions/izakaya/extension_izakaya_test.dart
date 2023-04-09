import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/izakaya/extension_izakaya.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionIzakaya extend = ExtensionIzakaya();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
  test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('brought-by-the-demon-lord-before-the-ending');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    ///manga
    var data = await extend.getPages("brought-by-the-demon-lord-before-the-ending__capitulo-18__", [
      Capitulos(
        capitulo: "18",
        id: "brought-by-the-demon-lord-before-the-ending__capitulo-18__",
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
    var data = await extend.search("half");
    debugPrint('$data');
  });
}
