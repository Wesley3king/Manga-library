import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewx/webviewx.dart';

class MyWebviewx extends StatefulWidget {
  final List<String> pages;
  const MyWebviewx({super.key, required this.pages});

  @override
  State<MyWebviewx> createState() => _MyWebviewxState();
}

class _MyWebviewxState extends State<MyWebviewx> {
  bool showThis = false;
  late WebViewXController webviewController;
  String buildPages(BuildContext context) {
    StringBuffer buffer = StringBuffer();
    for (String str in widget.pages) {
      buffer.write(
          '<img src="$str" width="${MediaQuery.of(context).size.width}px" alt="page of manga" />');
    }
    return '<head><style>::-webkit-scrollbar{display: none;}</style></head><body style="margin: 0px;padding:0px;">${buffer.toString()}</body>';
  }

  List<Widget> buildInfo(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height - 120;
    return [
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: showThis ? 60 : 0,
        child: Container(
          color: Colors.black54,
          width: MediaQuery.of(context).size.width,
          height: showThis ? 60 : 0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 170),
        child: GestureDetector(
          onTap: () => setState(() {
            showThis = !showThis;
          }),
          onDoubleTap: () => webviewController.callJsMethod("scroll", []),
          child: Container(
            //color: Colors.black54,
            decoration: const BoxDecoration(
              color: Colors.black54,
            ),
            height: 200,
            width: MediaQuery.of(context).size.width - 190,
          ),
        ),
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: showThis ? 60 : 0,
        child: Wrap(
          children: [
            Container(
              color: Colors.black54,
              width: MediaQuery.of(context).size.width,
              height: 60,
            )
          ],
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Future.delayed(
    //     const Duration(seconds: 2),
    //     () => webviewController.loadContent( // 'https://flutter.dev'
    //       "https://wesley3king.github.io/mangaKa/maked/",
    //           SourceType.url,
    //         ));
  }

  @override
  void dispose() {
    super.dispose();
    webviewController.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewX(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          initialContent: buildPages(context), // buildPages(context)
          initialSourceType: SourceType.html, // SourceType.html
          onWebViewCreated: (controller) => webviewController = controller,
          jsContent: const {
            EmbeddedJsContent(
                js: "function scroll() { window.scrollTo(500); }"),
            EmbeddedJsContent(
              webJs:
                  'window.document.addEventListener("click", ()=> PrintNaTelaGG("i m king"));',
              mobileJs:
                  'window.document.addEventListener("click", ()=> PrintNaTelaGG("i m king"));',
            ),
          },
          dartCallBacks: {
            DartCallback(
              name: "PrintNaTelaGG",
              callBack: (message) => log("menssagem: $message"),
            )
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildInfo(context),
          ),
        )
      ],
    );
  }
}
