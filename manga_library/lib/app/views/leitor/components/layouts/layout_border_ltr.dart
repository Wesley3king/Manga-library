import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
import 'package:manga_library/app/models/globais.dart';

class LayoutBorderRTL extends StatefulWidget {
  final ValueNotifier<bool> notifier;
  final PagesController controller;
  final LeitorTypes leitorType;
  const LayoutBorderRTL(
      {super.key,
      required this.notifier,
      required this.controller,
      required this.leitorType});

  @override
  State<LayoutBorderRTL> createState() => _LayoutBorderRTLState();
}

class _LayoutBorderRTLState extends State<LayoutBorderRTL> {
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
              child: Row(
                children: [
                  Container(
                    width: rowItensWidth,
                    color: Color.fromARGB(141, 121, 23, 36),
                    child: Center(child: Text("Próximo", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        shadows: [ Shadow(
                          color: Colors.black,
                          offset: Offset.fromDirection(3),
                          blurRadius: 2.0
                        )]
                      ),),),
                  ),
                  Container(
                    width: rowItensWidth,
                    color: Colors.transparent,
                  ),
                  Container(
                    width: rowItensWidth,
                    color: Color.fromARGB(147, 82, 131, 187),
                    child: Center(child: Text("Anterior", style: TextStyle(
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
              )
            ),
          ),
          secondChild: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Row(
              children: [
                SizedBox(
                  width: rowItensWidth,
                  child: GestureDetector(
                    onTap: () => next(),
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
                    onTap: () => prev(),
                  ),
                )
              ],
            )
          ),
          crossFadeState: showLayout.value,
          duration: const Duration(milliseconds: 300)),
    );
  }
}
