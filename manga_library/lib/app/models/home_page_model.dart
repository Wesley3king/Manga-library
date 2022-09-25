// class ModelHomePage {
//   ModelHomePage({
//     required this.title,
//     required this.books,
//   });
//   late final String title;
//   late final List<ModelHomeBook> books;

//   ModelHomePage.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     books = List.from(json['books']).map((dynamic json) => ModelHomeBook.fromJson(json)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['title'] = title;
//     _data['books'] = books.map((model) => model.toJson()).toList();
//     return _data;
//   }
// }

// class ModelHomeBook {
//   ModelHomeBook({
//     required this.name,
//     required this.url,
//     required this.img,
//   });
//   late final String name;
//   late final String url;
//   late final String img;

//   ModelHomeBook.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     url = json['url'];
//     img = json['img'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['name'] = name;
//     _data['url'] = url;
//     _data['img'] = img;
//     return _data;
//   }
// }

class ModelHomePage {
  ModelHomePage({
    required this.name,
    required this.url,
    required this.img,
  });
  late final String name;
  late final String url;
  late final String img;
  
  ModelHomePage.fromJson(Map<String, dynamic> json){
    name = json['name'];
    url = json['url'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['url'] = url;
    _data['img'] = img;
    return _data;
  }
}
