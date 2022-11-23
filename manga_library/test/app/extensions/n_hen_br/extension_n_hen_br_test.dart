import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/nhen_br/extension_n_hen_br.dart';

void main() {
  ExtensionNHenBr extend = ExtensionNHenBr();
  
  test("deve retornar List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint("img: ${data[0].books[0].img}");
    debugPrint("img: ${data[0].books[0].url}");
  });

  test("deve retornar um model MangaInfoOffLineModel", () async {
    var data = await extend.mangaDetail("a-primeira-vez-de-uma-garota-colegial-timida-abencoada-com-inteligencia-e-beleza"); // 296092  402560
    debugPrint("name: ${data!.name}");
    debugPrint("page: ${data.capitulos[0].pages}");
  });

  test("deve retornar um model SearchModel", () async {
    var data = await extend.search("hh");
    debugPrint("name: ${data[0].img}");
  });
}
