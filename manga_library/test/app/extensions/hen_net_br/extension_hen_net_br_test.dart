import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/hen_net_br/extension_hen_net_br.dart';

void main() {
  ExtensionHenNetBr extend = ExtensionHenNetBr();
  
  test("deve retornar List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint("img: ${data[0].books[0].img}");
  });

  test("deve retornar um model MangaInfoOffLineModel", () async {
    var data = await extend.mangaDetail("hirotta-sute-elf-tachi-ni-dekiai-sarete-shikareru-made-no-hanashi");
    debugPrint("name: ${data!.name}");
    debugPrint("page: ${data.capitulos[0].pages}");
  });

  test("deve retornar um model SearchModel", () async {
    var data = await extend.search("hospital");
    debugPrint("name: ${data[0].img}");
  });
}
