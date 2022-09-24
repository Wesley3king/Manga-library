import 'package:hive/hive.dart';
import 'package:manga_library/app/models/client_data_model.dart';

class ClientDataModelHiveAdapter extends TypeAdapter<ClientDataModel> {
  @override
  int get typeId => 0;

  @override
  ClientDataModel read(BinaryReader reader) {
    return ClientDataModel(
      id: reader.readInt(),
      name: reader.readString(),
      mail: reader.readString(),
      password: reader.readString(),
      isAdimin: reader.readBool(),
      // favoritos: reader.readList(),
      capitulosLidos: reader.readList(),
    );
  }

  @override
  void write(BinaryWriter writer, ClientDataModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.mail);
    writer.writeString(obj.password);
    writer.writeBool(obj.isAdimin);
    // writer.writeList(obj.favoritos);
    writer.writeList(obj.capitulosLidos);
  }
}
