import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionMundoMangaKun extend = ExtensionMundoMangaKun();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    //print(data);
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('shounen-no-abyss');
    print(data);
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    var data = await extend.getPages("shounen-no-abyss_cap-tulo-01", [
      Capitulos(
        capitulo: "01",
        id: "shounen-no-abyss_cap-tulo-01",
        disponivel: false,
        download: false,
        downloadPages: [],
        pages: [],
        readed: false
      )
    ]);
    print(data);
  });
}
