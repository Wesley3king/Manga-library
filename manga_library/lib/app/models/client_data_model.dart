// import 'package:manga_library/app/models/home_page_model.dart';

class ClientDataModel {
  ClientDataModel({
    required this.id,
    required this.name,
    required this.mail,
    required this.password,
    required this.isAdimin,
    required this.lastUpdate,
    required this.capitulosLidos,
  });
  late final int id;
  late final String name;
  late final String mail;
  late final String password;
  late final bool isAdimin;
  late final String lastUpdate;
  late final List<dynamic> capitulosLidos; //Map<String, dynamic>

  ClientDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mail = json['mail'];
    lastUpdate = json['lastUpdate'];
    password = json['password'];
    isAdimin = json['isadimin'];
    // favoritos = json['favoritos'];
    capitulosLidos = json['capitulosLidos'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mail'] = mail;
    data['lastUpdate'] = lastUpdate;
    data['password'] = password;
    data['isadimin'] = isAdimin;
    // _data['favoritos'] = favoritos;
    data['capitulosLidos'] = capitulosLidos;
    return data;
  }
}
// {
//   "name": String,
//   "link": String,
//   "capitulos": List<int>
// }
