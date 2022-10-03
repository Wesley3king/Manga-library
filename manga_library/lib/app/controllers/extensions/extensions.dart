import 'package:manga_library/app/controllers/extensions/hen_season/extension_hen_season.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/extension_yabu.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/repositories/yabu_fetch_services.dart';
import 'package:manga_library/app/controllers/extensions/model_extension.dart';
import 'package:manga_library/app/controllers/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';
import 'package:manga_library/app/controllers/extensions/nhen/extension_nhen.dart';
import 'package:manga_library/app/controllers/extensions/nhen_br/extension_n_hen_br.dart';
import 'package:manga_library/app/controllers/extensions/union_mangas/extension_union_mangas.dart';
import 'package:manga_library/app/controllers/extensions/universo_hen/extension_universo_hen.dart';

final List<Extension> listOfExtensions = [
  ExtensionMangaYabu(),
  ExtensionMundoMangaKun(),
  ExtensionUnionMangas(),
  ExtensionNHen(),
  ExtensionUniversoHen(),
  ExtensionHenSeason(),
  ExtensionNHenBr()
];

final Map<int, Extension> mapOfExtensions = {
  1: ExtensionMangaYabu(),
  3: ExtensionMundoMangaKun(),
  4: ExtensionUnionMangas(),
  5: ExtensionNHen(),
  6: ExtensionUniversoHen(),
  7: ExtensionHenSeason(),
  8: ExtensionNHenBr()
};

final Map<int, dynamic> fetchServiceExtensions = {
  1: YabuFetchServices(),
};
