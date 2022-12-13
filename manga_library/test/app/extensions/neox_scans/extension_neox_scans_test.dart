import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/neox_scans/extension_neox_scans.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionNeoxScans extend = ExtensionNeoxScans();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('o-comeco-depois-do-fim-101032');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    //shounen-no-abyss-capitulo-114  shounen-no-abyss_cap-tulo-109
    var data = await extend.getPages("jungle-juice25__cap-83-fim-da-primeira-temporada__", [
      Capitulos(
        capitulo: "83",
        id: "jungle-juice25__cap-83-fim-da-primeira-temporada__",
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
