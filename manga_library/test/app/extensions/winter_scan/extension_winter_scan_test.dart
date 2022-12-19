import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/winter_scan/extension_winter_scan.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionWinterScan extend = ExtensionWinterScan();
  test("deve retornar um List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
  // manga detail
   test("deve retornar um ModelMangaInfoOffLine", () async {
    // a-cavaleira-do-imperador seduzindo-o-duque-do-norte-2
    var data = await extend.mangaDetail('a-cavaleira-do-imperador');
    debugPrint('$data');
  });

  // getPages
  test("deve retornar um model Capitulos", () async {
    //manga seduzindo-o-duque-do-norte-2__capitulo-1__
    // novel a-relacao-simbiotica-entre-uma-lebre-e-uma-pantera-negra__capitulo-3__
    var data = await extend.getPages("a-relacao-simbiotica-entre-uma-lebre-e-uma-pantera-negra__capitulo-3__", [
      Capitulos(
        capitulo: "3",
        id: "a-relacao-simbiotica-entre-uma-lebre-e-uma-pantera-negra__capitulo-3__",
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
    /// não funciona no site original
    var data = await extend.search("cavaleira");
    debugPrint('$data');
  });
}
