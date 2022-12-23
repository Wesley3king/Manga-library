import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/extensions/yabutoon/extension_yabutoon.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final Extension extend = ExtensionYabutoon();

  test("deve retornar uma lista de ModelHomePage", () async {
    var data = await extend.homePage();
    debugPrint("data: $data");
  });

  test("deve retornar um MangaInfoOffLineModel", () async {
    // unordinary tales-of-demons-and-gods
    var data = await extend.mangaDetail("unordinary");
    debugPrint("data: $data");
  });
  test("deve retornar um model Capitulos com as paginas do leitor", () async {
    var data =
        await extend.getPages("the-beginning-after-the-end-capitulo-160-yta267128", [
      Capitulos(
          capitulo: "the beginnig 160",
          id: "the-beginning-after-the-end-capitulo-160-yta267128",
          description: "",
          mark: false,
          download: false,
          downloadPages: [],
          pages: [],
          readed: false)
    ]);
    debugPrint("${data.pages}");
  });
  test("deve retornar um SearchModel", () async {
    var data = await extend.search("ju");
    debugPrint('$data');
  });
}
