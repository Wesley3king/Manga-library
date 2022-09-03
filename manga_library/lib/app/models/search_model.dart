import 'libraries_model.dart';

class SearchModel {
  SearchModel({
    required this.font,
    required this.books,
  });
  late final String font;
  late final List<Books> books;

  SearchModel.fromJson(Map<String, dynamic> json) {
    font = json['font'];
    books = json['data'].map<Books>((e) {
      Map<String, dynamic> map = {
        "name": e['nome'],
        "img": e['capa1'],
        "link": e['link'],
      };
      return Books.fromJson(map);
    }).toList();
    //List.from(json['data'])
    // .map((e) => Books.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['font'] = font;
    _data['books'] = books.map((e) => e.toJson()).toList();
    return _data;
  }
}
