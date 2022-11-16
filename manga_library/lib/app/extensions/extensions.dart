import 'package:manga_library/app/extensions/hen_season/extension_hen_season.dart';
import 'package:manga_library/app/extensions/manga_chan/extension_manga_chan.dart';
import 'package:manga_library/app/extensions/manga_yabu/extension_yabu.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';
import 'package:manga_library/app/extensions/nhen/extension_nhen.dart';
import 'package:manga_library/app/extensions/nhen_br/extension_n_hen_br.dart';
import 'package:manga_library/app/extensions/silence_scan/extension_silence_scan.dart';
import 'package:manga_library/app/extensions/universo_hen/extension_universo_hen.dart';

final List<Extension> listOfExtensions = [
  ExtensionMangaYabu(),
  ExtensionMundoMangaKun(),
  // ExtensionUnionMangas(),
  ExtensionNHen(),
  ExtensionUniversoHen(),
  ExtensionHenSeason(),
  ExtensionNHenBr(),
  ExtensionSilenceScan(),
  ExtensionMangaChan()
];

final Map<int, Extension> mapOfExtensions = {
  1: ExtensionMangaYabu(),
  3: ExtensionMundoMangaKun(),
  // 4: ExtensionUnionMangas(),
  5: ExtensionNHen(),
  6: ExtensionUniversoHen(),
  7: ExtensionHenSeason(),
  8: ExtensionNHenBr(),
  9: ExtensionSilenceScan(),
  10: ExtensionMangaChan()
};

// final Map<int, dynamic> fetchServiceExtensions = {
//   1: YabuFetchServices(),
// };
