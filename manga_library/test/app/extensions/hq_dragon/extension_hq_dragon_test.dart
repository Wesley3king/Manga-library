import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/hq_dragon/extension_hq_dragon.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionHqDragon extend = ExtensionHqDragon();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail("njkznw__6937-arcana-mistica-2007");
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
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
