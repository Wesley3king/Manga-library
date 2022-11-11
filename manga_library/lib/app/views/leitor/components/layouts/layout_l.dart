import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';

class LayoutL extends StatefulWidget {
  final ValueNotifier<bool> notifier;
  final PagesController controller;
  final LeitorTypes leitorType;
  const LayoutL(
      {super.key,
      required this.notifier,
      required this.controller,
      required this.leitorType});

  @override
  State<LayoutL> createState() => _LayoutLState();
}

class _LayoutLState extends State<LayoutL> {
  void next() => widget.controller.scrollToPosition(widget.leitorType, ReaderPageAction.next);

  void prev() => widget.controller.scrollToPosition(widget.leitorType, ReaderPageAction.prev);
  
  @override
  Widget build(BuildContext context) {
    double rowItensWidth = MediaQuery.of(context).size.width / 3;
    double columnItensHeight = MediaQuery.of(context).size.height / 3;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => prev(),
            child: Container(
              height: columnItensHeight,
              color: const Color.fromARGB(148, 76, 175, 79),
            ),
          ),
          SizedBox(
            height: columnItensHeight,
            child: Row(
              children: [
                Container(
                  width: rowItensWidth,
                  color: const Color.fromARGB(148, 76, 175, 79),
                ),
                SizedBox(
                  width: rowItensWidth,
                  child: GestureDetector(
                    onTap: () => widget.notifier.value = !widget.notifier.value,
                  ),
                ),
                Container(
                  width: rowItensWidth,
                  color: const Color.fromARGB(141, 255, 153, 0),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () => next(),
            child: Container(
              height: columnItensHeight,
              color: const Color.fromARGB(141, 255, 153, 0),
            ),
          )
        ],
      ),
    );
  }
}
