import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/union_mangas/extension_union_mangas.dart';

void main() {
  final ExtensionUnionMangas extend = ExtensionUnionMangas();

  test("deve retornar uma lista de destaques", () async {
    var data = await extend.homePage();
    // print(data);
  });
  test("deve retornar um ModelMangaInfoOffLine", () async {
    var data = await extend.mangaDetail('tales-of-demons-and-gods');
    // print(data);
  });
}
