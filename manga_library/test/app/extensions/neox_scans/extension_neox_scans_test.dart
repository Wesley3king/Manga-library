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
    // death-is-the-only-ending-for-the-villainess-512129 o-comeco-depois-do-fim-512129
    // he-player-that-cant-level-up-novel-708031 return-of-the-frozen-player-novel-708031
    var data = await extend.mangaDetail('he-player-that-cant-level-up-novel-708031');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    ///manga
    // var data = await extend.getPages("o-comeco-depois-do-fim-101032__cap-166__", [
    //   Capitulos(
    //     capitulo: "166",
    //     id: "o-comeco-depois-do-fim-101032__cap-166__",
    //     description: "",
    //     mark: false,
    //     download: false,
    //     downloadPages: [],
    //     pages: [],
    //     readed: false
    //   )
    // ]);

    /// novel 
    var data = await extend.getPages("the-player-that-cant-level-up-novel-101032__cap-108__", [
      Capitulos(
        capitulo: "108",
        id: "the-player-that-cant-level-up-novel-101032__cap-108__",
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
    var data = await extend.search("the beg");
    debugPrint('$data');
  });
}
