import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/silence_scan/extension_silence_scan.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionSilenceScan extend = ExtensionSilenceScan();

  test("deve retornar uma lista de destaques", () async {
    var data = await extend.homePage();
    debugPrint("$data");
  });
  test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('houkago-no-goumon-shoujo');
    debugPrint('$data');
  });

  test("deve retornar um model Capitulos", () async {
    var data = await extend.getPages("houkago-no-goumon-shoujo-capitulo-116", [
      Capitulos(
          capitulo: "116",
          id: "houkago-no-goumon-shoujo-capitulo-116",
          description: "",
          disponivel: false,
          download: false,
          downloadPages: [],
          pages: [],
          readed: false
          )
    ]);
    debugPrint("${data.pages}");
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("sono bisque Doll");
    print(data);
  });
}
