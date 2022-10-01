import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/views/components/leitor/config_components.dart';
// import 'package:flutter/services.dart';
import 'package:manga_library/app/views/components/leitor/pages_leitor.dart';

import '../../../controllers/leitor_controller.dart';

class Leitor extends StatefulWidget {
  final String link;
  final String id;
  final int idExtension;
  const Leitor({super.key, required this.link, required this.id, required this.idExtension});

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
        height: isVisible ? 60 : 0,
        child: Container(
          color: Colors.black54,
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Capítulo ${leitorController.capitulosEmCarga.isEmpty ? "..." : leitorController.capitulosEmCarga[0].capitulo}"),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark_border,
                  size: sizeOfButtons,
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
            //color: Colors.black54,
            decoration: const BoxDecoration(
              color: Colors.black54,
            ),
            height: 200,
            width: MediaQuery.of(context).size.width - 190,
          ),
        ),
      ),
      AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) => Text(
          "${controller.state.value}/$leitorController.capitulosEmCarga.isEmpty ? 0 : widget.leitorController.capitulosEmCarga[0].pages.length}",
          style: const TextStyle(shadows: [
            Shadow(color: Colors.black45, offset: Offset(1, 1))
          ]),
        ),
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isVisible ? 60 : 0,
        child: Wrap(
          children: [
            Container(
              color: Colors.black54,
              width: MediaQuery.of(context).size.width,
              height: 60,
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
                      )
                    ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        size: sizeOfButtons,
                      )
                    ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBody: true,
        // extendBodyBehindAppBar: true,
        // appBar: isVisible
        //     ? AppBar(
        //         title: Text(
        //             "Capítulo ${leitorController.capitulosEmCarga.isEmpty ? "..." : leitorController.capitulosEmCarga[0].capitulo}"),
        //         backgroundColor: appBarAndBottomAppBarColor,
        //         actions: [
        //           IconButton(
        //               onPressed: () {},
        //               icon: Icon(
        //                 Icons.bookmark_border,
        //                 size: sizeOfButtons,
        //               )),
        //           const SizedBox(
        //             width: 10,
        //           )
        //         ],
        //         elevation: 0,
        //       )
        //     : PreferredSize(preferredSize: Size.zero, child: Container()),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  PagesLeitor(
                    showOrHideInfo: removeOrAddInfo,
                    leitorController: leitorController,
                    controller: controller,
                    link: widget.link,
                    id: widget.id,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: buildInfo(context),
                    ),
                  )
                ],
              )
            ),
          ),
        ),
        // bottomNavigationBar: ScrollHideWidget(
        //     clickVisible: isVisible,
        //     child: BottomAppBar(
        //       color: Colors.transparent,
        //       child: IconTheme(
        //         data: const IconThemeData(color: Colors.white),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             AnimatedBuilder(
        //               animation: leitorController.leitorTypeState,
        //               builder: (context, child) =>
        //                   buildSetLeitorType(leitorController),
        //             ),
        //             AnimatedBuilder(
        //               animation: leitorController.filterQualityState,
        //               builder: (context, child) =>
        //                   buildFilterQuality(leitorController),
        //             ),
        //             IconButton(
        //                 onPressed: () {},
        //                 icon: Icon(
        //                   Icons.screen_rotation,
        //                   size: sizeOfButtons,
        //                 )),
        //             IconButton(
        //                 onPressed: () {},
        //                 icon: Icon(
        //                   Icons.settings,
        //                   size: sizeOfButtons,
        //                 )),
        //           ],
        //         ),
        //       ),
        //    )
        //)
      );
  }
}

// class ScrollHideWidget extends StatefulWidget {
//   final Widget child;
//   final Duration duration;
//   final bool clickVisible;

//   const ScrollHideWidget({
//     super.key,
//     required this.clickVisible,
//     this.duration = const Duration(milliseconds: 200),
//     required this.child,
//   });

//   @override
//   _ScrollHideWidgetState createState() => _ScrollHideWidgetState();
// }

// class _ScrollHideWidgetState extends State<ScrollHideWidget> {
//   final Color appBarAndBottomAppBarColor = const Color.fromARGB(146, 0, 0, 0);

//   double hideOrShowOnTap(bool value) {
//     if (value) {
//       return 54.0;
//     } else {
//       return 0.0;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: widget.duration,
//       height: hideOrShowOnTap(widget.clickVisible),
//       child: Container(
//           color: appBarAndBottomAppBarColor,
//           child: Wrap(children: [widget.child])),
//     );
//   }
// }
