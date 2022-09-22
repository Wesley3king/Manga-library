import 'package:flutter/material.dart';
import 'package:manga_library/app/views/components/leitor/config_components.dart';
// import 'package:flutter/services.dart';
import 'package:manga_library/app/views/components/leitor/pages_leitor.dart';

import '../controllers/leitor_controller.dart';

class Leitor extends StatefulWidget {
  final String link;
  final String id;
  const Leitor({super.key, required this.link, required this.id});

  @override
  State<Leitor> createState() => _LeitorState();
}

class _LeitorState extends State<Leitor> {
  final LeitorController leitorController = LeitorController();
  final Color appBarAndBottomAppBarColor = const Color.fromARGB(146, 0, 0, 0);
  final double sizeOfButtons = 25.0;
  bool isVisible = true;

  // colocar e remover o appbar e bottomNavigation
  void removeOrAddInfo() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  // icons
  Map<String, Widget> readerType = {
    "vertical": const Icon(Icons.system_security_update_outlined),
    "ltr": const Icon(Icons.send_to_mobile),
    "rtl": const Icon(Icons.smartphone),
    "ltrlist": const Icon(Icons.install_mobile_rounded),
    "rtllist": const Icon(Icons.no_cell_outlined),
    "webtoon": const Icon(Icons.system_security_update),
  };

  @override
  void initState() {
    super.initState();
    leitorController.start(widget.link, widget.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: isVisible
            ? AppBar(
                title: Text("Capítulo ${leitorController.capitulosEmCarga.isEmpty ? "..." : leitorController.capitulosEmCarga[0].capitulo}"),
                backgroundColor: appBarAndBottomAppBarColor,
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.bookmark_border,
                        size: sizeOfButtons,
                      )),
                  const SizedBox(
                    width: 10,
                  )
                ],
                elevation: 0,
              )
            : PreferredSize(preferredSize: Size.zero, child: Container()),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PagesLeitor(
                showOrHideInfo: removeOrAddInfo,
                leitorController: leitorController,
                link: widget.link,
                id: widget.id,
              ),
            ),
          ),
        ),
        bottomNavigationBar: ScrollHideWidget(
            clickVisible: isVisible,
            child: BottomAppBar(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedBuilder(
                    animation: leitorController.leitorTypeState,
                    builder: (context, child) => buildSetLeitorType(leitorController),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_alt,
                        size: sizeOfButtons,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.screen_rotation,
                        size: sizeOfButtons,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        size: sizeOfButtons,
                      )),
                ],
              ),
            )));
  }
}

class ScrollHideWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool clickVisible;

  const ScrollHideWidget({
    super.key,
    required this.clickVisible,
    this.duration = const Duration(milliseconds: 200),
    required this.child,
  });

  @override
  _ScrollHideWidgetState createState() => _ScrollHideWidgetState();
}

class _ScrollHideWidgetState extends State<ScrollHideWidget> {
  final Color appBarAndBottomAppBarColor = const Color.fromARGB(146, 0, 0, 0);

  double hideOrShowOnTap(bool value) {
    if (value) {
      return 54.0;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: hideOrShowOnTap(widget.clickVisible),
      child: Container(
          color: appBarAndBottomAppBarColor,
          child: Wrap(children: [widget.child])),
    );
  }
}
