import 'package:manga_library/app/models/globais.dart';

List<double> getSizeOfBooks() {
  String type = GlobalData.settings['Tamanho dos quadros'];
  // [X, Y]
  switch (type) {
    case "small":
      return [200.0, 245.0];
    case "normal":
      return [200.0, 260.0];
    case "big":
      return [210.0, 280.0];
    default:
      return [200.0, 260.0];
  }
}
