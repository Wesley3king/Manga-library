import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class MyWebView extends StatefulWidget {
  final String url;
  const MyWebView({super.key, required this.url});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  ValueNotifier<bool> showOptions = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewX(
            width: MediaQuery.of(context).size.width, 
            height: MediaQuery.of(context).size.height,
            // initialContent: ,
            // initialSourceType: SourceType.url,
          ),
        ],
      ),
    );
  }
}
