import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';

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
      getFirstPage(widget.controller),
      getSecondPage(context, widget.controller),
      getFiltersPage(context, widget.controller)
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
      backgroundColor: ConfigSystemController.instance.isDarkTheme
          ? const Color.fromARGB(255, 27, 27, 27)
          : Colors.white,
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
Widget getFirstPage(LeitorController controller) {
  ValueNotifier<int> notifier = ValueNotifier<int>(0);
  const double dropdownWidth = 180.0;
  return AnimatedBuilder(
    animation: notifier,
    builder: (context, child) => Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Text("Para este Capítulo"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tipo do leitor'),
              SizedBox(
                width: dropdownWidth,
                child: DropdownButton<String>(
                  alignment: Alignment.centerLeft,
                  value: controller.leitorTypeUi,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (value) {
                    controller.setReaderType(value as String);
                    notifier.value++;
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
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Rotação da tela'),
              SizedBox(
                width: dropdownWidth,
                child: DropdownButton<String>(
                  alignment: Alignment.centerLeft,
                  value: controller.orientacionUi,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (value) {
                    controller.setOrientacion(value as String);
                    notifier.value++;
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
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Layout'),
              SizedBox(
                width: dropdownWidth,
                child: DropdownButton<String>(
                  alignment: Alignment.centerLeft,
                  value: controller.layoutUi, // edit this
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (value) {
                    controller.setReaderLayout(value);
                    notifier.value++;
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "pattern",
                      child: Text('Padrão'),
                    ),
                    DropdownMenuItem(
                      value: "L",
                      child: Text('Em forma de L'),
                    ),
                    DropdownMenuItem(
                      value: "bordersLTR",
                      child: Text('Bordas LTR'),
                    ),
                    DropdownMenuItem(
                      value: "bordersRTL",
                      child: Text('Bordas RTL'),
                    ),
                    DropdownMenuItem(
                      value: "none",
                      child: Text('Nenhum'),
                    )
                  ],
                ),
              )
            ],
          ),
          controller.leitorType == LeitorTypes.webtoon
              ? getWebttonSettings(
                  controller: controller,
                  notifier: notifier,
                  dropdownWidth: dropdownWidth)
              : Container(),
        ],
      ),
    ),
  );
}

/// configurações de leitor webtoon
Widget getWebttonSettings(
        {required LeitorController controller,
        required ValueNotifier<int> notifier,
        required double dropdownWidth}) =>
    Column(
      children: [
        const SizedBox(height: 10,),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        const SizedBox(height: 5,),
        const Text('Webtoon'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Distancia da Rolagem'),
            SizedBox(
              width: dropdownWidth,
              child: DropdownButton<String>(
                alignment: Alignment.centerLeft,
                value: "${LeitorController.scrollWebtoonValue}",
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (value) {
                  controller.setScrollWebtoonValue(int.parse(value!));
                  notifier.value++;
                },
                items: const [
                  DropdownMenuItem(
                    value: "100",
                    child: Text('100'),
                  ),
                  DropdownMenuItem(
                    value: "200",
                    child: Text('200'),
                  ),
                  DropdownMenuItem(
                    value: "300",
                    child: Text('300'),
                  ),
                  DropdownMenuItem(
                    value: "400",
                    child: Text('400'),
                  ),
                  DropdownMenuItem(
                    value: "600",
                    child: Text('600'),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
Widget getSecondPage(BuildContext context, LeitorController controller) {
  ValueNotifier<int> notifier = ValueNotifier<int>(0);
  return AnimatedBuilder(
    animation: notifier,
    builder: (context, child) => Column(
      children: [
        // const Text("Para este Capítulo"),
        SwitchListTile(
          value: controller.wakeLock,
          title: const Text("Manter a tela ligada"),
          onChanged: (value) {
            // controller.wakeLock = value;
            // Wakelock.toggle(enable: controller.wakeLock);
            controller.setWakeLock(value);
            notifier.value++;
          },
        ),
        SwitchListTile(
          value: controller.isFullScreen ?? true,
          title: const Text("Tela cheia"),
          onChanged: (value) {
            controller.isFullScreen = value;
            notifier.value++;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 17.0),
              child: Text(
                "Cor de fundo",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: DropdownButton<String>(
                value: controller.backgroundColorUi,
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (value) {
                  controller.setBackgroundColor(value);
                  notifier.value++;
                },
                items: const [
                  DropdownMenuItem(
                    value: "pattern",
                    child: Text('Padrão'),
                  ),
                  DropdownMenuItem(
                    value: "black",
                    child: Text('Preto'),
                  ),
                  DropdownMenuItem(
                    value: "white",
                    child: Text('Branco'),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget getFiltersPage(BuildContext context, LeitorController controller) {
  // ValueNotifier<int> notifier = ValueNotifier<int>(0);
  return AnimatedBuilder(
    animation: ReaderNotifier.instance,
    builder: (context, child) => Column(
      children: [
        SwitchListTile(
          value: controller.isCustomShine,
          onChanged: (value) {
            controller.setShine(null, setShine: value);
          },
          title: const Text('Brilho personalizado'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 330,
              child: Slider(
                value: controller.shineValueUi,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  controller.setShine(value);
                },
              ),
            ),
            Flexible(
                child: Text(controller.shineValueUi
                    .toStringAsFixed(2)
                    .replaceFirst("0.", "")
                    .replaceFirst(".", ""))),
          ],
        ),
        const Divider(),
        SwitchListTile(
          value: controller.isCustomFilter,
          onChanged: (value) {
            controller.setCustomFilter(0, null, setFilter: value);
          },
          title: const Text('Filtro personalizado'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('R'),
            SizedBox(
              width: 330,
              child: Slider(
                value: controller.customFilterValues[0].toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) {
                  controller.setCustomFilter(value.toInt(), "R");
                },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('G'),
            SizedBox(
              width: 330,
              child: Slider(
                value: controller.customFilterValues[1].toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) {
                  controller.setCustomFilter(value.toInt(), "G");
                },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('B'),
            SizedBox(
              width: 330,
              child: Slider(
                value: controller.customFilterValues[2].toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) {
                  controller.setCustomFilter(value.toInt(), "B");
                },
              ),
            )
          ],
        ),
        const Divider(),
        SwitchListTile(
          value: controller.isblackAndWhiteFilter,
          onChanged: (value) {
            controller.setBlackAndWhiteFilter(value);
          },
          title: const Text('Filtro Preto e Branco'),
        )
      ],
    ),
  );
}
