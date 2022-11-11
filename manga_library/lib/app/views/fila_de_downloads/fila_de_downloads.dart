import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/views/manga_info/off_line/off_line_widget.dart';

class FilaDeDownloads extends StatefulWidget {
  const FilaDeDownloads({super.key});

  @override
  State<FilaDeDownloads> createState() => _FilaDeDownloadsState();
}

class _FilaDeDownloadsState extends State<FilaDeDownloads> {
  List<Widget> verifyDownloads() {
    if (DownloadController.isDownloading) {
      List<Widget> itens = [];
      for (DownloadModel model in DownloadController.filaDeDownload) {
        itens.add(CustomListTile(model: model));
      }
      return itens;
    } else {
      return [
        const SizedBox(
          height: 200,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.downloading_outlined, size: 40,),
            SizedBox(width: 5,),
            Text("Não há Downloads na fila", style: TextStyle(fontSize: 18),)
          ],
        )
      ];
    }
  }

  // Widget generateItem() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fila de Downloads'),
      ),
      body: ListView(
        children: verifyDownloads(),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final DownloadModel model;
  const CustomListTile({super.key, required this.model});

  void goToMangaDetail(BuildContext context, String link, int idExtension) {
    GoRouter.of(context).push('/detail/$link/$idExtension');
  }

  void insertValueNotifier() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: SizedBox(
                    width: 80,
                    height: 110,
                    child: CachedNetworkImage(
                      imageUrl: model.model.img,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.model.name,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Cap. ${model.capitulo.capitulo}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: OffLineWidget(
                  pieceOfLink: model.pieceOfLink,
                  capitulo: model.capitulo,
                  model: model.model,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
