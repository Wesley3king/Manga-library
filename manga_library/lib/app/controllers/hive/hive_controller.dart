import 'package:hive/hive.dart';
import 'package:manga_library/app/adapters/client_data_model_adapter.dart';
import 'package:manga_library/app/models/client_data_model.dart';

class HiveController {
  static Box? clientData;

  Future<void> start() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ClientDataModelHiveAdapter());
    }
    clientData = await Hive.openBox('clientData');
  }

  void end() {
    clientData?.close();
  }

  Future<dynamic> getClientData() async {
    try {
      ClientDataModel? data = await clientData?.get('clientAllData');
      if (data == null) {
        writeClientData();
        return ClientDataModel(
          id: 1,
          name: 'King of Shadows',
          mail: 'king@mail.com',
          password: 'teste32#f',
          favoritos: [],
          capitulosLidos: [],
        );
      } else {
        return data;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void writeClientData() {
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

  Future<bool> updateClientData(ClientDataModel data) async {
    try {
      await clientData?.put('clientAllData', data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
