import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/views/routes/routes.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final SystemController systemController = SystemController();
  ThemeData theme = darkTheme;

  void detectTheme() {
    var brightness = WidgetsBinding.instance.window.platformBrightness;

    setState(() {
      brightness == Brightness.dark ? theme = darkTheme : theme = lightTheme;
    });
  }

  ThemeData themeSetter() {
    switch (GlobalData.settings["Tema"]) {
      case "auto":
        print("theme automatic");
        return theme;
      case "light":
        return lightTheme;
      case "dark":
        return darkTheme;
      default:
        print("auto default");
        print(GlobalData.settings["Tema"]);
        return theme;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    detectTheme();
    systemController.start();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    detectTheme();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ConfigSystemController.instance,
      builder: (context, child) => MaterialApp.router(
        theme: themeSetter(),
        debugShowCheckedModeBanner: false,
        routerDelegate: routes.routerDelegate,
        routeInformationParser: routes.routeInformationParser,
        routeInformationProvider: routes.routeInformationProvider,
      ),
    );
  }
}
