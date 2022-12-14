import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/controllers/updates/updates_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/views/routes/routes.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme:
        const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light));
ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Color.fromARGB(255, 48, 48, 48)),
      titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 48, 48, 48),
          fontWeight: FontWeight.bold,
          fontSize: 20),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Color.fromARGB(255, 48, 48, 48)),
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
    ));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeData theme = darkTheme;

  void detectTheme() {
    var brightness = WidgetsBinding.instance.window.platformBrightness;

    setState(() {
      brightness == Brightness.dark ? theme = darkTheme : theme = lightTheme;
    });
  }

  ThemeData themeSetter() {
    switch (GlobalData.settings.theme) {
      case "auto":
        ConfigSystemController.instance.isDarkTheme = theme == darkTheme;
        return theme;
      case "light":
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: Colors.black12,
            systemNavigationBarIconBrightness: Brightness.light));
        ConfigSystemController.instance.isDarkTheme = false;
        return lightTheme;
      case "dark":
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color.fromARGB(255, 27, 27, 27),
            systemNavigationBarDividerColor: Colors.black87,
            systemNavigationBarIconBrightness: Brightness.dark));
        ConfigSystemController.instance.isDarkTheme = true;
        return darkTheme;
      default:
        debugPrint("auto default");
        debugPrint(GlobalData.settings.theme);
        return theme;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    start();
    detectTheme();
  }

  void start() async {
    await FullScreenController().startScreenApp();
    UpdatesCore.verifyIfIsTimeToUpdate();
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
