import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/universo_hen/extension_universo_hen.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  ExtensionUniversoHen extend = ExtensionUniversoHen();
  test("deve retornar uma lista de models", () async {
    var data = await extend.homePage();
    debugPrint("data: $data");
  });
  test("deve retornar um MangaInfoOffLineModel", () async {
    var data =
        await extend.mangaDetail("mesmo-eu-tendo-decidido-jogar-com-voce"); // tiny-evil
    debugPrint("data: $data");
  });

  test("deve retornar um model Capitulos com as paginas", () async {
    var data = await extend.getPages("14859", [
      Capitulos(
          id: "14859",
          capitulo: "1",
          description: "",
          download: false,
          readed: false,
          disponivel: true,
          downloadPages: [],
          pages: [])
    ]);
    debugPrint("data: ${data.pages}");
  });

  test("deve retornar um SearchModel", () async {
    var data =await extend.search("mesmo que");
    debugPrint("data: $data");
  });
}
