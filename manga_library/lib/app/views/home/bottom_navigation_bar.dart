import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/app/models/globais.dart';
import '../../controllers/system_config.dart';
import '../../controllers/system_navigation_and_app_bar_styles.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final ScrollController controller;
  final ValueNotifier<int> currentIndex;
  const CustomBottomNavigationBar(
      {super.key, required this.controller, required this.currentIndex});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  //late AnimationController _animation;
  // Map<int, ValueNotifier<bool>> animatedIcons = {
  //   0: ValueNotifier<bool>(false),
  //   1: ValueNotifier<bool>(false),
  //   2: ValueNotifier<bool>(false),
  //   3: ValueNotifier<bool>(false),
  // };

  @override
  void initState() {
    super.initState();
    // set UI Style
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent));
  }

  // toggle() {}

  void redirect(int route) {
    // animatedIcons[route]!.value = !animatedIcons[route]!.value;

    switch (route) {
      case 0:
        widget.currentIndex.value = 0;
        break;
      case 1:
        widget.currentIndex.value = 1;
        break;
      case 2:
        widget.currentIndex.value = 2;
        break;
      case 3:
        widget.currentIndex.value = 3;
        break;
    }

    // Future.delayed(const Duration(seconds: 2), () {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollHideWidget(
      controller: widget.controller,
      child: BottomNavigationBarTheme(
        data: BottomNavigationBarThemeData(
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(
                color: Colors.white, overflow: TextOverflow.ellipsis),
            selectedItemColor: configSystemController.colorManagement(),
            showUnselectedLabels: true),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          currentIndex: widget.currentIndex.value,
          onTap: (value) => redirect(value),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.import_contacts), // Icon(Icons.local_library)
                activeIcon: Icon(
                  Icons.import_contacts_sharp,
                ),
                label: "Biblioteca"),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: "Navegar"),
            BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz_outlined),
                activeIcon: Icon(Icons.more_horiz),
                label: "Outros")
          ],
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

  /// controla o height e os efeitos, como a rolagem e estilo do NativeBottomNavigation
  double setHeight() {
    if (GlobalData.settings['Rolar a Barra']) {
      if (isVisible) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarDividerColor: Colors.black,
          systemNavigationBarColor: Colors.transparent
          )
        );
        return (kBottomNavigationBarHeight + 48);
      } else {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarDividerColor: Colors.black26,
          systemNavigationBarColor: Colors.black26
          )
        );
        return 0;
      }
    } else {
      return (kBottomNavigationBarHeight + 48);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: setHeight(),
      child: Wrap(
        children: [widget.child],
      ),
    );
  }
}

// ANIMATED ICON

// class CustomAnimatedIcon extends StatefulWidget {
//   final String icon;
//   final ValueNotifier<bool> notifier;
//   const CustomAnimatedIcon(
//       {super.key, required this.icon, required this.notifier});

//   @override
//   State<CustomAnimatedIcon> createState() => _CustomAnimatedIconState();
// }

// class _CustomAnimatedIconState extends State<CustomAnimatedIcon>
//     with SingleTickerProviderStateMixin {
//   // ValueNotifier<bool> notifier = widget.notifier;
//   late AnimationController _animation;

//   toggle() {
//     widget.notifier.value ? _animation.forward() : _animation.reverse();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _animation = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 500));
//   }

//   @override
//   void dispose() {
//     _animation.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: widget.notifier,
//       builder: (context, value, child) {
//         toggle();
//         return SizedBox(
//           height: 30,
//           width: 30,
//           child: Lottie.asset(widget.icon,controller: _animation, animate: true, )); //AnimatedIcon(icon: widget.icon, progress: _animation);
//       },
//     );
//   }
// }
