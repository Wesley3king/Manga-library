import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:manga_library/app/controllers/leitor_controller.dart';
// import 'package:manga_library/app/views/components/leitor/pages_states.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/views/leitor/scrollable_list_view/scrollable_list_reader.dart';
import 'package:manga_library/app/views/leitor/web_view/web_view_reader.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PagesLeitor extends StatefulWidget {
  final LeitorController leitorController;
  final PagesController controller;
  final String link;
  final String id;
  const PagesLeitor(
      {super.key,
      required this.link,
      required this.id,
      required this.leitorController,
      required this.controller,});

  @override
  State<PagesLeitor> createState() => _PagesLeitorState();
}

// with AutomaticKeepAliveClientMixin
class _PagesLeitorState extends State<PagesLeitor> {
  // final PagesController controller = PagesController();
  // final PagesStates _pagesStates = PagesStates();
  final FullScreenController screenController = FullScreenController();
  // late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;

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

  Widget photoViewLeitor(Axis scrollDirection, bool reverse,
      FilterQuality filterQuality, Color color) {
    /// esta função determina o tipo de image privider ao decodificar as imagens
    ImageProvider<Object> returnAnImageProvider(int index) {
      if (widget.leitorController.atualChapter.download) {
        return FileImage(
            File(widget.leitorController.atualChapter.downloadPages[index]));
      } else {
        return NetworkImage(widget.leitorController.atualChapter.pages[index]);
      }
    }

    // Color(0xff000000);
    debugPrint(
        "length pages: ${widget.leitorController.atualChapter.pages.length}");
    return PhotoViewGallery.builder(
      itemCount: widget.leitorController.atualChapter.download
          ? widget.leitorController.atualChapter.downloadPages.length
          : widget.leitorController.atualChapter.pages.length,
      gaplessPlayback: true,
      scrollDirection: scrollDirection,
      pageController: widget.controller.pageController,
      reverse: reverse,
      onPageChanged: (index) => widget.controller.setPage = (index + 1),
      wantKeepAlive: true,
      backgroundDecoration: BoxDecoration(color: color),
      builder: (context, index) => PhotoViewGalleryPageOptions(
        imageProvider: returnAnImageProvider(index),
        filterQuality: filterQuality,
        // filterQuality:
      ),
    );
  }

  Widget listViewLeitor(FilterQuality filterQuality) {
    return ScrollablePositionedList.builder(
      itemCount: widget.leitorController.atualChapter.pages.length,
      itemPositionsListener: itemPositionsListener,
      itemScrollController: widget.controller.scrollControllerList,
      // cacheExtent: 8000.0,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          widget.controller.setPage = index;
        },
        child: MyPageImage(
          capitulo: widget.leitorController.atualChapter,
          index: index,
          filterQuality: filterQuality,
        ),
      ),
    );
  }

  // teste de leitor
  Widget newLeitor(FilterQuality filterQuality, Color color) {
    return Container(
      color: color,
      child: widget.leitorController.atualChapter.download
          ? ScrollablePositionedList.builder(
              itemScrollController: widget.controller.scrollControllerList,
              itemPositionsListener: itemPositionsListener,
              itemCount: widget.leitorController.atualChapter.pages.length,
              itemBuilder: (context, index) => ExtendedImage.file(
                File(widget.leitorController.atualChapter.downloadPages[index]),
                clearMemoryCacheWhenDispose: true,
                filterQuality: filterQuality,
                maxBytes: 30,
                compressionRatio: 0.9,
              ),
            )
          : ScrollablePositionedList.builder(
              itemScrollController: widget.controller.scrollControllerList,
              itemPositionsListener: itemPositionsListener,
              itemCount: widget.leitorController.atualChapter.pages.length,
              itemBuilder: (context, index) => ExtendedImage.network(
                widget.leitorController.atualChapter.pages[index],
                clearMemoryCacheWhenDispose: true,
                filterQuality: filterQuality,
                maxBytes: 30,
                compressionRatio: 0.9,
              ),
            ),
    );
  }

  // novo Leitor
  Widget webtoonReader(FilterQuality filterQuality, Color color) {
    return ScrollablePositionedListPage(
        lista: widget.leitorController.atualChapter.download
            ? widget.leitorController.atualChapter.downloadPages
            : widget.leitorController.atualChapter.pages,
        color: color,
        filterQuality: filterQuality,
        isOffLine: widget.leitorController.atualChapter.download,
        chapterId: widget.leitorController.atualChapter.id,
        controller: widget.controller);
  }

  Widget pageListViewLeitor(
      {bool rtl = false,
      required FilterQuality filterQuality,
      required Color color}) {
    return PageView.builder(
      itemCount: widget.leitorController.atualChapter.pages.length,
      scrollDirection: Axis.horizontal,
      controller: widget.controller.pageController,
      onPageChanged: (index) => widget.controller.setPage = (index + 1),
      reverse: rtl,
      itemBuilder: (context, index) => Container(
        color: color,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            MyPageImage(
              capitulo: widget.leitorController.atualChapter,
              index: index,
              filterQuality: filterQuality,
            )
          ],
        ),
      ),
    );
  }

  FilterQuality _getFilterQuality() {
    switch (widget.leitorController.filterQuality) {
      case LeitorFilterQuality.none:
        return FilterQuality.none;
      case LeitorFilterQuality.low:
        return FilterQuality.low;
      case LeitorFilterQuality.medium:
        return FilterQuality.medium;
      case LeitorFilterQuality.hight:
        return FilterQuality.high;
    }
  }

  Widget _leitorType(
      LeitorTypes type, FilterQuality filterQuality, Color color) {
    switch (type) {
      case LeitorTypes.vertical:
        return photoViewLeitor(Axis.vertical, false, filterQuality, color);
      case LeitorTypes.ltr:
        return photoViewLeitor(Axis.horizontal, false, filterQuality, color);
      case LeitorTypes.rtl:
        return photoViewLeitor(Axis.horizontal, true, filterQuality, color);
      case LeitorTypes.webtoon:
        // return newLeitor(filterQuality, color);
        return webtoonReader(filterQuality, color);
      case LeitorTypes.webview:
        return MyWebviewx(
          pages: widget.leitorController.atualChapter.pages,
          controller: widget.controller,
          color: color,
        );
      case LeitorTypes.ltrlist:
        return pageListViewLeitor(filterQuality: filterQuality, color: color);
      case LeitorTypes.rtllist:
        return pageListViewLeitor(
            rtl: true, filterQuality: filterQuality, color: color);
    }
  }

  /// obtem a cor de fundo
  Color _getColor() {
    return widget.leitorController.backgroundColor ==
            LeitorBackgroundColor.black
        ? Colors.black
        : Colors.white;
  }

  Widget _stateManagement(LeitorStates state) {
    switch (state) {
      case LeitorStates.start:
        return loading();
      case LeitorStates.loading:
        return loading();
      case LeitorStates.sucess:
        return AnimatedBuilder(
            animation: ReaderNotifier.instance,
            builder: (context, child) {
              if (widget.leitorController.isCustomFilter) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(
                          255,
                          widget.leitorController.customFilterValues[0],
                          widget.leitorController.customFilterValues[1],
                          widget.leitorController.customFilterValues[2]),
                      BlendMode.color),
                  child: _leitorType(widget.leitorController.leitorType,
                      _getFilterQuality(), _getColor()),
                );
              } else if (widget.leitorController.isblackAndWhiteFilter) {
                return ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Color.fromARGB(
                          255, 0, 0, 0
                        ),
                      BlendMode.color),
                  child: _leitorType(widget.leitorController.leitorType,
                      _getFilterQuality(), _getColor()),
                );
              }
              return _leitorType(widget.leitorController.leitorType,
                  _getFilterQuality(), _getColor());
            });
      case LeitorStates.error:
        return error();
    }
  }

  @override
  void initState() {
    super.initState();
    // itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    // widget.leitorController.start(widget.link, widget.id);
    // screenController.enterFullScreen();
  }

  @override
  void dispose() {
    super.dispose();
    // screenController.exitFullScreen();
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.leitorController.state,
      builder: (context, child) =>
          _stateManagement(widget.leitorController.state.value),
    );
  }
}
// ------------------------------------------------
//            ===== IMAGE =====
// ------------------------------------------------

class MyPageImage extends StatefulWidget {
  //final String url;
  final Capitulos capitulo;
  final int index;
  final FilterQuality filterQuality;
  const MyPageImage(
      {super.key,
      required this.capitulo,
      required this.index,
      required this.filterQuality});

  @override
  State<MyPageImage> createState() => _MyPageImageState();
}

class _MyPageImageState extends State<MyPageImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: widget.capitulo.download
          ? Image.file(
              File(widget.capitulo.downloadPages[widget.index]),
              filterQuality: widget.filterQuality,
              errorBuilder: (context, error, stackTrace) => SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Center(
                  child: Text(
                      "Error! \n - file img: ${widget.capitulo.pages[widget.index]}"),
                ),
              ),
            )
          : Image.network(
              widget.capitulo.pages[widget.index],
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
                height: 150,
                child: Center(
                  child: Text(
                      "Error! \n - img: ${widget.capitulo.pages[widget.index]}"),
                ),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
