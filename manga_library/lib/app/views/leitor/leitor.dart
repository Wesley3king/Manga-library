import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/system_navigation_and_app_bar_styles.dart';
import 'package:manga_library/app/views/leitor/components/bottom_sheet.dart';
import 'package:manga_library/app/views/leitor/components/layouts/layout_border.dart';
import 'package:manga_library/app/views/leitor/components/layouts/layout_l.dart';
import 'package:manga_library/app/views/leitor/config_components.dart';
// import 'package:flutter/services.dart';
import 'package:manga_library/app/views/leitor/pages_leitor.dart';

import '../../controllers/leitor_controller.dart';
import '../../controllers/system_config.dart';
import '../../models/globais.dart';

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
  ValueNotifier<bool> isVisible =
      ValueNotifier<bool>(GlobalData.settings.showControls);

  // =========================================================================
  //                    ---- CONTROLS ----
  // =========================================================================
  List<Widget> buildInfo(BuildContext context) {
    isVisible.value
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
        height: isVisible.value ? 100 : 0,
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
                      size: isVisible.value ? sizeOfButtons : 0)),
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      GlobalData.mangaModel.name.trim(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "Capítulo ${leitorController.atualChapter.id == '' ? "..." : leitorController.atualChapter.capitulo}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => leitorController.markOrRemoveMarkFromChapter(),
                icon: AnimatedBuilder(
                  animation: leitorController.isMarked,
                  builder: (context, child) {
                    if (leitorController.isMarked.value) {
                      return Icon(
                        Icons.bookmark,
                        color: Colors.amber,
                        size: isVisible.value ? sizeOfButtons : 0,
                      );
                    } else {
                      return Icon(
                        Icons.bookmark_border,
                        size: isVisible.value ? sizeOfButtons : 0,
                      );
                    }
                  },
                ),
              ),
              // const SizedBox(
              //   width: 10,
              // )
            ],
          ),
        ),
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: visibleDuration),
        curve: visibleCurve,
        height: isVisible.value
            ? isLandscape
                ? 126
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
                                onPressed: () => leitorController.prevChapter(
                                    widget.link, widget.idExtension),
                                tooltip: "Capítulo Anterior",
                                icon: Icon(
                                  Icons.skip_previous,
                                  color:
                                      leitorController.atualInfo.prevId == null
                                          ? Colors.grey
                                          : null,
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
                                  max: leitorController.atualChapter.id == ""
                                      ? 1.0
                                      : leitorController.atualChapter.download
                                          ? leitorController
                                              .atualChapter.downloadPages.length
                                              .toDouble()
                                          : leitorController
                                                  .atualChapter.pages.isEmpty
                                              ? 1.0
                                              : leitorController
                                                  .atualChapter.pages.length
                                                  .toDouble(),
                                  min: 1.0,
                                  onChanged: (value) => controller.scrollTo(
                                      value.toInt(),
                                      leitorController.leitorType),
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
                              disabledColor: Colors.red,
                              highlightColor: Colors.green,
                              tooltip: "Próximo Capítulo",
                              onPressed: () => leitorController.nextChapter(
                                  widget.link, widget.idExtension),
                              icon: Icon(
                                Icons.skip_next,
                                color: leitorController.atualInfo.nextId == null
                                    ? Colors.grey
                                    : null,
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
                    animation: ReaderNotifier.instance,
                    builder: (context, child) =>
                        buildSetLeitorType(leitorController),
                  ),
                  AnimatedBuilder(
                    animation: ReaderNotifier.instance,
                    builder: (context, child) =>
                        buildFilterQuality(leitorController),
                  ),
                  buildOrientacion(leitorController, setState),
                  Builder(
                    builder: (context) {
                      return IconButton(
                          tooltip: "Configurações",
                          onPressed: () => customBottomSheetForLeitor(
                              context, bottomSheetController, leitorController),
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

  /// obtem o Layout a ser utilizado
  Widget getLayout() {
    switch (leitorController.layoutState.value) {
      case ReaderLayouts.l:
        return LayoutL(
            notifier: isVisible,
            controller: controller,
            leitorType: leitorController.leitorType);
      case ReaderLayouts.bordersLTR:
        return LayoutBorder(
            notifier: isVisible,
            controller: controller,
            leitorType: leitorController.leitorType);
      case ReaderLayouts.bordersRTL:
        return LayoutBorder(
            notifier: isVisible,
            controller: controller,
            leitorType: leitorController.leitorType);
      case ReaderLayouts.none:
        return SizedBox(
          child: GestureDetector(
            onTap: () => isVisible.value = !isVisible.value,
          ),
        );
    }
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
    leitorController.setOrientacion("auto");
    // Wakelock.toggle(enable: false);
    leitorController.setWakeLock(false);
    _customNavigationBar();
    super.dispose();
  }

  void _customNavigationBar() {
    ConfigSystemController.instance.isDarkTheme
        ? StylesFromSystemNavigation.setSystemNavigationBarBlack26()
        : StylesFromSystemNavigation.setSystemNavigationBarWhite24();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBuilder(
      animation: leitorController.state,
      builder: (context, child) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Stack(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: PagesLeitor(
                    leitorController: leitorController,
                    controller: controller,
                    link: widget.link,
                    id: widget.id,
                  )),
              ValueListenableBuilder(
                valueListenable: leitorController.layoutState,
                builder: (context, value, child) => getLayout(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: isVisible,
                  builder: (context, child) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: buildInfo(context)),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: AnimatedContainer(
                  padding: isVisible.value
                      ? const EdgeInsets.only(bottom: 100)
                      : const EdgeInsets.only(bottom: 0),
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedBuilder(
                        animation: controller.state,
                        builder: (context, child) => Text(
                          "${controller.state.value}/${leitorController.atualChapter.id == '' ? 0 : leitorController.atualChapter.download ? leitorController.atualChapter.downloadPages.length : leitorController.atualChapter.pages.length}",
                          style: const TextStyle(color: Colors.white, shadows: [
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
    ));
  }
}
