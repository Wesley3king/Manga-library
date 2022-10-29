import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:wakelock/wakelock.dart';

customBottomSheetForLeitor(BuildContext context,
    AnimationController animationController, LeitorController controller) {
  // AnimationController animationController = AnimationController(vsync: vsync)
  const double radiusBottomSheet = 16.0;
  // const double radiusContent = 40.0;
  return showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusBottomSheet),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: 500,
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radiusBottomSheet),
                  topRight: Radius.circular(radiusBottomSheet))),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SizedBox(
              height: 485,
              child: CustomReaderConfigurations(
                controller: controller,
              ),
            ),
          )));
}

class CustomReaderConfigurations extends StatefulWidget {
  final LeitorController controller;
  const CustomReaderConfigurations({super.key, required this.controller});

  @override
  State<CustomReaderConfigurations> createState() =>
      _CustomReaderConfigurationsState();
}

class _CustomReaderConfigurationsState extends State<CustomReaderConfigurations>
    with SingleTickerProviderStateMixin {
  ConfigSystemController configSystemController = ConfigSystemController();
  late TabController controller;
  List<Widget> _getPages() {
    List<Widget> pages = [
      getFirstPage(widget.controller, setState),
      getSecondPage(context),
      const Center(
        child: Text("Filtros"),
      )
    ];

    return pages;
  }

  List<Tab> _getTabs() {
    const double heightForTabs = 35.0;
    List<Tab> tabs = const [
      Tab(
        text: "Leitor",
        height: heightForTabs,
      ),
      Tab(
        text: "Geral",
        height: heightForTabs,
      ),
      Tab(
        text: "Filtros",
        height: heightForTabs,
      ),
    ];

    return tabs;
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      // body: Center(child: Text("Scaffold"),),
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.black,
                    expandedHeight: 0,
                    pinned: true,
                    toolbarHeight: 0,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(38),
                      child: TabBar(
                        controller: controller,
                        labelPadding: const EdgeInsets.all(0),
                        indicatorColor:
                            configSystemController.colorManagement(),
                        tabs: _getTabs(),
                      ),
                    ),
                  ),
                )
              ],
          body: TabBarView(
            controller: controller,
            children: _getPages(),
          )),
    );
  }
}

// ============================================================================
//    -------------------- Pages controller --------------------------------
// ============================================================================

///final List<Map<String, String>> options = [
//   {"option": "Padrão", "value": "pattern"},
//   {"option": "Vertical", "value": "vertical"},
//   {"option": "Esquerda para Direita", "value": "ltr"},
//   {"option": "Direita para esquerda", "value": "rtl"},
//   {"option": "Lista ltr", "value": "ltrlist"},
//   {"option": "Lista rtl", "value": "rtllist"},
//   {"option": "Webtoon", "value": "webtoon"},
//   {"option": "Webview (on-line)", "value": "webview"}
// ];
Widget getFirstPage(LeitorController controller, Function setState) {
  ValueNotifier<String> notifier = ValueNotifier<String>("pattern");
  return AnimatedBuilder(
    animation: notifier,
    builder: (context, child) => Column(
      children: [
        const Text("Para este Capítulo"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Tipo do leitor'),
            DropdownButton<String>(
              value: controller.leitorTypeUi,
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) {
                controller.setReaderType(value as String);
                notifier.value = value;
              },
              items: const [
                DropdownMenuItem(
                  value: "pattern",
                  child: Text('Padrão'),
                ),
                DropdownMenuItem(
                  value: "vertical",
                  child: Text('Vertical'),
                ),
                DropdownMenuItem(
                  value: "ltr",
                  child: Text('Esquerda para Direita'),
                ),
                DropdownMenuItem(
                  value: "rtl",
                  child: Text('Direita para esquerda'),
                ),
                DropdownMenuItem(
                  value: "ltrlist",
                  child: Text('Lista ltr'),
                ),
                DropdownMenuItem(
                  value: "rtllist",
                  child: Text('Lista rtl'),
                ),
                DropdownMenuItem(
                  value: "webtoon",
                  child: Text('Webtoon'),
                ),
                DropdownMenuItem(
                  value: "webview",
                  child: Text('Webview (on-line)'),
                ),
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Rotação da tela'),
            DropdownButton<String>(
              value: controller.orientacionUi,
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) {
                controller.setOrientacion(value as String);
                notifier.value = value;
              },
              items: const [
                DropdownMenuItem(
                  value: "pattern",
                  child: Text('Padrão'),
                ),
                DropdownMenuItem(
                  value: "auto",
                  child: Text('Seguir o Sistema'),
                ),
                DropdownMenuItem(
                  value: "portraitup",
                  child: Text('Retrato'),
                ),
                DropdownMenuItem(
                  value: "portraitdown",
                  child: Text('Retrato Invertido'),
                ),
                DropdownMenuItem(
                  value: "landscapeleft",
                  child: Text('Paisagem Esquerda'),
                ),
                DropdownMenuItem(
                  value: "landscaperight",
                  child: Text('Paisagem Direita'),
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}

Widget getSecondPage(BuildContext context) {
  ValueNotifier<int> notifier = ValueNotifier<int>(0);
  bool wakeLock = false;
  return AnimatedBuilder(
    animation: notifier,
    builder: (context, child) => Column(
      children: [
        // const Text("Para este Capítulo"),
        SwitchListTile(
          value: wakeLock,
          title: const Text("Manter a tela ligada"),
          onChanged: (value) {
            wakeLock = value;
            Wakelock.toggle(enable: wakeLock);
            notifier.value++;
          },
        ),
      ],
    ),
  );
}
