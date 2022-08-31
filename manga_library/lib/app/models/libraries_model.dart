class LibraryModel {
  LibraryModel({
    required this.library,
    required this.books,
  });
  late final String library;
  late final List<Books> books;
  
  LibraryModel.fromJson(Map<String, dynamic> json){
    library = json['library'];
    books = List.from(json['books']).map((e)=>Books.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['library'] = library;
    _data['books'] = books.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Books {
  Books({
    required this.name,
    required this.link,
    required this.img,
  });
  late final String name;
  late final String link;
  late final String img;
  
  Books.fromJson(Map<String, dynamic> json){
    name = json['name'];
    link = json['link'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['link'] = link;
    _data['img'] = img;
    return _data;
  }
}