import 'package:manga_library/app/controllers/extensions/manga_yabu/extension_yabu.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/repositories/yabu_fetch_services.dart';
import 'package:manga_library/app/controllers/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';

final List<dynamic> listOfExtensions = [
  ExtensionMangaYabu(),
  ExtensionMundoMangaKun(),
];

final Map<int, dynamic> mapOfExtensions = {
  1: ExtensionMangaYabu(),
  3: ExtensionMundoMangaKun(),
};

final Map<int, dynamic> fetchServiceExtensions = {
  1: YabuFetchServices(),
};
