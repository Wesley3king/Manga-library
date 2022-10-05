class ModelHomePage {
  ModelHomePage(
      {required this.title, required this.books, required this.idExtension});
  late final String title;
  late final int idExtension;
  late final List<ModelHomeBook> books;

  ModelHomePage.fromJson(Map<String, dynamic> json) {
    // print("start");
    title = json['title'];
    idExtension = json['idExtension'];
    // print("okkk");
    books = List.from(json['books'])
        .map((dynamic json) =>
            ModelHomeBook.fromJson({...json, "idExtension": idExtension}))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['idExtension'] = idExtension;
    _data['books'] = books.map((model) => model.toJson()).toList();
    return _data;
  }
}

class ModelHomeBook {
  ModelHomeBook(
      {required this.name,
      required this.url,
      required this.img,
      required this.idExtension});
  late final String name;
  late final String url;
  late final String img;
  late final int idExtension;

  ModelHomeBook.fromJson(Map<String, dynamic> json) {
  //  print("home: $json");
    name = json['name'];
    url = json['url'];
    img = json['img'];
    idExtension = json['idExtension'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['img'] = img;
    data['idExtension'] = idExtension;
    return data;
  }
}

// class ModelHomePage {
//   ModelHomePage({
//     required this.name,
//     required this.url,
//     required this.img,
//   });
//   late final String name;
//   late final String url;
//   late final String img;
  
//   ModelHomePage.fromJson(Map<String, dynamic> json){
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
