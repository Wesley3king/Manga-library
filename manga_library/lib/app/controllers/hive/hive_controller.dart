import 'package:hive/hive.dart';
import 'package:manga_library/app/models/client_data_model.dart';

class HiveController {
  Box? clientData;

  void start() async {
    clientData = await Hive.openBox('clientData');
  }

  void end() {
    clientData?.close();
  }

  getClientData() {}

  writeClientData() {
    final ClientDataModel model = ClientDataModel(
      id: 1,
      name: 'King of Shadows',
      mail: 'king@mail.com',
      password: 'teste32#f',
      favoritos: [],
      capitulosLidos: [],
    );

    clientData?.put('clientAllData', model);
  }
}
