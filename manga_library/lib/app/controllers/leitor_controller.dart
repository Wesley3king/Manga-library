import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';

// import '../models/leitor_pages.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:manga_library/app/models/reader_chapter_model.dart';
import 'package:manga_library/app/views/configurations/config_pages/functions/config_functions.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webviewx/webviewx.dart';
import '../models/manga_info_offline_model.dart';

class LeitorController {
  final ScreenBrightness screenBrightness = ScreenBrightness();
  final FullScreenController screenController = FullScreenController();
  List<Capitulos> capitulos = [];
  Capitulos atualChapter = Capitulos(
      id: "",
      capitulo: "",
      description: "",
      download: false,
      readed: false,
      disponivel: false,
      downloadPages: [],
      pages: []);
  ReaderChapter atualInfo = ReaderChapter(index: 0, id: '');

  // ===== State =====
  ValueNotifier<LeitorStates> state =
      ValueNotifier<LeitorStates>(LeitorStates.start);
  // ===== Reader Type =====
  LeitorTypes leitorType = LeitorTypes.ltr;
  // ===== Reader Type UI =====
  String leitorTypeUi = "pattern";
  // ===== Filter Quality =====
  LeitorFilterQuality filterQuality = LeitorFilterQuality.none;
  // ===== Filter Quality Ui ============
  String filterQualityUi = "pattern";
  // ===== Orientacion Ui =====
  String orientacionUi = "pattern";
  // ===== Background Color ======
  LeitorBackgroundColor backgroundColor = LeitorBackgroundColor.black;
  // ===== Background Color Ui ======
  String backgroundColorUi = "pattern";
  // =========== WAKE LOCK ===================
  bool wakeLock = false;
  // ========= FULL SCREEN =======================
  bool? isFullScreen;
  // ===== CUSTOM SHINE =======
  bool isCustomShine = GlobalData.settings['Custom Shine'];
  // ======= SHINE VALUE ===========
  double shineValueUi = GlobalData.settings['Custom Shine Value'];
  // ======= CUSTOM FILTER ==========
  bool isCustomFilter = GlobalData.settings['Custom Filter'];
  // ======= CUSTOM FLITER VALUES ========
  List<int> customFilterValues = [
    GlobalData.settings['R'],
    GlobalData.settings['G'],
    GlobalData.settings['B']
  ];
  // ======= Black AND WHITE FILTER ==========
  bool isblackAndWhiteFilter = GlobalData.settings['Black and White filter'];

  void start(String link, String id, int idExtension) async {
    state.value = LeitorStates.loading;
    try {
      capitulos = GlobalData.mangaModel.capitulos;
      // configurar o leitor
      setFilterQuality("pattern");
      setOrientacion("pattern");
      setBackgroundColor();
      setReaderType("pattern");
      setWakeLock(null);
      if (isCustomShine) {
        setShine(shineValueUi);
      }

      // buscar pelas paginas
      debugPrint("======= capitulos ==========");
      Capitulos cap =
          await mapOfExtensions[idExtension]!.getPages(id, capitulos);
      // debugPrint("$cap");
      atualChapter = cap;
      atualInfo =
          getReaderModel(id, capitulos) ?? ReaderChapter(index: 0, id: id);
      debugPrint("=========== em carga =============");

      state.value = LeitorStates.sucess;
    } catch (e) {
      debugPrint('erro em start LeitorController');
      debugPrint('$e');
      state.value = LeitorStates.error;
    }
  }

  static ReaderChapter? getReaderModel(
      String id, List<Capitulos> listChapters) {
    for (int i = 0; i < listChapters.length; ++i) {
      if (listChapters[i].id == id) {
        return ReaderChapter(
            index: i,
            id: id,
            prevId:
                listChapters.length == (i + 1) ? null : listChapters[i + 1].id,
            nextId: i == 0 ? null : listChapters[i - 1].id);
      }
    }
    return null;
  }

  void prevChapter(String link, int idExtension) {
    start(link, atualInfo.prevId!, idExtension);
  }

  void nextChapter(String link, int idExtension) {
    start(link, atualInfo.nextId!, idExtension);
  }

  void setReaderType(String type) {
    leitorTypeUi = type;
    if (type == "pattern") {
      type = GlobalData.settings['Tipo do Leitor'];
    }
    switch (type) {
      // case "pattern":
      //   leitorTypeState.value = LeitorTypes.pattern;
      //   break;
      case "vertical":
        leitorType = LeitorTypes.vertical;
        break;
      case "ltr":
        leitorType = LeitorTypes.ltr;
        break;
      case "rtl":
        leitorType = LeitorTypes.rtl;
        break;
      case "ltrlist":
        leitorType = LeitorTypes.ltrlist;
        break;
      case "rtllist":
        leitorType = LeitorTypes.rtllist;
        break;
      case "webtoon":
        leitorType = LeitorTypes.webtoon;
        break;
      case "webview":
        leitorType = LeitorTypes.webview;
        break;
    }
    ReaderNotifier.instance.notify();
  }

  void setFilterQuality(String type) {
    // type ??= GlobalData.settings['Qualidade'];
    filterQualityUi = type;
    if (type == "pattern") {
      type = GlobalData.settings['Qualidade'];
    }
    switch (type) {
      case "none":
        filterQuality = LeitorFilterQuality.none;
        break;
      case "low":
        filterQuality = LeitorFilterQuality.low;
        break;
      case "medium":
        filterQuality = LeitorFilterQuality.medium;
        break;
      case "hight":
        filterQuality = LeitorFilterQuality.hight;
        break;
    }
    ReaderNotifier.instance.notify();
  }

  void setOrientacion(String type) {
    // type ??= GlobalData.settings['Orientação do Leitor'];
    orientacionUi = type;
    if (type == "pattern") {
      type = GlobalData.settings['Orientação do Leitor'];
      // debugPrint(" =================== chegou aqui: $type");
      ConfigSystemController.instance.setSystemOrientacion(type);
    } else {
      ConfigSystemController.instance.setSystemOrientacion(type);
    }
  }

  void setBackgroundColor([String? type]) {
    type == null ? backgroundColorUi = "pattern" : backgroundColorUi = type;
    if (type == null || type == "pattern") {
      type = GlobalData.settings['Cor de fundo'];
    }
    switch (type) {
      case "black":
        backgroundColor = LeitorBackgroundColor.black;
        break;
      case "white":
        backgroundColor = LeitorBackgroundColor.white;
        break;
    }
    ReaderNotifier.instance.notify();
  }

  void setFullScreen(bool isFullScreenTemporally) {
    isFullScreen ??= GlobalData.settings['Tela cheia'];

    if (isFullScreen!) {
      if (isFullScreenTemporally) {
        screenController.exitEdgeFullScreen();
      } else {
        screenController.enterFullScreen();
      }
      isFullScreen = true;
    } else {
      screenController.exitEdgeFullScreenToReader();
      isFullScreen = false;
    }
    // debugPrint("full screen: $isFullScreen");
  }

  void setWakeLock(bool? value) {
    value ??= GlobalData.settings['Manter a tela ligada'];
    wakeLock = value!;
    Wakelock.toggle(enable: value);
  }

  void setShine(double? value, {bool? setShine}) async {
    /// set shine
    if (setShine != null && setShine) {
      await settingsFunctions['Custom Shine']!(true, null);
      isCustomShine = true;
      value = shineValueUi;
    } else if (setShine != null && !setShine) {
      await settingsFunctions['Custom Shine']!(false, null);
      isCustomShine = false;
      value = null;
    }
    if (value == null) {
      screenBrightness.resetScreenBrightness();
    } else if (isCustomShine) {
      shineValueUi = value;
      screenBrightness.setScreenBrightness(shineValueUi);
      await settingsFunctions['Custom Shine Value']!(shineValueUi);
    }
    ReaderNotifier.instance.notify();
  }

  void setCustomFilter(int value, String? type, {bool? setFilter}) async {
    if (setFilter != null && setFilter) {
      await settingsFunctions['Custom Filter']!(true, null);
      isCustomFilter = true;
    } else if (setFilter != null && !setFilter) {
      await settingsFunctions['Custom Filter']!(false, null);
      isCustomFilter = false;
    }

    if (type != null) {
      switch (type) {
        case "R":
          customFilterValues[0] = value;
          break;
        case "G":
          customFilterValues[1] = value;
          break;
        case "B":
          customFilterValues[2] = value;
          break;
      }
      await settingsFunctions['Custom Filter Values']!(value, type);
    }
    ReaderNotifier.instance.notify();
  }
}

class ReaderNotifier extends ChangeNotifier {
  static final ReaderNotifier instance = ReaderNotifier();

  void notify() {
    notifyListeners();
  }
}

enum LeitorStates { start, loading, sucess, error }

enum LeitorTypes { vertical, ltr, rtl, ltrlist, rtllist, webtoon, webview }

enum LeitorUiTypes {
  pattern,
  vertical,
  ltr,
  rtl,
  ltrlist,
  rtllist,
  webtoon,
  webview
}

enum LeitorFilterQuality { none, low, medium, hight }

enum LeitorUiFilterQuality { pattern, none, low, medium, hight }

enum LeitorBackgroundColor { black, white }

// enum LeitorUiOrientacion {
//   pattern,
//   auto,
//   portraitUp,
//   portraitDown,
//   landscapeLeft,
//   landscapeRight
// }

class PagesController {
  // int maxPages = 1;
  ValueNotifier<int> state = ValueNotifier<int>(1);
  PageController pageController = PageController();
  ItemScrollController scrollControllerList = ItemScrollController();
  WebViewXController? webViewController;

  // start() {
  //   state.value++;
  //   print('iniciou!');
  // }
  set setPage(int max) {
    debugPrint('$max');
    state.value = max;
  }

  // recebe o controller do webViewX
  set setWebViewController(WebViewXController webViewXController) {
    webViewController = webViewXController;
  }

  void scrollTo(int index, LeitorTypes type) {
    setPage = index;
    index--;
    switch (type) {
      case LeitorTypes.vertical:
        pageController.jumpToPage(index);
        break;
      case LeitorTypes.ltr:
        pageController.jumpToPage(index);
        break;
      case LeitorTypes.rtl:
        pageController.jumpToPage(index);
        break;
      case LeitorTypes.ltrlist:
        pageController.jumpToPage(index);
        break;
      case LeitorTypes.rtllist:
        pageController.jumpToPage(index);
        break;
      case LeitorTypes.webtoon:
        scrollControllerList.jumpTo(index: index);
        break;
      case LeitorTypes.webview:
        webViewController?.callJsMethod('scrollToIndex', [index]);
        break;
    }
  }

  // startNextPage() {
  //   if (state.value < maxPages) {
  //     state.value++;
  //   }
  //   print('state = ${state.value}');
  //   print('max = $maxPages');

  // }
}
