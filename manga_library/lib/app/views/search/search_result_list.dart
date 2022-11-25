import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/views/routes/routes.dart';

import '../../controllers/search_controller.dart';
import '../../models/search_model.dart';

class SearchResultsPage extends StatefulWidget {
  // final List<SearchModel> results;
  final SearchController controller;
  const SearchResultsPage({super.key, required this.controller});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with RouteAware {
  Widget item(Books data, var context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          // List<String> corteUrl1 = data.link.split('manga/');
          GoRouter.of(context).push('/detail/${data.link}/${data.idExtension}');
        },
        child: SizedBox(
          width: 110,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 145.0,
                height: 181.0,
                // child: Image.network(
                //   data.img,
                //   width: 145.0,
                //   height: 187.5,
                //   loadingBuilder: (context, child, loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Container(
                //       color: Colors.grey,
                //     );
                //   },
                //   errorBuilder: (context, error, stackTrace) => const Center(
                //     child: Icon(Icons.report_problem),
                //   ),
                //   fit: BoxFit.fill,
                // ),
              ),
              AutoSizeText(
                data.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                maxFontSize: 13,
                minFontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultList(SearchModel model, BuildContext context) {
    if (model.state == SearchStates.sucess) {
      if (model.books.isEmpty) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 95,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 18.0, bottom: 18.0, left: 18.0),
            child: Column(
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                      height: 18,
                      child: Text(
                        model.font,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                const Center(
                  child: Text("Nenhum resultado encontrado"),
                ),
              ],
            ),
          ),
        );
      } else {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 255,
          child: Column(
            children: [
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: SizedBox(
                  height: 27,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          model.font,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          alignment: Alignment.topCenter,
                          tooltip: "ir",
                          onPressed: () {
                            GlobalData.searchModelSelected = model;
                            GlobalData.searchString =
                                widget.controller.lastSearch;
                            GoRouter.of(context)
                                .push('/searchshowpage/${model.idExtension}');
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            size: 20,
                          ))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: model.books.length,
                  cacheExtent: 1000,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      item(model.books[index], context),
                ),
              ),
            ],
          ),
        );
      }
    } else if (model.state == SearchStates.start) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                  height: 18,
                  child: Text(
                    model.font,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                )),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 255,
        child: Column(
          children: [
            const Divider(),
            SizedBox(
                height: 18,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    model.font,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            Expanded(
              child: Center(
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.report_gmailerrorred),
                    Text('Erro na busca')
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    widget.controller.state.value++;
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ValueListenableBuilder(
          valueListenable: widget.controller.state,
          builder: (context, value, child) => ListView.builder(
              itemCount: widget.controller.result.length,
              cacheExtent: 10000,
              itemBuilder: (context, index) =>
                  resultList(widget.controller.result[index], context)),
        ));
  }
}
