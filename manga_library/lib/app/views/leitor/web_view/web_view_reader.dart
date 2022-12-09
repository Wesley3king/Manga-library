// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
// import 'package:flutter/services.dart';
import 'package:webviewx/webviewx.dart';

class MyWebviewx extends StatefulWidget {
  final List<String> pages;
  final PagesController controller;
  final LeitorController leitorController;
  final Color color;
  const MyWebviewx(
      {super.key,
      required this.pages,
      required this.color,
      required this.leitorController,
      required this.controller});

  @override
  State<MyWebviewx> createState() => _MyWebviewxState();
}

class _MyWebviewxState extends State<MyWebviewx> {
  // bool showThis = false;
  late WebViewXController webviewController;
  String getColor() {
    switch (widget.leitorController.backgroundColor) {
      case LeitorBackgroundColor.black:
        return "black";
      case LeitorBackgroundColor.white:
        return "white";
      case LeitorBackgroundColor.grey:
        return "grey";
      case LeitorBackgroundColor.blue:
        return "rgba(191, 207, 219)";
      case LeitorBackgroundColor.green:
        return "rgba(193, 221, 193)";
      case LeitorBackgroundColor.pink:
        return "rgba(233, 189, 185)";
    }
  }

  String buildPages(BuildContext context) {
    // StringBuffer buffer = StringBuffer();
    // for (String str in widget.pages) {
    //   buffer.write(
    //       '<img src="$str" width="${MediaQuery.of(context).size.width}px" alt="page of manga" />');
    // }
    // return '<head><style>::-webkit-scrollbar{display: none;}body{margin: 0px;padding:0px;background-color:${getColor()}}div{height: 34px}img{margin-top: -4px;}</style></head><body><div></div>${buffer.toString()}</body>';
    StringBuffer buffer = StringBuffer();
    for (String str in widget.pages) {
      buffer.write('"$str",');
    }
    return '''
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>teste de html</title>
    <style>
        body{
          padding: 0;
          margin: 0;
          background-color:${getColor()};
        }
        ::-webkit-scrollbar{
            display: none;
        }
        #initial_space{
          height: 34px;
        }
        img{
          margin-top: -4px;
        }
    </style>
</head>
<body>
    <div id="initial_space"></div>
    <div id="images">
        
    </div>
    
    <script>
        var local = window.document.querySelector("div#images");
        var index = 0;
        var lista = [$buffer];

        /// scroll to
        function scrollToIndex(indice) {
          try{
            var image = window.document.querySelector(`#img`+ indice);
            image.scrollIntoView();
          } catch (e) {
            console.log('erro '+e);
          }
        }

        async function renderCore(src) {
            const img = new Image();
            img.setAttribute("id", `img`+ index);
            img.setAttribute("onclick", `testPlatformSpecificMethod(`+index+`)`);
            img.onload = function() {
              img.setAttribute("width", window.innerWidth + `px`);
              
              local.appendChild(img);
              index++;
              machineRender();
            }
            img.src = src;
        };

        function machineRender() {
          if (index < lista.length) {
              renderCore(lista[index]);
          }
        }

        machineRender();
    </script>
</body>''';
  }

  void setCurrentIndex(String index) {
    widget.controller.setPage = int.parse(index) + 1;
  }

  @override
  void dispose() {
    super.dispose();
    // webviewController.clearCache();
    webviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewX(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      initialContent: buildPages(context),
      initialSourceType: SourceType.html,
      onWebViewCreated: (controller) {
        webviewController = controller;
        widget.controller.setWebViewController = webviewController;
      },
      jsContent: const {
        EmbeddedJsContent(
          webJs:
              "function testPlatformSpecificMethod(indice) {TestDartCallback(indice) }",
          mobileJs:
              "function testPlatformSpecificMethod(indice) { TestDartCallback.postMessage(indice) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (indice) => setCurrentIndex(indice.toString()),
        ),
      },
    );
  }
}
