import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/views/library/functions/library_functions.dart';
import 'package:manga_library/app/views/search/search_show_results_page/controllers/serach_show_results_page_controller.dart';

import '../../../controllers/system_navigation_and_app_bar_styles.dart';

class SearchShowResultsPage extends StatefulWidget {
  final int idExtension;
  const SearchShowResultsPage({super.key, required this.idExtension});

  @override
  State<SearchShowResultsPage> createState() => _SearchShowResultsPageState();
}

class _SearchShowResultsPageState extends State<SearchShowResultsPage> {
  final SearchShowResultsPageController controller =
      SearchShowResultsPageController();
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  final TextEditingController _textEditingController = TextEditingController(
      text: GlobalData.searchString == "" ? null : GlobalData.searchString);
  late List<double> sizeOfBooks;
  String textValue = GlobalData.searchString;

  /// leva até um manga
  void goToDetailRoute(String id, int idExtension) {
    GoRouter.of(context).push("/detail/$id/$idExtension");
  }

  /// mostra um imput para ir por ID
  dynamic handleId(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Inserir id"),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: TextField(
                  controller: nameController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: "Insira o id"),
                  onSubmitted: (value) =>
                      goToDetailRoute(nameController.text, widget.idExtension),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () =>
                      goToDetailRoute(nameController.text, widget.idExtension),
                  child: const Text("Ir")),
            ],
          )
        ],
      ),
    );
  }

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
                imageUrl: controller.model.books[index].img,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, size: 45,),
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
                    controller.model.books[index].name,
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
              onPressed: () => goToDetailRoute(controller.model.books[index].link,
                    controller.model.books[index].idExtension),
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
          itemCount: (controller.model.books.length + 2),
          itemBuilder: (context, index) {
            if (index < controller.model.books.length) {
              return createBook(context, index);
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _stateManagement(SearchShowResultsStates value) {
    switch (value) {
      case SearchShowResultsStates.start:
        return loading;
      case SearchShowResultsStates.loading:
        return loading;
      case SearchShowResultsStates.sucess:
        return buildPage();
      case SearchShowResultsStates.error:
        return error;
    }
  }

  @override
  void initState() {
    super.initState();
    ConfigSystemController.instance.isDarkTheme
        ? StylesFromSystemNavigation.setSystemNavigationBarBlack26()
        : StylesFromSystemNavigation.setSystemNavigationBarWhite24();
    sizeOfBooks = getSizeOfBooks();
    controller.start(GlobalData.searchString);
  }

  @override
  void dispose() {
    GlobalData.searchString = "";
    GlobalData.searchModelSelected = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InputDecoration? showHint = GlobalData.searchString == ""
        ? const InputDecoration(hintText: 'Pesquisar')
        : null;
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textEditingController,
            textAlign: TextAlign.center,
            maxLines: 1,
            decoration: showHint,
            scrollPadding: const EdgeInsets.all(5.0),
            style: const TextStyle(fontSize: 18),
            onSubmitted: (value) =>
                controller.search(textValue, widget.idExtension),
            onChanged: ((value) => textValue = value),
          ),
          actions: [
            IconButton(
                onPressed: () =>
                    controller.search(textValue, widget.idExtension),
                tooltip: 'pesquisar',
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () => handleId(context),
                tooltip: 'ir por id',
                icon: const Icon(Icons.manage_search))
          ],
        ),
        body: AnimatedBuilder(
          animation: controller.state,
          builder: (context, child) => _stateManagement(controller.state.value),
        ));
  }
}
