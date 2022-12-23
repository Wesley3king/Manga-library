class LibraryModel {
  LibraryModel({
    required this.library,
    required this.books,
  });
  late String library;
  late List<Books> books;

  LibraryModel.fromJson(Map<String, dynamic> json) {
    library = json['library'];
    // print("======list of books");
    // print('${json['books']}');
    books = List.from(json['books']).map((e) => Books.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['library'] = library;
    data['books'] = books.map((e) => e.toJson()).toList();
    return data;
  }
}

class Books {
  Books({
    required this.name,
    required this.link,
    this.img = "",
    this.restantChapters = 0,
    required this.idExtension,
  });
  late String name;
  late final String link;
  late String img;
  late int restantChapters;
  late final int idExtension;

  Books.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'] ?? "";
    link = json['link'];
    img = json['img'] ?? "";
    restantChapters = json['restantChapters'] ?? 0;
    idExtension = json['idExtension'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['name'] = name;
    data['link'] = link;
    // data['img'] = img;
    data['idExtension'] = idExtension;
    return data;
  }
}
