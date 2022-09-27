import 'libraries_model.dart';

class SearchModel {
  SearchModel(
      {required this.font, required this.books, required this.idExtension});
  late final String font;
  late final int idExtension;
  late final List<Books> books;

  SearchModel.fromJson(Map<String, dynamic> json) {
    font = json['font'];
    // print("pt 1");
    // print(json);
    idExtension = json['idExtension'];
    // print("pt 2");
    books = json['data'].map<Books>((e) {
      print(e);
      Map<String, dynamic> map = {
        "name": e['nome'],
        "img": e['capa1'],
        "link": e['link'],
        "idExtension": idExtension
      };
      return Books.fromJson(map);
    }).toList();
    // print("pt 3");
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['font'] = font;
    data['idExtension'] = idExtension;
    data['books'] = books.map((e) => e.toJson()).toList();
    return data;
  }
}
