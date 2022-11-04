import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/extensions/extensions.dart';
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
  void dispose() {
    webViewController.clearCache();
    super.dispose();
  }

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: showOptions.value ? 120 : 0,
                        child: Container(
                          height: 120,
                          color: Colors.black45,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () => GoRouter.of(context).pop(),
                                  icon: const Icon(Icons.arrow_back)),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 180,
                                  child: Text(
                                    url,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white),
                                  )),
                              IconButton(
                                onPressed: () => webViewController.goBack(),
                                icon: const Icon(Icons.arrow_back_ios)
                              ),
                              IconButton(
                                onPressed: () => webViewController.goForward(),
                                icon: const Icon(Icons.arrow_forward_ios)
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: showOptions.value ? 5 : 75),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: GestureDetector(
                            onTap: () => showOptions.value = !showOptions.value,
                          ),
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
