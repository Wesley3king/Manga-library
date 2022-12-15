import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/hq_now/extension_hq_now.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionHqNow extend = ExtensionHqNow();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('2938');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    var data = await extend.getPages("32098", [
      Capitulos(
        capitulo: "166",
        id: "32098",
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
    var data = await extend.search("scoo");
    debugPrint('$data');
  });
}
