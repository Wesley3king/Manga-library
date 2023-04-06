import 'package:manga_library/app/extensions/gekkou_scans/extesion_gekkou_scans.dart';
import 'package:manga_library/app/extensions/hen_season/extension_hen_season.dart';
import 'package:manga_library/app/extensions/hq_dragon/extension_hq_dragon.dart';
import 'package:manga_library/app/extensions/hq_now/extension_hq_now.dart';
import 'package:manga_library/app/extensions/manga_chan/extension_manga_chan.dart';
import 'package:manga_library/app/extensions/manga_yabu/extension_yabu.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/extensions/mundo_manga_kun/extension_mundo_manga_kun.dart';
import 'package:manga_library/app/extensions/mundo_webtoon/extension_mundo_webtoon.dart';
import 'package:manga_library/app/extensions/neox_scans/extension_neox_scans.dart';
import 'package:manga_library/app/extensions/nhen/extension_nhen.dart';
import 'package:manga_library/app/extensions/nhen_br/extension_n_hen_br.dart';
import 'package:manga_library/app/extensions/nhen_net/extension_nhen_net.dart';
import 'package:manga_library/app/extensions/prisma_scan/extension_prisma_scans.dart';
import 'package:manga_library/app/extensions/see_mangas/extension_see_mangas.dart';
import 'package:manga_library/app/extensions/silence_scan/extension_silence_scan.dart';
import 'package:manga_library/app/extensions/union_mangas/extension_union_mangas.dart';
import 'package:manga_library/app/extensions/universo_hen/extension_universo_hen.dart';
import 'package:manga_library/app/extensions/winter_scan/extension_winter_scan.dart';
import 'package:manga_library/app/extensions/yabutoon/extension_yabutoon.dart';

final List<Extension> listOfExtensions = [
  // ExtensionMangaYabu(),
  ExtensionMundoMangaKun(),
  ExtensionUnionMangas(),
  ExtensionNHen(),
  ExtensionUniversoHen(),
  ExtensionHenSeason(),
  ExtensionNHenBr(),
  ExtensionSilenceScan(),
  ExtensionMangaChan(),
  ExtensionGekkouScans(),
  ExtensionYabutoon(),
  ExtensionPrismaScan(),
  ExtensionSeeMangas(),
  ExtensionWinterScan(),
  ExtensionNeoxScans(),
  ExtensionHqNow(),
  ExtensionHqDragon(),
  // ExtensionNHenNet(),
  ExtensionMundoWebtoon()
];

final Map<int, Extension> mapOfExtensions = {
  1: ExtensionMangaYabu(),
  3: ExtensionMundoMangaKun(),
  4: ExtensionUnionMangas(),
  5: ExtensionNHen(),
  6: ExtensionUniversoHen(),
  7: ExtensionHenSeason(),
  8: ExtensionNHenBr(),
  9: ExtensionSilenceScan(),
  10: ExtensionMangaChan(),
  11: ExtensionGekkouScans(),
  12: ExtensionYabutoon(),
  13: ExtensionPrismaScan(),
  14: ExtensionNeoxScans(),
  15: ExtensionWinterScan(),
  16: ExtensionSeeMangas(),
  17: ExtensionHqNow(),
  18: ExtensionHqDragon(),
  19: ExtensionNHenNet(),
  20: ExtensionMundoWebtoon()
};
