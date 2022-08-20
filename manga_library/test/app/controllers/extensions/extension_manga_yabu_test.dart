import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';

void main() {
  test('aqui deve retornar uma lista de maps com os dados necessarios',
      () async {
    ExtensionMangaYabu extension_manga = ExtensionMangaYabu();
    var result = await extension_manga.homePage();

    print(result[result.length-1]);
    expect(result is List, true);
  });
}
