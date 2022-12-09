import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../controllers/leitor_controller.dart';

class NovelReader extends StatefulWidget {
  final List<String> pages;
  final Color backgroundColor;
  final PagesController controller;
  const NovelReader({super.key, required this.pages, required this.backgroundColor, required this.controller});

  @override
  State<NovelReader> createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> {
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Widget generateLine(int index) {
    if (widget.backgroundColor == Colors.black || widget.backgroundColor == Colors.grey) {
      return Text(widget.pages[index], style: const TextStyle(color: Colors.white),);
    } else {
      return Text(widget.pages[index], style: const TextStyle(color: Colors.black),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
}
