import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/nhen_net/extension_nhen_net.dart';

void main() {
  ExtensionNHenNet extend = ExtensionNHenNet();
  test("deve retornar List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint("img: ${data[0].books[0].img}");
    debugPrint("img: ${data[0].books[0].url}");
    /// https://t7.nhentai.net/galleries/2405704/thumb.jpg
    /// data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7
  });

  test("deve retornar um model MangaInfoOffLineModel", () async {
    var data = await extend.mangaDetail("421001"); // 432301
    debugPrint("name: ${data!.name}");
    debugPrint("page: ${data.capitulos[0].pages}");
  });

  test("deve retornar um model SearchModel", () async {
    var data = await extend.search("brandish");
    debugPrint("name: ${data[0].img}");
    // debugPrint("page: ${data.capitulos[0].pages}");
  });

  test("deve fazer dois testes, para o funcionamento do sistema de token", () async {
    var data = await extend.homePage();
    var dados = await extend.search("brandish");
    debugPrint("name: ${dados[0].img}");
    /// https://t7.nhentai.net/galleries/2405704/thumb.jpg
    /// data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7
  });
}
