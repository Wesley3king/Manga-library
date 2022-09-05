import 'package:manga_library/app/models/seetings_model.dart';

import 'leitor_model.dart';

class GlobalData {
  static List<ModelLeitor> capitulosDisponiveis = [];

  static bool showAdiminAtualizationBanner = false;

  static SettingsModel settingsApp = SettingsModel(data: []);
}
