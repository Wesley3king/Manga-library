import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/models/leitor_model.dart';
import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/app/views/components/manga_info/add_to_library.dart';
import 'package:manga_library/app/views/components/manga_info/bottom_sheet_list.dart';

class SucessMangaInfo extends StatefulWidget {
  final ModelMangaInfo dados;
  final bool sucess2;
  final List<ModelLeitor>? capitulosDisponiveis;
  final String link;
  const SucessMangaInfo(
      {super.key,
      required this.dados,
      required this.sucess2,
      required this.link,
      required this.capitulosDisponiveis});

  @override
  State<SucessMangaInfo> createState() => _SucessMangaInfoState();
}

class _SucessMangaInfoState extends State<SucessMangaInfo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: Image(
                  image: CachedNetworkImageProvider(
                    widget.dados.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [
                      0.1,
                      0.2,
                      1
                    ],
                        colors: [
                      Color.fromARGB(255, 48, 48, 48),
                      Color.fromARGB(237, 49, 49, 49),
                      Colors.transparent
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  height: 225,
                  child: Image(
                    image: CachedNetworkImageProvider(widget.dados.cover,),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Row(
          children: [
            const AddToLibrary(),
            Expanded(
              child: Text(
                widget.dados.chapterName,
                // maxLines: 4,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
        widget.sucess2
            ? ButtomBottomSheetChapterList(
              listaCapitulos: widget.dados.allposts, listaCapitulosDisponiveis: widget.capitulosDisponiveis, nameImageLink: {"name": widget.dados.chapterName, "img": widget.dados.cover, "link": widget.link},)
            : const CircularProgressIndicator(),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Capítulos: ${widget.dados.chapters}',
                textAlign: TextAlign.start,
              ),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 37,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.dados.genres.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0, right: 7.0, left: 7.0),
                  child: Text(widget.dados.genres[index]),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.dados.description,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ));
  }
}
