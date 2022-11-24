// import 'leitor_pages.dart';
import 'package:manga_library/app/models/search_model.dart';
import 'package:manga_library/app/models/settings_model.dart';
import 'package:manga_library/app/models/system_settings.dart';

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
  static String pieceOfLink = "";

  static bool showAdiminAtualizationBanner = false;

  static SettingsModel settingsApp = SettingsModel(models: []);

  static SystemSettingsModel settings = SystemSettingsModel(
      ordination: "oldtonew",
      frameSize: "normal",
      update: "0",
      updateTheCovers: true,
      hiddenLibraryPassword: '0000',
      theme: "auto",
      interfaceColor: "blue",
      language: "ptbr",
      rollTheBar: true,
      readerType: "vertical",
      backgroundColor: "black",
      readerGuidance: "auto",
      quality: "medium",
      fullScreen: true,
      keepScreenOn: false,
      showControls: false,
      customShine: false,
      customShineValue: 0.5,
      customFilter: false,
      R: 0,
      G: 0,
      B: 0,
      blackAndWhiteFilter: false,
      layout: "bordersLTR",
      showLayout: true,
      scrollWebtoon: 400,
      storageLocation: "intern",
      authentication: false,
      authenticationType: "text",
      authenticationPassword: "",
      multipleSearches: false,
      nSFWContent: false,
      showNSFWInList: true,
      clearCache: false,
      restore: false);

  /// ======== SEARCH ============
  static SearchModel? searchModelSelected;
  static String searchString= '';
}
