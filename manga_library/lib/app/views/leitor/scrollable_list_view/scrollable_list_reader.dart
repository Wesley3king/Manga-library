import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../controllers/leitor_controller.dart';

class ScrollablePositionedListPage extends StatefulWidget {
  final bool isOffLine;
  final PagesController controller;
  final FilterQuality filterQuality;
  final List<String> lista;
  final Color color;
  const ScrollablePositionedListPage(
      {super.key,
      required this.lista,
      required this.color,
      required this.filterQuality,
      required this.isOffLine,
      required this.controller});

  @override
  ScrollablePositionedListPageState createState() =>
      ScrollablePositionedListPageState();
}

class ScrollablePositionedListPageState
    extends State<ScrollablePositionedListPage> {
  // final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late List<double> itemHeights = [];
  ValueNotifier<int> indexes = ValueNotifier<int>(0);
  bool isWorking = false;
  List<Widget> images = [];

  @override
  void initState() {
    super.initState();
    // final heightGenerator = Random(328902348);
    // final colorGenerator = Random(42490823);
    // itemHeights = List<double>.generate(
    //     numberOfItems,
    //     (int _) =>
    //         heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) +
    //         minItemHeight);
    // itemColors = List<Color>.generate(numberOfItems,
    //     (int _) => Color(colorGenerator.nextInt(randomMax)).withOpacity(1));
  }

  @override
  Widget build(BuildContext context) => Material(
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            children: <Widget>[
              Expanded(
                child: list(orientation),
              ),
              positionsView,
            ],
          );
        }),
      );

  Widget list(Orientation orientation) => InteractiveViewer(
    child: Container(
          color: widget.color,
          child: ValueListenableBuilder(
            valueListenable: indexes, 
            builder: (context, value, child) => ScrollablePositionedList.builder(
            itemCount: widget.lista.length,
            itemBuilder: (context, index) => generateItens(index, context),
            itemScrollController: widget.controller.scrollControllerList,
            scrollController: widget.controller.scrollController,
            itemPositionsListener: itemPositionsListener,
            //reverse: reversed,
            // scrollDirection: orientation == Orientation.portrait
            //     ? Axis.vertical
            //     : Axis.horizontal,
          ),
          )
        ),
  );

  Widget get positionsView => ValueListenableBuilder<Iterable<ItemPosition>>(
        valueListenable: itemPositionsListener.itemPositions,
        builder: (context, positions, child) {
          // int? min;
          int? max;
          if (positions.isNotEmpty) {
            // Determine the first visible item by finding the item with the
            // smallest trailing edge that is greater than 0.  i.e. the first
            // item whose trailing edge in visible in the viewport.

            // min = positions
            //     .where((ItemPosition position) => position.itemTrailingEdge > 0)
            //     .reduce((ItemPosition min, ItemPosition position) =>
            //         position.itemTrailingEdge < min.itemTrailingEdge
            //             ? position
            //             : min)
            //     .index;

            // Determine the last visible item by finding the item with the
            // greatest leading edge that is less than 1.  i.e. the last
            // item whose leading edge in visible in the viewport.
            max = positions
                .where((ItemPosition position) => position.itemLeadingEdge < 1)
                .reduce((ItemPosition max, ItemPosition position) =>
                    position.itemLeadingEdge > max.itemLeadingEdge
                        ? position
                        : max)
                .index;
          }
          if (max != null) {
            Future.delayed(const Duration(milliseconds: 100),
                () => widget.controller.setPage = ((max ?? 0) + 1));
          }
          return Container();
        },
      );

  /// generate itens
  Widget generateItens(int index, BuildContext context) {
    if (index < indexes.value) {
      return item(index, MediaQuery.of(context).orientation);
    } else {
      if (images.length != widget.lista.length) {
        if (isWorking) {
          return const SizedBox(
            width: double.infinity,
            height: 800,
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          generateImage(widget.lista[index], MediaQuery.of(context).size.width);
          return const SizedBox(
            width: double.infinity,
            height: 800,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      } else {
        return Container();
      }
    }
  }

  // get on line image
  Future<Uint8List> getOnLineImage(String src) async {
    Response<List<int>> rs = await Dio(BaseOptions(connectTimeout: 60000, )).get<List<int>>(src,
        options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(rs.data!);
  }

  // get an offLine image
  Future<Uint8List> getOffLineImage(String src) async {
    File file = File(src);
    List<int> rs = await file.readAsBytes();
    return Uint8List.fromList(rs);
  }

  Future<void> generateImage(String src, double width) async {
    try {
      isWorking = true;
      Uint8List bytes = widget.isOffLine
          ? await getOffLineImage(src)
          : await getOnLineImage(src);
      var image = await decodeImageFromList(bytes);
      var image2 = Image.memory(
        bytes,
        fit: BoxFit.fill,
        filterQuality: widget.filterQuality,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: width,
          height: 100,
          child: Row(children: [
            const Icon(Icons.report_problem),
            Text('Erro ao carregar Imagem: $src')
          ],),
        ),
      );
      itemHeights.add((image.height * width) / image.width);
      images.add(image2);
      debugPrint("Imagem adicionada!");
      // debugPrint("imagem : $src adicionada! h : ${image.height.toDouble()}");
      isWorking = false;
      indexes.value++;
    } catch (e) {
      debugPrint("erro no getSize: $e");
      isWorking = false;
      generateImage(src, width);
    }
  }

  Widget item(int i, Orientation orientation) {
    debugPrint("height: ${itemHeights[i]}");
    return SizedBox(
      height: itemHeights[i],
      // width: orientation == Orientation.landscape ? itemHeights[i] : null,
      child: images[i],
    );
  }
}
