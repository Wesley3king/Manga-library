import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';

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
}
