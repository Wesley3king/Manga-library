import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final ScrollController controller;
  const CustomBottomNavigationBar({super.key, required this.controller});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  // ScrollController controller = widget.controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = ScrollController();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ScrollHideWidget(
      controller: widget.controller,
      child: BottomAppBar(
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconTheme(
              data: const IconThemeData(color: Colors.grey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: () => GoRouter.of(context).push('/home'), icon: const Icon(Icons.home)),
                  IconButton(
                      onPressed: () => GoRouter.of(context).push('/library'), icon: const Icon(Icons.local_library)),
                  IconButton(onPressed: () => GoRouter.of(context).push('/search'), icon: const Icon(Icons.explore)),
                  IconButton(
                      onPressed: () => GoRouter.of(context).push('/settings'), icon: const Icon(Icons.more_horiz)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScrollHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  const ScrollHideWidget(
      {super.key,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 200)});

  @override
  State<ScrollHideWidget> createState() => _ScrollHideWidgetState();
}

class _ScrollHideWidgetState extends State<ScrollHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(listen);
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: isVisible ? kBottomNavigationBarHeight : 0,
      child: Wrap(
        children: [widget.child],
      ),
    );
  }
}
