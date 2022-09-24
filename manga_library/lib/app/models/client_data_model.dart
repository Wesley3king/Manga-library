// import 'package:manga_library/app/models/home_page_model.dart';

class ClientDataModel {
  ClientDataModel({
    required this.id,
    required this.name,
    required this.mail,
    required this.password,
    required this.isAdimin,
    required this.capitulosLidos,
  });
  late final int id;
  late final String name;
  late final String mail;
  late final String password;
  late final bool isAdimin;
  late final List<dynamic> capitulosLidos; //Map<String, dynamic>

  ClientDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mail = json['mail'];
    password = json['password'];
    isAdimin = json['isadimin'];
    // favoritos = json['favoritos'];
    capitulosLidos = json['capitulosLidos'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['mail'] = mail;
    _data['password'] = password;
    _data['isadimin'] = isAdimin;
    // _data['favoritos'] = favoritos;
    _data['capitulosLidos'] = capitulosLidos;
    return _data;
  }
}
// {
//   "name": String,
//   "link": String,
//   "capitulos": List<int>
// }
