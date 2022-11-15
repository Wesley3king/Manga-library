import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
import 'package:manga_library/app/models/globais.dart';

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
  final ValueNotifier<CrossFadeState> showLayout =
      ValueNotifier<CrossFadeState>(GlobalData.settings.showLayout ? CrossFadeState.showFirst : CrossFadeState.showSecond);

  void next() => widget.controller
      .scrollToPosition(widget.leitorType, ReaderPageAction.next);

  void prev() => widget.controller
      .scrollToPosition(widget.leitorType, ReaderPageAction.prev);

  @override
  Widget build(BuildContext context) {
    double rowItensWidth = MediaQuery.of(context).size.width / 3;
    double columnItensHeight = MediaQuery.of(context).size.height / 3;

    return ValueListenableBuilder(
      valueListenable: showLayout,
      builder: (context, value, child) => AnimatedCrossFade(
          firstChild: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTap: () => showLayout.value = CrossFadeState.showSecond,
              child: Column(
                children: [
                  Container(
                    height: columnItensHeight,
                    color: const Color.fromARGB(141, 255, 153, 0),
                    child: Center(
                      child: Text("Anterior", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        shadows: [ Shadow(
                          color: Colors.black,
                          offset: Offset.fromDirection(3),
                          blurRadius: 2.0
                        )]
                      ),),
                    ),
                  ),
                  SizedBox(
                    height: columnItensHeight,
                    child: Row(
                      children: [
                        Container(
                          width: rowItensWidth,
                          color: const Color.fromARGB(141, 255, 153, 0),
                        ),
                        Container(
                          width: rowItensWidth,
                          color: Colors.transparent,
                        ),
                        Container(
                          width: rowItensWidth,
                          color: const Color.fromARGB(148, 76, 175, 79),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: columnItensHeight,
                    color: const Color.fromARGB(148, 76, 175, 79),
                    child: Center(child: Text("Próximo", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        shadows: [ Shadow(
                          color: Colors.black,
                          offset: Offset.fromDirection(3),
                          blurRadius: 2.0
                        )]
                      ),),),
                  )
                ],
              ),
            ),
          ),
          secondChild: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: columnItensHeight,
                  child: GestureDetector(
                    onTap: () => prev(),
                  ),
                ),
                SizedBox(
                  height: columnItensHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: rowItensWidth,
                        child: GestureDetector(
                          onTap: () => prev(),
                        ),
                      ),
                      SizedBox(
                        width: rowItensWidth,
                        child: GestureDetector(
                          onTap: () =>
                              widget.notifier.value = !widget.notifier.value,
                        ),
                      ),
                      SizedBox(
                        width: rowItensWidth,
                        child: GestureDetector(
                          onTap: () => next(),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: columnItensHeight,
                  child: GestureDetector(
                    onTap: () => next(),
                  ),
                )
              ],
            ),
          ),
          crossFadeState: showLayout.value,
          duration: const Duration(milliseconds: 300)),
    );
  }
}
