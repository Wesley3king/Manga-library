import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/manga_chan/extension_manga_chan.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionMangaChan extend = ExtensionMangaChan();

  test("deve retornar uma lista de destaques", () async {
    var data = await extend.homePage();
    debugPrint("length: ${data.length}");
  });
  test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('tales-of-demons-and-gods');
    print(data?.capitulos.length);
  });

  test("deve retornar um model Capitulos com as paginas do leitor", () async {
    var data =
        await extend.getPages("tales-of-demons-and-gods-capitulo-312-5", [
      Capitulos(
          capitulo: "312-5",
          id: "houkago-no-goumon-shoujo-capitulo-116",
          disponivel: false,
          download: false,
          downloadPages: [],
          pages: [],
          readed: false)
    ]);
    debugPrint("${data.pages}");
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("elf w");
    print(data);
  });
}
