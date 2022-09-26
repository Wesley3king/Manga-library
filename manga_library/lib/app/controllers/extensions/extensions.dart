import 'package:manga_library/app/controllers/extensions/manga_yabu/extension_yabu.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/repositories/yabu_fetch_services.dart';

final List<dynamic> homePageExtensions = [
  ExtensionMangaYabu(),
];

final Map<int, dynamic> mangaDetailExtensions = {
  1: ExtensionMangaYabu(),
};

final Map<int, dynamic> fetchServiceExtensions = {
  1: YabuFetchServices(),
};
