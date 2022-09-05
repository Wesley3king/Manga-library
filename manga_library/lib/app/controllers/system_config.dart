import 'package:manga_library/app/controllers/hive/hive_controller.dart';

import '../models/globais.dart';

class SystemController {
  final HiveController _hiveController = HiveController();
  Future start() async {
    // inicializar o Hive
    await _hiveController.start();
    Map<String, dynamic> data = await _hiveController.getSettings();
    GlobalData.settings = data;
  }
}
