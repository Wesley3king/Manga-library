import 'dart:developer';

import 'package:flutter/material.dart';

class OffLineWidget extends StatefulWidget {
  final int id;
  const OffLineWidget({super.key, required this.id});

  @override
  State<OffLineWidget> createState() => _OffLineWidgetState();
}

class _OffLineWidgetState extends State<OffLineWidget> {
  Widget download() {
    return GestureDetector(
      onTap: () {},
      child: IconButton(
        onPressed: () => log("download!"),
        icon: const Icon(Icons.download)),
    );
  }

  Widget cancel() {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 9),
            child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                )),
          ),
          IconButton(
              onPressed: () => log("download!"),
              icon: const Icon(Icons.close))
        ],
      ),
    );
  }

  Widget delete() {
    return GestureDetector(
      onTap: () {},
      child: IconButton(
        onPressed: () => log("download!"),
        icon: const Icon(Icons.delete_outline)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return download();
  }
}
