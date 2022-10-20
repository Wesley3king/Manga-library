import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:readmore/readmore.dart';

import '../../controllers/system_config.dart';
import '../../models/manga_info_offline_model.dart';
import 'add_to_library.dart';

class MangaDetails extends StatefulWidget {
  final String link;
  final MangaInfoOffLineModel dados;
  final MangaInfoController controller;
  final List<Capitulos>? capitulosDisponiveis;
  const MangaDetails(
      {super.key,
      required this.link,
      required this.dados,
      required this.controller,
      required this.capitulosDisponiveis});

  @override
  State<MangaDetails> createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> {
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  ValueNotifier<bool> isExpanded = ValueNotifier(false);

  void setIsExpanded() {
    setState(() {});
    isExpanded.value = !isExpanded.value;
    debugPrint("is showing: $isExpanded");
  }

  // ======== BUILD CATEGORIES =================
  Widget buildCategories() {
    if (isExpanded.value) {
      List<Widget> categories = widget.dados.genres.map<Widget>((category) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: SizedBox(
            height: 25.0,
            child: Chip(
              padding: const EdgeInsets.all(0),
              labelStyle: const TextStyle(height: 0.3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.transparent,
              side: BorderSide(
                width: 1.0,
                color: configSystemController.colorManagement(),
              ),
              label: Text(category),
            ),
          ),
        );
      }).toList();
      return Wrap(
        children: categories,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 31,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.dados.genres.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(3.0),
            child: SizedBox(
              height: 31.0,
              child: Chip(
                padding: const EdgeInsets.all(0),
                labelStyle: const TextStyle(height: 0.3),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.transparent,
                side: BorderSide(
                  width: 1.0,
                  color: configSystemController.colorManagement(),
                ),
                label: Text(widget.dados.genres[index]),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Image(
                  image: CachedNetworkImageProvider(
                    widget.dados.img,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: ConfigSystemController.instance.isDarkTheme
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                            0.1,
                            0.3,
                            1
                          ],
                            colors: [
                            Color.fromARGB(255, 48, 48, 48),
                            Color.fromARGB(237, 49, 49, 49),
                            Color.fromARGB(214, 71, 71, 71)
                          ]))
                    : const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                            0.4,
                            0.7,
                            1
                          ],
                            colors: [
                            Color.fromARGB(255, 247, 247, 247),
                            Color.fromARGB(235, 218, 218, 218),
                            Color.fromARGB(80, 185, 185, 185)
                          ])),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 185,
                        height: 275,
                        child: Image(
                          image: CachedNetworkImageProvider(
                            widget.dados.img,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 206),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Flexible(
                          child: Text(
                            widget.dados.name,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: widget.dados.name.length > 30 ? 13 : 17,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(widget.dados.authors, textAlign: TextAlign.start),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.dados.state,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Capítulos: ${widget.dados.chapters}',
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                                child: Text(
                                    mapOfExtensions[widget.dados.idExtension]!
                                        .nome))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        TextButtonTheme(
          data: TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      ConfigSystemController.instance.isDarkTheme
                          ? Colors.white
                          : const Color.fromARGB(255, 51, 51, 51)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AddToLibrary(
                link: widget.link,
                dados: widget.dados,
                capitulos: widget.capitulosDisponiveis ?? [],
              ),
              TextButton(
                  onPressed: () => GoRouter.of(context)
                      .push('/webview/${widget.link}/${widget.dados.idExtension}'),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.public,
                        size: 26,
                      ),
                      Text(
                        "WebView",
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ))
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
        ),
        AnimatedBuilder(
          animation: isExpanded,
          builder: (context, child) => buildCategories(),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReadMoreText(
              widget.dados.description,
              callback: (val) => setIsExpanded(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
              delimiter: ' ... ',
              colorClickableText: configSystemController.colorManagement(),
              trimExpandedText: '  Menos',
              trimCollapsedText: ' Mais',
              trimLines: 3,
              trimMode: TrimMode.Line,
            )),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
      ],
    );
  }
}
/*
Padding(
  padding: const EdgeInsets.all(4.0),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
          color: configSystemController.colorManagement(), width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 6.0, right: 7.0, left: 7.0),
      child: Text(category),
    ),
  ),
);
*/