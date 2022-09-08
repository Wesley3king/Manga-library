import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:manga_library/app/controllers/leitor_controller.dart';
// import 'package:manga_library/app/views/components/leitor/pages_states.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PagesLeitor extends StatefulWidget {
  final String link;
  final String id;
  const PagesLeitor({super.key, required this.link, required this.id});

  @override
  State<PagesLeitor> createState() => _PagesLeitorState();
}

// with AutomaticKeepAliveClientMixin
class _PagesLeitorState extends State<PagesLeitor> {
  final LeitorController _leitorController = LeitorController();
  final PagesController controller = PagesController();
  // final PagesStates _pagesStates = PagesStates();
  final FullScreenController screenController = FullScreenController();

  Widget loading() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget error([String src = "erro no carregamento dos capitulos"]) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.info),
            const SizedBox(
              height: 10,
            ),
            const Text('Error!'),
            Text('image: $src')
          ],
        ),
      ),
    );
  }

  Widget photoViewLeitor(Axis scrollDirection, bool reverse) {
    return PhotoViewGallery.builder(
      itemCount: _leitorController.capitulosEmCarga[0].pages.length,
      gaplessPlayback: true,
      scrollDirection: scrollDirection,
      reverse: reverse,
      onPageChanged: (index) => controller.setPage = (index + 1),
      wantKeepAlive: true,
      builder: (context, index) => PhotoViewGalleryPageOptions(
        imageProvider:
            NetworkImage(_leitorController.capitulosEmCarga[0].pages[index]),
        // filterQuality:
      ),
    );
  }

  Widget listViewLeitor() {
    return ListView.builder(
      itemCount: _leitorController.capitulosEmCarga[0].pages.length,
      cacheExtent: 8000.0,
      itemBuilder: (context, index) =>
          GestureDetector(
            onTap: () => controller.setPage = index,
            child: MyPageImage(
              url: _leitorController.capitulosEmCarga[0].pages[index],
              filterQuality: FilterQuality.low,
            ),
          ),
    );
  }

  Widget _leitorType(LeitorTypes type) {
    switch (type) {
      case LeitorTypes.vertical:
        return photoViewLeitor(Axis.vertical, false);
      case LeitorTypes.ltr:
        return photoViewLeitor(Axis.horizontal, false);
      case LeitorTypes.rtl:
        return photoViewLeitor(Axis.horizontal, true);
      case LeitorTypes.webtoon:
        return listViewLeitor();
      default:
        return photoViewLeitor(Axis.horizontal, false,);
    }
  }

  Widget _stateManagement(LeitorStates state) {
    switch (state) {
      case LeitorStates.start:
        return loading();
      case LeitorStates.loading:
        return loading();
      case LeitorStates.sucess:
        return AnimatedBuilder(
          animation: _leitorController.leitorTypeState,
          builder: (context, child) =>
              _leitorType(_leitorController.leitorTypeState.value),
        );
      case LeitorStates.error:
        return error();
    }
  }

  @override
  void initState() {
    super.initState();
    _leitorController.start(widget.link, widget.id);
    screenController.enterFullScreen();
  }

  @override
  void dispose() {
    super.dispose();
    screenController.exitFullScreen();
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedBuilder(
        animation: _leitorController.state,
        builder: (context, child) =>
            _stateManagement(_leitorController.state.value),
      ),
      SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: controller.state,
              builder: (context, child) => Text(
                "${controller.state.value}/${_leitorController.capitulosEmCarga[0].pages.length}",
                style: const TextStyle(shadows: [
                  Shadow(color: Colors.black45, offset: Offset(1, 1))
                ]),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}

class MyPageImage extends StatefulWidget {
  final String url;
  final FilterQuality filterQuality;
  const MyPageImage({super.key, required this.url, required this.filterQuality});

  @override
  State<MyPageImage> createState() => _MyPageImageState();
}

class _MyPageImageState extends State<MyPageImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Image.network(
        widget.url,
        filterQuality: widget.filterQuality,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  value: loadingProgress.expectedTotalBytes == null
                      ? null
                      : loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: Center(
            child: Text("Error! \n - img: ${widget.url}"),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
