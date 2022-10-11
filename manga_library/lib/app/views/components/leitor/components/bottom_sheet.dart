import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';

customBottomSheetForLeitor(
    BuildContext context, AnimationController animationController) {
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
          child: const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: SizedBox(
              height: 485,
              child: CustomReaderConfigurations(),
            ),
          )));
}

class CustomReaderConfigurations extends StatefulWidget {
  const CustomReaderConfigurations({super.key});

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
      const Center(
        child: Text("Leitor"),
      ),
      const Center(
        child: Text("Geral"),
      ),
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

Widget buildCustomControllerPages() {
  return Container();
}
