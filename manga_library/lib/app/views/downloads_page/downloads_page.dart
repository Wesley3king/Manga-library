import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';
import 'package:manga_library/app/views/downloads_page/controllers/downloads_page_controller.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final DownloadsPageController controller = DownloadsPageController();

  /// loading
  Widget get loading => const Center(
        child: CircularProgressIndicator(),
      );

  /// error
  Widget get error => Center(
        child: Column(
          children: const <Widget>[
            Icon(Icons.report_problem),
            Text("Erro ao obter os Downloads")
          ],
        ),
      );

  /// sucess
  Widget sucess() {
    if (controller.data.isEmpty) {
      return Center(
        child: Row(
          children: const <Widget>[
            Icon(Icons.file_download_off),
            Text("Sem Downloads")
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: controller.data.length,
      itemBuilder: (context, index) =>
          CustomListTileForDownload(model: controller.data[index]),
    );
  }

  Widget _stateManagement(DownloadsPageStates state) {
    switch (state) {
      case DownloadsPageStates.start:
        return loading;
      case DownloadsPageStates.loading:
        return loading;
      case DownloadsPageStates.sucess:
        return sucess();
      case DownloadsPageStates.error:
        return error;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) => _stateManagement(controller.state.value),
      ),
    );
  }
}

class CustomListTileForDownload extends StatelessWidget {
  final DownloadPagesModel model;
  const CustomListTileForDownload({super.key, required this.model});

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
                    child: GestureDetector(
                      onTap: () => goToMangaDetail(context, model.link, model.idExtension),
                      child: CachedNetworkImage(
                        imageUrl: model.img,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 150),
                child: GestureDetector(
                  onTap: () => goToMangaDetail(context, model.link, model.idExtension),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Cap. ${model.chapter}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 5.0,
              //     right: 5.0,
              //   ),
              //   child: OffLineWidget(
              //     pieceOfLink: model.pieceOfLink,
              //     capitulo: model.capitulo,
              //     model: model.model,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
