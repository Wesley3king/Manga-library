import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/see_mangas/extension_see_mangas.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionSeeMangas extend = ExtensionSeeMangas();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('black-clover-my2621');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    var data = await extend.getPages("black-clover-capitulo-1-zyy263", [
      Capitulos(
        capitulo: "1",
        id: "black-clover-capitulo-1-zyy263",
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
    var data = await extend.search("ele");
    debugPrint('$data');
  });
}
