import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/historic_manager_controller.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/historic_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/views/manga_info/manga_details.dart';
import 'package:manga_library/app/views/routes/routes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../controllers/system_config.dart';
import 'off_line/off_line_widget.dart';

class SucessMangaInfo extends StatefulWidget {
  final MangaInfoOffLineModel dados;
  final String link;
  final MangaInfoController controller;
  const SucessMangaInfo({
    super.key,
    required this.dados,
    required this.link,
    required this.controller,
  });

  @override
  State<SucessMangaInfo> createState() => _SucessMangaInfoState();
}

class _SucessMangaInfoState extends State<SucessMangaInfo> with RouteAware {
  final ManagerHistoricController historicController =
      ManagerHistoricController();
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  late final ChaptersController chaptersController;
  late ScrollController _scrollController;
  // colors
  final TextStyle marked = const TextStyle(color: Colors.amber);

  // trailings
  IconButton naoLido(String id, String link, String chapter) {
    // Map<String, String> nameImageLink = {
    //   "name": widget.dados.name,
    //   "img": widget.dados.img,
    //   "link": widget.link
    // };
    return IconButton(
      onPressed: () => markOrRemoveMark(id, link, chapter),
      icon: const Icon(Icons.check),
    );
  }

  IconButton lido(String id, String link, String chapter) {
    return IconButton(
      onPressed: () => markOrRemoveMark(id, link, chapter),
      icon: const Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  /// marca os capitulos como lido ou remove-o da lista de lidos (caso já esteja lido)
  Future<void> markOrRemoveMark(String id, String link, String chapter) async {
    Map<String, String> nameImageLink = {
      "name": widget.dados.name,
      "img": widget.dados.img,
      "link": widget.link
    };
    await chaptersController.marcarDesmarcar(
        id, link, nameImageLink, widget.dados.idExtension);
    await historicController.insertOnHistoric(HistoricModel(
        name: widget.dados.name,
        img: widget.dados.img,
        link: widget.link,
        idExtension: widget.dados.idExtension,
        chapter: chapter,
        date: ""));
    chaptersController.updateChapters(
        nameImageLink["link"]!, widget.dados.idExtension);
  }

  // states
  Widget get _error => SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Column(
            children: const <Widget>[
              Icon(Icons.report_problem),
              Text('Error!'),
            ],
          ),
        ),
      );

  Widget _buildChapter(BuildContext context, int index) {
    final Capitulos capitulo =
        ChaptersController.capitulosCorrelacionados[index - 1];
    // GlobalData.capitulosDisponiveis;

    return ListTile(
      title: Text(capitulo.capitulo,
        style: capitulo.mark
            ? marked
            : capitulo.readed
                ? const TextStyle(color: Color.fromARGB(255, 184, 184, 184))
                : const TextStyle(),
      ),
      subtitle: Text(capitulo.description),
      leading: capitulo.readed
          ? lido(capitulo.id.toString(), widget.link, capitulo.capitulo)
          : naoLido(capitulo.id.toString(), widget.link, capitulo.capitulo),
      trailing: MangaInfoController.isAnOffLineBook
          ? OffLineWidget(
              pieceOfLink: widget.link,
              capitulo: capitulo,
              model: widget.dados,
            )
          : const SizedBox(
              width: 1,
              height: 1,
            ),
      onTap: () {
        // if (!capitulo.readed) {
        //   markOrRemoveMark(
        //       capitulo.id.toString(), widget.link, capitulo.capitulo);
        // }
        GoRouter.of(context).push(
            '/leitor/${widget.link}/${capitulo.id}/${widget.dados.idExtension}');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    chaptersController = ChaptersController();
    MangaInfoController.chaptersController = chaptersController;
    _scrollController = ScrollController();
    //print("link: ${widget.link}");
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
    chaptersController.updateChapters(widget.link, widget.dados.idExtension);
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.sucess2) {
    if (chaptersController.state.value == ChaptersStates.start) {
      chaptersController.start(widget.controller.capitulosDisponiveis ?? [],
          widget.link, widget.dados.idExtension);
    }
    return RefreshIndicator(
      color: configSystemController.colorManagement(),
      onRefresh: () async {
        if (chaptersController.state.value == ChaptersStates.sucess) {
          await widget.controller.updateBook(
              widget.link,
              widget.dados.idExtension,
              img: widget.dados.img
            );
        }
      },
      child: AnimatedBuilder(
          animation: chaptersController.state,
          builder: (context, child) {
            switch (chaptersController.state.value) {
              case ChaptersStates.start:
                return ScrollablePositionedList.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return MangaDetails(
                        link: widget.link,
                        dados: widget.dados,
                        controller: widget.controller,
                        chaptersController: chaptersController,
                      );
                    } else if (index == 1) {
                      return const SizedBox(
                        height: 3.0,
                      );
                    } else if (index == 3) {
                      return const SizedBox(
                        height: 10.0,
                      );
                    } else {
                      return Column(
                        children: [
                          LinearProgressIndicator(
                              color: configSystemController.colorManagement()),
                          const Text(
                            "Carregando os Capitulos",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }
                  },
                );
              case ChaptersStates.loading:
                return ScrollablePositionedList.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return MangaDetails(
                        link: widget.link,
                        dados: widget.dados,
                        controller: widget.controller,
                        chaptersController: chaptersController,
                      );
                    } else if (index == 1) {
                      return const SizedBox(
                        height: 3.0,
                      );
                    } else if (index == 3) {
                      return const SizedBox(
                        height: 10.0,
                      );
                    } else {
                      return Column(
                        children: [
                          LinearProgressIndicator(
                              color: configSystemController.colorManagement()),
                          const Text(
                            "Carregando os Capitulos",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }
                  },
                );
              case ChaptersStates.sucess:
                return VsScrollbar(
                  controller: _scrollController,
                  style: const VsScrollbarStyle(
                      color: Color.fromARGB(223, 158, 158, 158)),
                  child: ScrollablePositionedList.builder(
                    scrollController: _scrollController,
                    itemCount:
                        ChaptersController.capitulosCorrelacionados.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return MangaDetails(
                          link: widget.link,
                          dados: widget.dados,
                          controller: widget.controller,
                          chaptersController: chaptersController,
                        );
                      } else if (index ==
                          (ChaptersController.capitulosCorrelacionados.length +
                              1)) {
                        return const SizedBox(
                          height: 40,
                        );
                      } else {
                        return _buildChapter(context, index);
                      }
                    },
                  ),
                );
              case ChaptersStates.error:
                return VsScrollbar(
                  controller: _scrollController,
                  style: const VsScrollbarStyle(
                      color: Color.fromARGB(223, 158, 158, 158)),
                  child: ScrollablePositionedList.builder(
                    scrollController: _scrollController,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return MangaDetails(
                          link: widget.link,
                          dados: widget.dados,
                          controller: widget.controller,
                          chaptersController: chaptersController,
                        );
                      } else {
                        return _error;
                      }
                    },
                  ),
                );
            }
          }),
    );
  }
}
