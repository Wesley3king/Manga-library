import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/leitor/components/bottom_sheet.dart';
import 'package:manga_library/app/views/leitor/config_components.dart';
// import 'package:flutter/services.dart';
import 'package:manga_library/app/views/leitor/pages_leitor.dart';

import '../../controllers/leitor_controller.dart';

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

class _LeitorState extends State<Leitor> with SingleTickerProviderStateMixin {
  late AnimationController bottomSheetController;
  final PagesController controller = PagesController();
  final LeitorController leitorController = LeitorController();
  final Color appBarAndBottomAppBarColor = const Color.fromARGB(204, 0, 0, 0);
  final double sizeOfButtons = 25.0;
  final int visibleDuration = 400;
  final Curve visibleCurve = Curves.easeInOut;
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
    // definir o fullScreen
    // isVisible
    //     ? screenController.enterEdgeFullScreen()
    //     : screenController.enterFullScreen();
    isVisible
        ? leitorController.setFullScreen(true)
        : leitorController.setFullScreen(false);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? true
            : false;
    return [
      AnimatedContainer(
        duration: Duration(milliseconds: visibleDuration),
        curve: visibleCurve,
        height: isVisible
            ? isLandscape
                ? 60
                : 100
            : 0,
        child: Container(
          color: appBarAndBottomAppBarColor,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark_border,
                  size: isVisible ? sizeOfButtons : 0,
                ),
              ),
              // const SizedBox(
              //   width: 10,
              // )
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: isLandscape ? 0 : 170),
        child: SizedBox(
          height: isLandscape ? 60 : 200,
          width: MediaQuery.of(context).size.width - (isLandscape ? 280 : 190),
          child: GestureDetector(
            onTap: () => setState(() {
              isVisible = !isVisible;
            }),
          ),
        ),
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: visibleDuration),
        curve: visibleCurve,
        height: isVisible
            ? isLandscape
                ? 1200
                : 160
            : 0,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 3.0,
                    ),
                    SizedBox(
                        width: 50,
                        height: 50,
                        child: Material(
                            color: const Color.fromARGB(179, 0, 0, 0),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 25,
                                )))),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 50,
                        child: AnimatedBuilder(
                            animation: controller.state,
                            builder: (context, child) => Material(
                                color: const Color.fromARGB(179, 0, 0, 0),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Slider(
                                  value: controller.state.value.toDouble(),
                                  max: leitorController.capitulosEmCarga.isEmpty
                                      ? 1.0
                                      : leitorController
                                              .capitulosEmCarga[0].download
                                          ? leitorController.capitulosEmCarga[0]
                                              .downloadPages.length
                                              .toDouble()
                                          : leitorController
                                              .capitulosEmCarga[0].pages.isEmpty ? 1.0 : leitorController
                                              .capitulosEmCarga[0].pages.length
                                              .toDouble(),
                                  min: 1.0,
                                  onChanged: (value) => controller.scrollTo(
                                      value.toInt(),
                                      leitorController.leitorTypeState.value),
                                ))),
                      ),
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    SizedBox(
                        width: 50,
                        height: 50,
                        child: Material(
                          color: const Color.fromARGB(179, 0, 0, 0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.skip_next,
                                size: 25,
                              )),
                        )),
                    const SizedBox(
                      width: 3.0,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: appBarAndBottomAppBarColor,
              width: MediaQuery.of(context).size.width,
              height: isLandscape ? 60 : 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  buildOrientacion(leitorController, setState),
                  Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () => customBottomSheetForLeitor(
                              context, bottomSheetController, leitorController
                            ),
                          icon: Icon(
                            Icons.settings,
                            size: sizeOfButtons,
                          ));
                    },
                  )
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
    bottomSheetController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    leitorController.setFullScreen(true);
    super.dispose();
  }

  // double getHeight(BuildContext context) {
  //   debugPrint("height get: ${MediaQuery.of(context).size.height}");
  //   return MediaQuery.of(context).size.height;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
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
                          "${controller.state.value}/${leitorController.capitulosEmCarga.isEmpty ? 0 : leitorController.capitulosEmCarga[0].download ? leitorController.capitulosEmCarga[0].downloadPages.length : leitorController.capitulosEmCarga[0].pages.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            shadows: [
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
      ),
    );
  }
}
