import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/universo_hen/extension_universo_hen.dart';

void main() {
  ExtensionUniversoHen extend = ExtensionUniversoHen();
  test("deve retornar uma lista de models", () async {
    var data = await extend.homePage();
    debugPrint("data: $data");
  });
  test("deve retornar um MangaInfoOffLineModel", () async {
    var data = await extend.mangaDetail("mesmo-eu-tendo-decidido-jogar-com-voce");
    debugPrint("data: $data");
  });
}
