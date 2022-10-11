// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
// import 'package:flutter/services.dart';
import 'package:webviewx/webviewx.dart';

class MyWebviewx extends StatefulWidget {
  final List<String> pages;
  final PagesController controller;
  final Color color;
  const MyWebviewx({super.key, required this.pages, required this.color, required this.controller});

  @override
  State<MyWebviewx> createState() => _MyWebviewxState();
}

class _MyWebviewxState extends State<MyWebviewx> {
  // bool showThis = false;
  late WebViewXController webviewController;
  String getColor() {
    if (widget.color == Colors.black) {
      return "black";
    } else {
      return "white";
    }
  }

  String buildPages(BuildContext context) {
    StringBuffer buffer = StringBuffer();
    for (String str in widget.pages) {
      buffer.write(
          '<img src="$str" width="${MediaQuery.of(context).size.width}px" alt="page of manga" />');
    }
    return '<head><style>::-webkit-scrollbar{display: none;}body{margin: 0px;padding:0px;background-color:${getColor()}}div{height: 34px}img{margin-top: -4px;}</style></head><body><div></div>${buffer.toString()}</body>';
    //  style=""
  }

  // List<Widget> buildInfo(BuildContext context) {
  //   // final double height = MediaQuery.of(context).size.height - 120;
  //   return [
  //     AnimatedContainer(
  //       duration: const Duration(milliseconds: 200),
  //       height: showThis ? 60 : 0,
  //       child: Container(
  //         color: Colors.black54,
  //         width: MediaQuery.of(context).size.width,
  //         height: showThis ? 60 : 0,
  //       ),
  //     ),
  //     Padding(
  //       padding: const EdgeInsets.only(bottom: 170),
  //       child: GestureDetector(
  //         onTap: () => setState(() {
  //           showThis = !showThis;
  //         }),
  //         //onDoubleTap: () => webviewController.callJsMethod("scroll", []),
  //         child: Container(
  //           //color: Colors.black54,
  //           decoration: const BoxDecoration(
  //             color: Colors.black54,
  //           ),
  //           height: 200,
  //           width: MediaQuery.of(context).size.width - 190,
  //         ),
  //       ),
  //     ),
  //     AnimatedContainer(
  //       duration: const Duration(milliseconds: 200),
  //       height: showThis ? 60 : 0,
  //       child: Wrap(
  //         children: [
  //           Container(
  //             color: Colors.black54,
  //             width: MediaQuery.of(context).size.width,
  //             height: 60,
  //           )
  //         ],
  //       ),
  //     ),
  //   ];
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //   // Future.delayed(
  //   //     const Duration(seconds: 2),
  //   //     () => webviewController.loadContent( // 'https://flutter.dev'
  //   //       "https://wesley3king.github.io/mangaKa/maked/",
  //   //           SourceType.url,
  //   //         ));
  // }

  // void turnOffWebView() async {
  //  await webviewController.clearCache();
  //   webviewController.dispose();
  // }

  @override
  void dispose() {
    super.dispose();
    // turnOffWebView();
    webviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewX(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      initialContent: buildPages(context),
      initialSourceType: SourceType.html,
      onWebViewCreated: (controller) => webviewController = controller,
      // jsContent: const {
      //   EmbeddedJsContent(
      //       js: "function scroll() { window.scrollTo(500); }"),
      //   EmbeddedJsContent(
      //     webJs:
      //         'window.document.addEventListener("click", ()=> PrintNaTelaGG("i m king"));',
      //     mobileJs:
      //         'window.document.addEventListener("click", ()=> PrintNaTelaGG("i m king"));',
      //   ),
      // },
      // dartCallBacks: {
      //   DartCallback(
      //     name: "PrintNaTelaGG",
      //     callBack: (message) => log("menssagem: $message"),
      //   )
      // },
    );
  }
}
