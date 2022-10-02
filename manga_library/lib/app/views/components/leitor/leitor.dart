import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/views/components/leitor/config_components.dart';
// import 'package:flutter/services.dart';
import 'package:manga_library/app/views/components/leitor/pages_leitor.dart';

import '../../../controllers/leitor_controller.dart';

class Leitor extends StatefulWidget {
  final String link;
  final String id;
  final int idExtension;
  const Leitor(
      {super.key,
      required this.link,
      required this.id,
      required this.idExtension});

  @override
  State<Leitor> createState() => _LeitorState();
}

class _LeitorState extends State<Leitor> {
  final FullScreenController screenController = FullScreenController();
  final PagesController controller = PagesController();
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

  // =========================================================================
  //                    ---- CONTROLS ----
  // =========================================================================
  List<Widget> buildInfo(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height - 120;
    return [
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isVisible ? 100 : 0,
        child: Container(
          color: Colors.black54,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  icon: Icon(Icons.arrow_back,
                      size: isVisible ? sizeOfButtons : 0)),
              Text(
                "Capítulo ${leitorController.capitulosEmCarga.isEmpty ? "..." : leitorController.capitulosEmCarga[0].capitulo}",
                style: const TextStyle(fontSize: 20),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border,
                    size: isVisible ? sizeOfButtons : 0,
                  )),
              // const SizedBox(
              //   width: 10,
              // )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 170),
        child: GestureDetector(
          onTap: () => setState(() {
            isVisible = !isVisible;
          }),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            height: 200,
            width: MediaQuery.of(context).size.width - 190,
          ),
        ),
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isVisible ? 100 : 0,
        child: Wrap(
          children: [
            Container(
              color: Colors.black54,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedBuilder(
                    animation: leitorController.leitorTypeState,
                    builder: (context, child) =>
                        buildSetLeitorType(leitorController),
                  ),
                  AnimatedBuilder(
                    animation: leitorController.filterQualityState,
                    builder: (context, child) =>
                        buildFilterQuality(leitorController),
                  ),
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
            )
          ],
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    leitorController.start(widget.link, widget.id, widget.idExtension);
    screenController.enterFullScreen();
  }

  @override
  void dispose() {
    super.dispose();
    screenController.exitFullScreen();
  }

  double getHeight(BuildContext context) {
    debugPrint("height get: ${MediaQuery.of(context).size.height}");
    return MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: getHeight(context),
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: PagesLeitor(
                  showOrHideInfo: removeOrAddInfo,
                  leitorController: leitorController,
                  controller: controller,
                  link: widget.link,
                  id: widget.id,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buildInfo(context),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: AnimatedContainer(
                padding: isVisible
                    ? const EdgeInsets.only(bottom: 100)
                    : const EdgeInsets.only(bottom: 0),
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedBuilder(
                      animation: controller.state,
                      builder: (context, child) => Text(
                        "${controller.state.value}/${leitorController.capitulosEmCarga.isEmpty ? 0 : leitorController.capitulosEmCarga[0].pages.length}",
                        style: const TextStyle(shadows: [
                          Shadow(color: Colors.black45, offset: Offset(1, 1))
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
