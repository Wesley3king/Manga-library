import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/mundo_webtoon/extension_mundo_webtoon.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  ExtensionMundoWebtoon extend = ExtensionMundoWebtoon();
  test("deve retornar uma lista de models", () async {
    var data = await extend.homePage();
    debugPrint("data: $data");
  });
  test("deve retornar um MangaInfoOffLineModel", () async {
    var data =
        await extend.mangaDetail("mangabr__chainsaw-man-br3-gm");
    debugPrint("data: $data");
  });

  test("deve retornar um model Capitulos com as paginas", () async {
    var data = await extend.getPages("mangabr__chainsaw-man-br3-gm__113", [
      Capitulos(
          id: "mangabr__chainsaw-man-br3-gm__113",
          capitulo: "1",
          description: "",
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [])
    ]);
    debugPrint("data: ${data.pages}");
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("wind b");
    debugPrint("data: $data");
  });
}
