import 'package:flutter/material.dart';
import 'package:manga_library/app/views/home_page.dart';

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
  ThemeData theme = darkTheme;

  void detectTheme() {
    var brightness = WidgetsBinding.instance.window.platformBrightness;

    setState(() {
      brightness == Brightness.dark ? theme = darkTheme : theme = lightTheme;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    detectTheme();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    detectTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
