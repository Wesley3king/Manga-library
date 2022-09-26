import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/scraping/scraping_yabu.dart';

void main() {
  // ExtensionMangaYabu extensionManga = ExtensionMangaYabu();
  test('aqui deve retornar uma lista de maps com os dados necessarios',
      () async {
    var result = await scrapingHomePage();
    print(result);
    // expect(result is List, true);
  });
}
