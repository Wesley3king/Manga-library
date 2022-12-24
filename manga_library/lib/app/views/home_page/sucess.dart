import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/home_page_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/views/home_page/horizontal_list.dart';

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
    final int sortExtension = Random().nextInt(widget.dados.length);
    final int sortIndice = Random().nextInt(widget.dados[sortExtension].books.length);
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
                        imageUrl: widget.dados[sortExtension].books[sortIndice].img,
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
                      gradient: ConfigSystemController.instance.isDarkTheme
                          ? const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                  Color.fromARGB(255, 48, 48, 48),
                                  Color.fromARGB(43, 0, 0, 0)
                                ],
                              stops: [
                                  0.1,
                                  1
                                ])
                          : const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                  Color.fromARGB(255, 250, 250, 250),
                                  Color.fromARGB(43, 0, 0, 0)
                                ],
                              stops: [
                                  0.1,
                                  1
                                ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => GoRouter.of(context).push('/detail/${widget.dados[sortExtension].books[sortIndice].url}/${widget.dados[sortExtension].books[sortIndice].idExtension}'),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 150,
                              height: 220,
                              child: CachedNetworkImage(
                                imageUrl: widget.dados[sortExtension].books[sortIndice].img,
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
                          AutoSizeText(
                            widget.dados[sortExtension].books[sortIndice].name,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            maxFontSize: 20,
                            minFontSize: 18,
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
            buildLists(),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
