import 'package:flutter/material.dart';
import 'package:manga_library/app/my_app.dart';
import 'package:manga_library/configs/hive/hive_congig.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(const MyApp());
}
