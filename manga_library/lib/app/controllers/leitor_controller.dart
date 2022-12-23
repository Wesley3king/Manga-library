import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/controllers/historic_manager_controller.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';

// import '../models/leitor_pages.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/models/historic_model.dart';
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
  final ChaptersController controller = ChaptersController();
  final ManagerHistoricController historicController =
      ManagerHistoricController();
  List<Capitulos> capitulos = [];
  Capitulos atualChapter = Capitulos(
      id: "",
      capitulo: "",
      description: "",
      download: false,
      readed: false,
      mark: false,
      downloadPages: [],
      pages: []);
  ValueNotifier<bool> isMarked = ValueNotifier<bool>(false);
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
  bool isCustomShine = GlobalData.settings.customShine;
  // ======= SHINE VALUE ===========
  double shineValueUi = GlobalData.settings.customShineValue;
  // ======= CUSTOM FILTER ==========
  bool isCustomFilter = GlobalData.settings.customFilter;
  // ======= CUSTOM FLITER VALUES ========
  List<int> customFilterValues = [
    GlobalData.settings.R,
    GlobalData.settings.G,
    GlobalData.settings.B
  ];
  // ======= Black AND WHITE FILTER ==========
  bool isblackAndWhiteFilter = GlobalData.settings.blackAndWhiteFilter;
  // =========== LAYOUT ===============
  final ValueNotifier<ReaderLayouts> layoutState =
      ValueNotifier<ReaderLayouts>(ReaderLayouts.bordersLTR);
  // ======== LAYOUT UI ===========
  String layoutUi = "pattern";
  // ========== SCROLL WEBTOON ===========
  static int scrollWebtoonValue = 400;

  void start(String link, String id, int idExtension,
      {bool? isFirstTime}) async {
    state.value = LeitorStates.loading;
    try {
      capitulos = GlobalData.mangaModel.capitulos;
      // configurar o leitor
      if (isFirstTime != null && isFirstTime == true) {
        setReaderLayout("pattern");
        setFilterQuality("pattern");
        setOrientacion("pattern");
        setBackgroundColor();
        setReaderType("pattern");
        setWakeLock(null);
        if (isCustomShine) {
          setShine(shineValueUi);
        }
      }
      // processar informações
      atualInfo = getReaderModel(id, capitulos) ?? ReaderChapter(index: 0, id: id);
      // buscar pelas paginas
      debugPrint("======= capitulos ==========");
      Capitulos cap =
          await mapOfExtensions[idExtension]!.getPages(id, capitulos);
      // debugPrint("$cap");
      atualChapter = cap;

      /// veificar se é uma novel
      if ((cap.pages.isNotEmpty && cap.pages[0].contains("== NOVEL READER ==")) || (cap.downloadPages.isNotEmpty && cap.downloadPages[0].contains("== NOVEL READER =="))) {
        setReaderType("novel");
      }
      isMarked.value = cap.mark;
      // marcar o capitulo como lido
      if (atualInfo.id ==
              ChaptersController.capitulosCorrelacionados[atualInfo.index].id &&
          !ChaptersController
              .capitulosCorrelacionados[atualInfo.index].readed) {
        markOrRemoveMark(id, link, atualChapter.capitulo);
      }

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

  /// marca os capitulos como lido ou remove-o da lista de lidos (caso já esteja lido)
  Future<void> markOrRemoveMark(String id, String link, String chapter) async {
    Map<String, String> nameImageLink = {
      "name": GlobalData.mangaModel.name,
      "img": GlobalData.mangaModel.img,
      "link": GlobalData.pieceOfLink
    };
    await controller.marcarDesmarcar(
        id, link, nameImageLink, GlobalData.mangaModel.idExtension);
    await historicController.insertOnHistoric(HistoricModel(
        name: nameImageLink['name']!,
        img: nameImageLink['img']!,
        link: nameImageLink['link']!,
        idExtension: GlobalData.mangaModel.idExtension,
        chapter: chapter,
        date: ""));
    // controller.updateChapters(
    //     capitulos, nameImageLink["link"]!, GlobalData.mangaModel.idExtension);
  }

  /// adiciona ou remove(caso esteja adicionado) as marcas de favorito no capítulo
  Future<void> markOrRemoveMarkFromChapter() async {
    bool response = await controller.markOrRemoveMarkFromChapter(
        GlobalData.mangaModel.link,
        GlobalData.mangaModel.idExtension,
        atualChapter.id);
    if (response) {
      atualChapter.mark = !atualChapter.mark;

      for (Capitulos chapter in GlobalData.mangaModel.capitulos) {
        if (chapter.id == atualChapter.id) {
          chapter.mark = atualChapter.mark;
          break;
        }
      }
      isMarked.value = atualChapter.mark;
    }
  }

  void prevChapter(String link, int idExtension) {
    if (atualInfo.prevId != null) {
      start(link, atualInfo.prevId!, idExtension);
    }
  }

  void nextChapter(String link, int idExtension) {
    if (atualInfo.nextId != null) {
      start(link, atualInfo.nextId!, idExtension);
    }
  }

  void setReaderType(String type) {
    leitorTypeUi = type;
    if (type == "pattern") {
      type = GlobalData.settings.readerType;
    }
    switch (type) {
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
      case "novel":
        leitorType = LeitorTypes.novel;
        break;
    }
    ReaderNotifier.instance.notify();
  }

  void setFilterQuality(String type) {
    // type ??= GlobalData.settings['Qualidade'];
    filterQualityUi = type;
    if (type == "pattern") {
      type = GlobalData.settings.quality;
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
      type = GlobalData.settings.readerGuidance;
      // debugPrint(" =================== chegou aqui: $type");
      ConfigSystemController.instance.setSystemOrientacion(type);
    } else {
      ConfigSystemController.instance.setSystemOrientacion(type);
    }
  }

  void setBackgroundColor([String? type]) {
    type == null ? backgroundColorUi = "pattern" : backgroundColorUi = type;
    if (type == null || type == "pattern") {
      type = GlobalData.settings.backgroundColor;
    }
    switch (type) {
      case "black":
        backgroundColor = LeitorBackgroundColor.black;
        break;
      case "white":
        backgroundColor = LeitorBackgroundColor.white;
        break;
      case "grey":
        backgroundColor = LeitorBackgroundColor.grey;
        break;
      case "blue":
        backgroundColor = LeitorBackgroundColor.blue;
        break;
      case "green":
        backgroundColor = LeitorBackgroundColor.green;
        break;
      case "pink":
        backgroundColor = LeitorBackgroundColor.pink;
        break;
    }
    ReaderNotifier.instance.notify();
  }

  void setFullScreen(bool isFullScreenTemporally) {
    isFullScreen ??= GlobalData.settings.fullScreen;

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
    value ??= GlobalData.settings.keepScreenOn;
    wakeLock = value;
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

  void setBlackAndWhiteFilter(bool value) async {
    if (!isCustomFilter) {
      isblackAndWhiteFilter = value;
      await settingsFunctions['Black and White filter']!(value, null);
    }
    ReaderNotifier.instance.notify();
  }

  void setReaderLayout(String? type) {
    if (type == "pattern") {
      layoutUi = "pattern";
      type = GlobalData.settings.layout;
    } else {
      type ??= GlobalData.settings.layout;
      layoutUi = type;
    }

    switch (type) {
      case "L":
        layoutState.value = ReaderLayouts.l;
        break;
      case "bordersLTR":
        layoutState.value = ReaderLayouts.bordersLTR;
        break;
      case "bordersRTL":
        layoutState.value = ReaderLayouts.bordersRTL;
        break;
      case "none":
        layoutState.value = ReaderLayouts.none;
        break;
    }
  }

  void setScrollWebtoonValue(int? value) {
    /// 0 is default value
    if (value == 0) {
      value = GlobalData.settings.scrollWebtoon;
    }
    value ??= GlobalData.settings.scrollWebtoon;
    scrollWebtoonValue = value;
  }
}

class ReaderNotifier extends ChangeNotifier {
  static final ReaderNotifier instance = ReaderNotifier();

  void notify() {
    notifyListeners();
  }
}

enum LeitorStates { start, loading, sucess, error }

enum LeitorTypes {
  vertical,
  ltr,
  rtl,
  ltrlist,
  rtllist,
  webtoon,
  webview,
  novel
}

// enum LeitorUiTypes {
//   pattern,
//   vertical,
//   ltr,
//   rtl,
//   ltrlist,
//   rtllist,
//   webtoon,
//   webview,
//   novel
// }

enum LeitorFilterQuality { none, low, medium, hight }

enum LeitorUiFilterQuality { pattern, none, low, medium, hight }

enum LeitorBackgroundColor { black, white, grey, blue, green, pink }

enum ReaderLayouts { l, bordersRTL, bordersLTR, none }

class PagesController {
  // int maxPages = 1;
  ValueNotifier<int> state = ValueNotifier<int>(1);
  // controllers de pagina
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  ItemScrollController scrollControllerList = ItemScrollController();
  WebViewXController? webViewController;

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
      case LeitorTypes.novel:
        scrollControllerList.jumpTo(index: index);
        break;
    }
  }

  /// obtem o valor computacional [ incluindo o zero ]
  int get readerIndex => state.value - 1;

  void scrollToPosition(LeitorTypes type, ReaderPageAction action) {
    const Duration duration = Duration(milliseconds: 100);
    const Curve curve = Curves.linear;

    int index =
        action == ReaderPageAction.next ? (readerIndex + 1) : (readerIndex - 1);
    switch (type) {
      case LeitorTypes.vertical:
        pageController.animateToPage(index, duration: duration, curve: curve);
        break;
      case LeitorTypes.ltr:
        pageController.animateToPage(index, duration: duration, curve: curve);
        break;
      case LeitorTypes.rtl:
        pageController.animateToPage(index, duration: duration, curve: curve);
        break;
      case LeitorTypes.ltrlist:
        pageController.animateToPage(index, duration: duration, curve: curve);
        break;
      case LeitorTypes.rtllist:
        pageController.animateToPage(index, duration: duration, curve: curve);
        break;
      case LeitorTypes.webtoon:
        double position = action == ReaderPageAction.next
            ? (scrollController.offset + LeitorController.scrollWebtoonValue)
            : (scrollController.offset - LeitorController.scrollWebtoonValue);
        scrollController.animateTo(position, duration: duration, curve: curve);
        break;
      case LeitorTypes.webview:
        // implement this
        // webViewController?.callJsMethod('scrollSome', [LeitorController.scrollWebtoonValue, action == ReaderPageAction.next]);
        break;
      case LeitorTypes.novel:
        double position = action == ReaderPageAction.next
            ? (scrollController.offset + LeitorController.scrollWebtoonValue)
            : (scrollController.offset - LeitorController.scrollWebtoonValue);
        scrollController.animateTo(position, duration: duration, curve: curve);
        break;
    }
  }
}

enum ReaderPageAction { next, prev }
