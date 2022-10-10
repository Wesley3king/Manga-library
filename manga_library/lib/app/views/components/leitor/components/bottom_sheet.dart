import 'package:flutter/material.dart';

customBottomSheetForLeitor(
    BuildContext context, AnimationController animationController) {
  // AnimationController animationController = AnimationController(vsync: vsync)
  const double radiusBottomSheet = 30.0;
  const double radiusContent = 40.0;
  return showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusBottomSheet),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: 500,
          decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radiusBottomSheet),
                  topRight: Radius.circular(radiusBottomSheet))),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Container(
              height: 460,
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radiusContent),
                      topRight: Radius.circular(radiusContent))),
              // decoration: BoxDecoration(shape: BoxShape),
            ),
          )));
}
/*
BottomSheet(
      onClosing: () {},
      animationController: animationController,
      constraints: const BoxConstraints(
        maxHeight: 600,
        minWidth: 400
      ),
      builder: (context) => Container(
        height: 500,
        color: Colors.orange,
        child: Container(
          height: 460,
          color: Colors.green,
          // decoration: BoxDecoration(shape: BoxShape),
        ),
      ),
    ),
  )
*/