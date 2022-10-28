import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';

// import '../models/leitor_pages.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:webviewx/webviewx.dart';
import '../models/manga_info_offline_model.dart';

class LeitorController {
  final FullScreenController screenController = FullScreenController();
  List<Capitulos> capitulos = [];
  List<Capitulos> capitulosEmCarga = [];
  // ===== State =====
  ValueNotifier<LeitorStates> state =
      ValueNotifier<LeitorStates>(LeitorStates.start);
  // ===== Reader Type =====
  ValueNotifier<LeitorTypes> leitorTypeState =
      ValueNotifier<LeitorTypes>(LeitorTypes.ltr);
  // ===== Reader Type UI =====
  String leitorTypeUi = "pattern";
  // ===== Filter Quality =====
  ValueNotifier<LeitorFilterQuality> filterQualityState =
      ValueNotifier<LeitorFilterQuality>(LeitorFilterQuality.none);
  // ===== Filter Quality Ui ============
  String filterQualityUi = "pattern";
  // ===== Orientacion Ui =====
  String orientacionUi = "pattern";
  // ===== Background Color ======
  ValueNotifier<LeitorBackgroundColor> backgroundColorState =
      ValueNotifier<LeitorBackgroundColor>(LeitorBackgroundColor.black);

  void start(String link, String id, int idExtension) async {
    state.value = LeitorStates.loading;
    try {
      capitulos = GlobalData.capitulosDisponiveis;
      // configurar o leitor
      setFilterQuality("pattern");
      setOrientacion("pattern");
      setBackgroundColor();
      setReaderType("pattern");

      // buscar pelas paginas
      debugPrint("======= capitulos ==========");
      Capitulos cap =
          await mapOfExtensions[idExtension]!.getPages(id, capitulos);
      // debugPrint("$cap");
      capitulosEmCarga.add(cap);
      debugPrint("=========== em carga =============");
      debugPrint('$capitulosEmCarga');
      // try {
      //   setFilterQuality("pattern");
      // } catch (e) {
      //   debugPrint("erro 1: $e");
      // }
      // try {
      //   setOrientacion("pattern");
      // } catch (e) {
      //   debugPrint("erro 2: $e");
      // }
      // try {
      //   setReaderType("pattern");
      // } catch (e) {
      //   debugPrint("erro 3: $e");
      // }
      state.value = LeitorStates.sucess;
    } catch (e) {
      debugPrint('erro em start LeitorController');
      debugPrint('$e');
      state.value = LeitorStates.error;
    }
  }

  void setReaderType(String type) {
    // type ??= GlobalData.settings['Tipo do Leitor'];
    leitorTypeUi = type;
    if (type == "pattern") {
      type = GlobalData.settings['Tipo do Leitor'];
    }
    switch (type) {
      // case "pattern":
      //   leitorTypeState.value = LeitorTypes.pattern;
      //   break;
      case "vertical":
        leitorTypeState.value = LeitorTypes.vertical;
        break;
      case "ltr":
        leitorTypeState.value = LeitorTypes.ltr;
        break;
      case "rtl":
        leitorTypeState.value = LeitorTypes.rtl;
        break;
      case "ltrlist":
        leitorTypeState.value = LeitorTypes.ltrlist;
        break;
      case "rtllist":
        leitorTypeState.value = LeitorTypes.rtllist;
        break;
      case "webtoon":
        leitorTypeState.value = LeitorTypes.webtoon;
        break;
      case "webview":
        leitorTypeState.value = LeitorTypes.webview;
        break;
    }
  }

  void setFilterQuality(String type) {
    // type ??= GlobalData.settings['Qualidade'];
    filterQualityUi = type;
    if (type == "pattern") {
      type = GlobalData.settings['Qualidade'];
    }
    switch (type) {
      case "none":
        filterQualityState.value = LeitorFilterQuality.none;
        break;
      case "low":
        filterQualityState.value = LeitorFilterQuality.low;
        break;
      case "medium":
        filterQualityState.value = LeitorFilterQuality.medium;
        break;
      case "hight":
        filterQualityState.value = LeitorFilterQuality.hight;
        break;
    }
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
    type ??= GlobalData.settings['Cor de fundo'];
    switch (type) {
      case "black":
        backgroundColorState.value = LeitorBackgroundColor.black;
        break;
      case "white":
        backgroundColorState.value = LeitorBackgroundColor.white;
        break;
    }
  }

  setFullScreen(bool isFullScreen, {bool? keepFullScreen}) {
    keepFullScreen ??= GlobalData.settings['Tela cheia'];

    if (keepFullScreen!) {
      if (isFullScreen) {
        screenController.exitEdgeFullScreen();
      } else {
        screenController.enterFullScreen();
      }
    } else {
      screenController.exitEdgeFullScreenToReader();
    }
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
