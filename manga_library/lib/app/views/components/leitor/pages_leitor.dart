import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:manga_library/app/controllers/leitor_controller.dart';
// import 'package:manga_library/app/views/components/leitor/pages_states.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/views/components/leitor/web_view/web_view_reader.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PagesLeitor extends StatefulWidget {
  final Function showOrHideInfo;
  final LeitorController leitorController;
  final PagesController controller;
  final String link;
  final String id;
  const PagesLeitor(
      {super.key,
      required this.link,
      required this.id,
      required this.leitorController,
      required this.controller,
      required this.showOrHideInfo});

  @override
  State<PagesLeitor> createState() => _PagesLeitorState();
}

// with AutomaticKeepAliveClientMixin
class _PagesLeitorState extends State<PagesLeitor> {
  // final PagesController controller = PagesController();
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

  Widget photoViewLeitor(Axis scrollDirection, bool reverse,
      FilterQuality filterQuality, Color color) {
    /// esta função determina o tipo de image privider ao decodificar as imagens
    ImageProvider<Object> returnAnImageProvider(int index) {
      if (widget.leitorController.capitulosEmCarga[0].download) {
        return FileImage(File(
            widget.leitorController.capitulosEmCarga[0].downloadPages[index]));
      } else {
        return NetworkImage(
            widget.leitorController.capitulosEmCarga[0].pages[index]);
      }
    }

    // Color(0xff000000);

    debugPrint(
        "length pages: ${widget.leitorController.capitulosEmCarga[0].pages.length}");
    return PhotoViewGallery.builder(
      itemCount: widget.leitorController.capitulosEmCarga[0].download
          ? widget.leitorController.capitulosEmCarga[0].downloadPages.length
          : widget.leitorController.capitulosEmCarga[0].pages.length,
      gaplessPlayback: true,
      scrollDirection: scrollDirection,
      reverse: reverse,
      onPageChanged: (index) => widget.controller.setPage = (index + 1),
      wantKeepAlive: true,
      backgroundDecoration: BoxDecoration(color: color),
      builder: (context, index) => PhotoViewGalleryPageOptions(
        imageProvider: returnAnImageProvider(index),
        filterQuality: filterQuality,
        // onTapUp: (context, details, controllerValue) => widget.showOrHideInfo(),
        // filterQuality:
      ),
    );
  }

  Widget listViewLeitor(FilterQuality filterQuality) {
    return ListView.builder(
      itemCount: widget.leitorController.capitulosEmCarga[0].pages.length,
      cacheExtent: 8000.0,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          widget.controller.setPage = index;
          // widget.showOrHideInfo();
        },
        child: MyPageImage(
          capitulo: widget.leitorController.capitulosEmCarga[0],
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
      child: widget.leitorController.capitulosEmCarga[0].download
          ? ListView.builder(
              itemCount:
                  widget.leitorController.capitulosEmCarga[0].pages.length,
              itemBuilder: (context, index) => ExtendedImage.file(
                File(widget
                    .leitorController.capitulosEmCarga[0].downloadPages[index]),
                clearMemoryCacheWhenDispose: true,
                filterQuality: filterQuality,
                maxBytes: 30,
                compressionRatio: 0.9,
              ),
            )
          : ListView.builder(
              itemCount:
                  widget.leitorController.capitulosEmCarga[0].pages.length,
              itemBuilder: (context, index) => ExtendedImage.network(
                widget.leitorController.capitulosEmCarga[0].pages[index],
                clearMemoryCacheWhenDispose: true,
                filterQuality: filterQuality,
                maxBytes: 30,
                compressionRatio: 0.9,
              ),
            ),
    );
  }

  Widget pageListViewLeitor(
      {bool rtl = false,
      required FilterQuality filterQuality,
      required Color color}) {
    return PageView.builder(
      itemCount: widget.leitorController.capitulosEmCarga[0].pages.length,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) => widget.controller.setPage = (index + 1),
      reverse: rtl,
      itemBuilder: (context, index) => Container(
        // onTap: () => widget.showOrHideInfo(),
        color: color,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            MyPageImage(
              capitulo: widget.leitorController.capitulosEmCarga[0],
              index: index,
              filterQuality: filterQuality,
            )
          ],
        ),
      ),
    );
  }

  Widget _filterQuality(LeitorTypes type) {
    FilterQuality filterQuality = FilterQuality.none;
    switch (widget.leitorController.filterQualityState.value) {
      case LeitorFilterQuality.none:
        // return _leitorType(type, FilterQuality.none);
        filterQuality = FilterQuality.none;
        break;
      case LeitorFilterQuality.low:
        filterQuality = FilterQuality.low;
        break;
      case LeitorFilterQuality.medium:
        filterQuality = FilterQuality.medium;
        break;
      case LeitorFilterQuality.hight:
        filterQuality = FilterQuality.high;
        break;
    }
    return AnimatedBuilder(
      animation: widget.leitorController.backgroundColorState,
      builder: (context, child) => _backgroundColor(
          widget.leitorController.leitorTypeState.value, filterQuality),
    );
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
        return newLeitor(filterQuality, color);
      case LeitorTypes.webview:
        return MyWebviewx(
          pages: widget.leitorController.capitulosEmCarga[0].pages,
          color: color,
        );
      case LeitorTypes.ltrlist:
        return pageListViewLeitor(filterQuality: filterQuality, color: color);
      case LeitorTypes.rtllist:
        return pageListViewLeitor(
            rtl: true, filterQuality: filterQuality, color: color);
    }
  }

  Widget _backgroundColor(LeitorTypes type, FilterQuality filterQuality) {
    return AnimatedBuilder(
      animation: widget.leitorController.leitorTypeState,
      builder: (context, child) {
        Color color = widget.leitorController.backgroundColorState.value ==
                LeitorBackgroundColor.black
            ? Colors.black
            : Colors.white;
        return AnimatedBuilder(
          animation: widget.leitorController.leitorTypeState,
          builder: (context, child) => _leitorType(
              widget.leitorController.leitorTypeState.value,
              filterQuality,
              color),
        );
      },
    );
  }

  Widget _stateManagement(LeitorStates state) {
    switch (state) {
      case LeitorStates.start:
        return loading();
      case LeitorStates.loading:
        return loading();
      case LeitorStates.sucess:
        return AnimatedBuilder(
          animation: widget.leitorController.filterQualityState,
          builder: (context, child) =>
              _filterQuality(widget.leitorController.leitorTypeState.value),
        );
      case LeitorStates.error:
        return error();
    }
  }

  @override
  void initState() {
    super.initState();
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
