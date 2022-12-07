import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/winter_scan/extension_winter_scan.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionWinterScan extend = ExtensionWinterScan();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('seduzindo-o-duque-do-norte-2');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    //manga
    var data = await extend.getPages("seduzindo-o-duque-do-norte-2__capitulo-1__", [
      Capitulos(
        capitulo: "1",
        id: "seduzindo-o-duque-do-norte-2__capitulo-1__",
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
