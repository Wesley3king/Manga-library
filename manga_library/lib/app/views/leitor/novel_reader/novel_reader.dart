import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NovelReader extends StatelessWidget {
  final List<String> pages;
  final Color backgroundColor;
  const NovelReader({super.key, required this.pages, required this.backgroundColor});

  Widget generateLine(int index) {
    if (backgroundColor == Colors.black) {
      return Text(pages[index], style: const TextStyle(color: Colors.white),);
    } else {
      return Text(pages[index], style: const TextStyle(color: Colors.black),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: ScrollablePositionedList.builder(
          itemCount: (pages.length - 1),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: generateLine(index + 1),
          ),
        ),
      ),
    );
  }
}
