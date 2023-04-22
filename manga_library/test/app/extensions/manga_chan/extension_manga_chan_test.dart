import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/manga_chan/extension_manga_chan.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final ExtensionMangaChan extend = ExtensionMangaChan();

  test("deve retornar uma lista de destaques", () async {
    var data = await extend.homePage();
    // https://img.mangaschan.com/uploads/manga-images/m/martial-arts-reigns/thumbnail.jpg
    // //img.mangaschan.com/uploads/manga-images/m/martial-arts-reigns/thumbnail.jpg
    debugPrint("length: ${data.length}");
  });
  test("deve retornar um ModelMangaInfoOffLine", () async {
    // tales-of-demons-and-gods wind-breaker
    var data = await extend.mangaDetail('wind-breaker');
    debugPrint('${data?.capitulos.length}');
    debugPrint('${data?.capitulos[0].description}');
  });

  test("deve retornar um model Capitulos com as paginas do leitor", () async {
    //return-of-the-frozen-player-novel-capitulo-0 tales-of-demons-and-gods-capitulo-312-5
    // tsuki-ga-michibiku-isekai-douchuu-capitulo-1 wind-breaker-capitulo-0
    var data =
        await extend.getPages("wind-breaker-capitulo-0", [
      Capitulos(
          capitulo: "0",
          id: "wind-breaker-capitulo-0",
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
    var data = await extend.search("elf w");
    debugPrint('$data');
  });
}
