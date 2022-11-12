import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/nhen/extension_nhen.dart';

void main() {
  ExtensionNHen extend = ExtensionNHen();
  test("deve retornar List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint("img: ${data[0].books[0].img}");
    debugPrint("img: ${data[0].books[0].url}");
  });

  test("deve retornar um model MangaInfoOffLineModel", () async {
    var data = await extend.mangaDetail("296092"); // 296092  402560
    debugPrint("name: ${data!.name}");
    debugPrint("page: ${data.capitulos[0].pages}");
  });

  test("deve retornar um model SearchModel", () async {
    var data = await extend.search("hh"); // 296092  402560
    debugPrint("name: ${data.books[0].img}");
    // debugPrint("page: ${data.capitulos[0].pages}");
  });
}
