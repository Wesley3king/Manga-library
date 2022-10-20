import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:webviewx/webviewx.dart';

class MyWebView extends StatefulWidget {
  final String url;
  final int idExtension;
  const MyWebView({super.key, required this.url, required this.idExtension});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  ValueNotifier<bool> showOptions = ValueNotifier<bool>(true);
  FullScreenController screenController = FullScreenController();
  late WebViewXController webViewController;

  @override
  Widget build(BuildContext context) {
    String url = mapOfExtensions[widget.idExtension]!.getLink(widget.url);
    return Scaffold(
      body: Stack(
        children: [
          WebViewX(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            onWebViewCreated: (controller) => webViewController = controller,
            initialContent: url,
            initialSourceType: SourceType.url,
          ),
          AnimatedBuilder(
              animation: showOptions,
              builder: (context, child) {
                /// para manter ou sair do full screen
                if (showOptions.value) {
                  screenController.enterEdgeFullScreen();
                } else {
                  screenController.enterFullScreen();
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: showOptions.value ? 70 : 0,
                        child: Container(
                          height: 70,
                          color: Colors.black26,
                        ),
                      )
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
