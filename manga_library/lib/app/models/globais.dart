// import 'leitor_pages.dart';
import 'package:manga_library/app/models/settings_model.dart';

import 'manga_info_offline_model.dart';

class GlobalData {
  static MangaInfoOffLineModel mangaModel = MangaInfoOffLineModel(
      name: "",
      authors: "",
      state: "",
      description: "",
      img: "",
      link: "",
      idExtension: 0,
      genres: [],
      alternativeName: false,
      chapters: 0,
      capitulos: []);

  static bool showAdiminAtualizationBanner = false;

  static SettingsModel settingsApp = SettingsModel(models: []);

  static Map settings = {};
}
