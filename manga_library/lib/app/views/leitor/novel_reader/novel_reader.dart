import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../controllers/leitor_controller.dart';

class NovelReader extends StatefulWidget {
  final List<String> pages;
  final Color backgroundColor;
  final PagesController controller;
  const NovelReader(
      {super.key,
      required this.pages,
      required this.backgroundColor,
      required this.controller});

  @override
  State<NovelReader> createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> {
  double screenWidth = 360;
  List<double> listHeight = <double>[];
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  Widget generateLine(int index) {
    double sizeOfCaracteresInPx = 3;
    listHeight.add(
        (((widget.pages[index].length * sizeOfCaracteresInPx) / screenWidth) *
                10) +
            6.0);

    /// troca a cor das letras de acordo com o backgroundColor
    if (widget.backgroundColor == Colors.black ||
        widget.backgroundColor == Colors.grey) {
      return Text(
        widget.pages[index],
        style: const TextStyle(color: Colors.white),
      );
    } else {
      return Text(
        widget.pages[index],
        style: const TextStyle(color: Colors.black),
      );
    }
  }

  @override
  void dispose() {
    removePositionListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    activePositionListener();
    return Container(
      color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ScrollablePositionedList.builder(
          itemCount: (widget.pages.length - 1),
          scrollController: widget.controller.scrollController,
          itemScrollController: widget.controller.scrollControllerList,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: generateLine(index + 1),
          ),
        ),
      ),
    );
  }

  /// LISTENER ItemPositions
  void listener() {
    Iterable<ItemPosition> positions =
        itemPositionsListener.itemPositions.value;
    int? max;
    if (positions.isNotEmpty) {
      // Determine the last visible item by finding the item with the
      // greatest leading edge that is less than 1.  i.e. the last
      // item whose leading edge in visible in the viewport.
      max = positions
          .where((ItemPosition position) => position.itemLeadingEdge < 1)
          .reduce((ItemPosition max, ItemPosition position) =>
              position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
          .index;
    }
    if (max != null) {
      Future.delayed(const Duration(milliseconds: 100),
          () => widget.controller.setPage = ((max ?? 0) + 1));
    }
  }

  /// notifica o paragrafo identificado
  void activePositionListener() {
    itemPositionsListener.itemPositions.addListener(listener);
  }

  /// remove o notificador
  void removePositionListener() {
    itemPositionsListener.itemPositions.removeListener(listener);
  }
}
