import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/union_mangas/extension_union_mangas.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionUnionMangas extend = ExtensionUnionMangas();

  test("deve retornar uma lista de destaques", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('tales-of-demons-and-gods');
    debugPrint('$data');
  });

  test("deve retornar um model Capitulos", () async {
    var data = await extend.getPages("Tales_of_Demons_and_Gods--398.5", [
      Capitulos(
          capitulo: "398.5",
          id: "Tales_of_Demons_and_Gods--398.5",
          description: "",
          mark: false,
          download: false,
          downloadPages: [],
          pages: [],
          readed: false
          )
    ]);
    debugPrint('$data.pages');
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("ele");
    debugPrint('$data');
  });
}
