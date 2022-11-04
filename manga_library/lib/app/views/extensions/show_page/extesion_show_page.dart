import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/controllers/system_navigation_and_app_bar_styles.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/views/extensions/show_page/controllers/extension_show_page_controller.dart';
import 'package:manga_library/app/views/library/functions/library_functions.dart';

class ExtensionShowPage extends StatefulWidget {
  final int idExtension;
  const ExtensionShowPage({super.key, required this.idExtension});

  @override
  State<ExtensionShowPage> createState() => _ExtensionShowPageState();
}

class _ExtensionShowPageState extends State<ExtensionShowPage> {
  final ExtensionShowPageController controller = ExtensionShowPageController();
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  late List<double> sizeOfBooks;

  /// loading
  Widget get loading => Center(
        child: CircularProgressIndicator(
          color: configSystemController.colorManagement(),
        ),
      );

  /// error widget
  Widget get error => Center(
        child: Column(
          children: const <Widget>[Icon(Icons.report_problem), Text("Erro!")],
        ),
      );

  /// cria um livro
  Widget createBook(BuildContext context, int index) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color.fromARGB(204, 0, 0, 0),
            offset: Offset(1.0, 1.0),
            blurRadius: 2.0)
      ]),
      width: 300,
      height: 350,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Stack(
          children: [
            SizedBox(
              width: 300,
              height: 350,
              child: CachedNetworkImage(
                imageUrl: controller.data[index].img,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.report_problem),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    bottom: 15.0,
                    left: 6.0,
                  ),
                  child: Text(
                    controller.data[index].name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              offset: Offset(1.5, 1.5),
                              blurRadius: 1.5)
                        ]),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // print('clickado!');
                //List<String> corteUrl1 = widget.data.books[index].link.split('manga/');
                GoRouter.of(context).push(
                    '/detail/${controller.data[index].url}/${controller.data[index].idExtension}');
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0))),
              child: const SizedBox(
                height: 350,
                width: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GridView.builder(
          addAutomaticKeepAlives: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: sizeOfBooks[0],
            mainAxisExtent: sizeOfBooks[1], // aqui ajustamos o height
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: (controller.data.length + 2),
          itemBuilder: (context, index) {
            if (index < controller.data.length) {
              return createBook(context, index);
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _stateManagement(ShowPageStates value) {
    switch (value) {
      case ShowPageStates.start:
        return loading;
      case ShowPageStates.loading:
        return loading;
      case ShowPageStates.sucess:
        return buildPage();
      case ShowPageStates.error:
        return error;
    }
  }

  @override
  void initState() {
    super.initState();
    ConfigSystemController.instance.isDarkTheme ? 
    StylesFromSystemNavigation.setSystemNavigationBarBlack26() :
    StylesFromSystemNavigation.setSystemNavigationBarWhite24();
    sizeOfBooks = getSizeOfBooks();
    controller.start(widget.idExtension);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mapOfExtensions[widget.idExtension]!.nome),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) => _stateManagement(controller.state.value),
      ),
    );
  }
}
