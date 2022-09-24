import 'package:manga_library/app/controllers/hive/hive_controller.dart';

class BackupCore {
  /// cria um backup
  static createBackup() async {
    final HiveController hiveController = HiveController();

    Map<String, dynamic> backupData = {
      "clientData" : await hiveController.getClientData(),
      "libraries" : await hiveController.getLibraries(),
      "settings": await hiveController.getSettings(),
      "books": await hiveController.getBooks()
    };
  }

  static readBackup() async {}
}
