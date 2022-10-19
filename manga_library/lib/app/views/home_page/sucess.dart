import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/home_page_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/views/home_page/horizontal_list.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../models/globais.dart';

class Sucess extends StatefulWidget {
  final List<ModelHomePage> dados;
  final HomePageController controller;
  final ScrollController controllerScroll;
  const Sucess(
      {super.key,
      required this.dados,
      required this.controller,
      required this.controllerScroll});

  @override
  State<Sucess> createState() => _SucessState();
}

class _SucessState extends State<Sucess> {
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  // alinharMangas() {
  Widget buildLists() {
    List<HorizontalList> listas = [];
    for (ModelHomePage model in widget.dados) {
      listas.add(HorizontalList(dados: model));
    }

    return Column(
      children: listas,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: configSystemController.colorManagement(),
      onRefresh: () => widget.controller.update(),
      child: SingleChildScrollView(
        controller: widget.controllerScroll,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 330,
              child: Stack(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 330,
                      child: CachedNetworkImage(
                        imageUrl: widget.dados[0].books[0].img,
                        placeholder: (context, url) => Container(
                          color: Colors.grey,
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.report_problem),
                        ),
                        fit: BoxFit.cover,
                      )),
                  Container(
                    decoration: BoxDecoration(
                      gradient: ConfigSystemController.instance.isDarkTheme ? const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color.fromARGB(255, 48, 48, 48), Color.fromARGB(43, 0, 0, 0)],
                          stops: [0.1, 1]) : 
                          const  LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color.fromARGB(255, 250, 250, 250), Color.fromARGB(43, 0, 0, 0)],
                            stops: [0.1, 1]
                          ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => debugPrint(GlobalData.settings["Tema"]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 150,
                              height: 240,
                              child: CachedNetworkImage(
                                imageUrl: widget.dados[0].books[0].img,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(Icons.report_problem),
                                ),
                                fit: BoxFit.fill,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Text(widget.dados[0].books[0].name,
                                style: const TextStyle(
                                  // color: Colors.white,
                                  fontSize: 20,
                                )),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            buildLists()
          ],
        ),
      ),
    );
  }
}
