class LibraryModel {
  LibraryModel({
    required this.library,
    required this.books,
  });
  late String library;
  late final List<Books> books;

  LibraryModel.fromJson(Map<String, dynamic> json) {
    library = json['library'];
    // print("======list of books");
    // print('${json['books']}');
    books = List.from(json['books']).map((e) => Books.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['library'] = library;
    _data['books'] = books.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Books {
  Books({
    required this.name,
    required this.link,
    required this.img,
    required this.idExtension,
  });
  late final String name;
  late final String link;
  late final String img;
  late final int idExtension;

  Books.fromJson(Map<dynamic, dynamic> json) {
    // print("=========================================== books");
    // print(json);
    name = json['name'];
    link = json['link'];
    img = json['img'];
    idExtension = json['idExtension'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['link'] = link;
    _data['img'] = img;
    _data['idExtension'] = idExtension;
    return _data;
  }
}
