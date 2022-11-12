import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/hen_season/extension_hen_season.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  ExtensionHenSeason extend = ExtensionHenSeason();
  test("deve retornar uma lista de models", () async {
    var data = await extend.homePage();
    debugPrint("data: ${data[0].books[0].url}");
  });
  test("deve retornar um MangaInfoOffLineModel", () async {
    var data = await extend
        .mangaDetail("2022_10_12_kyuujitsu-no-kaku_"); // 2022_10_12_kyuujitsu-no-kaku_ 2022_08_25_pack-de-imagens-genshin-impact-v2_
    debugPrint("data: ${data?.toJson()}");
  });

  test("deve retornar um model Capitulos com as paginas", () async {
    var data = await extend.getPages("14859", [
      Capitulos(
          id: "14859",
          capitulo: "1",
          description: '',
          download: false,
          readed: false,
          disponivel: true,
          downloadPages: [],
          pages: [])
    ]);
    debugPrint("data: ${data.pages}");
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("dom");
    if (data.books.isNotEmpty) {
      debugPrint("data: ${data.books[0].link}");
    }
  });
}
