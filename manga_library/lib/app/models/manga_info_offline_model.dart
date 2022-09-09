class MangaInfoOffLineModel {
  MangaInfoOffLineModel({
    required this.name,
    required this.description,
    required this.img,
    required this.link,
    required this.genres,
    required this.alternativeName,
    required this.chapters,
    required this.capitulos,
  });
  late final String name;
  late final String description;
  late final String img;
  late final String link;
  late final List<String> genres;
  late final dynamic alternativeName;
  late final int chapters;
  late final List<Capitulos> capitulos;
  
  MangaInfoOffLineModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    description = json['description'];
    img = json['img'];
    genres = List.castFrom<dynamic, String>(json['genres']);
    alternativeName = json['alternativeName'];
    chapters = json['chapters'];
    capitulos = List.from(json['capitulos']).map((e)=>Capitulos.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['description'] = description;
    _data['img'] = img;
    _data['genres'] = genres;
    _data['alternativeName'] = alternativeName;
    _data['chapters'] = chapters;
    _data['capitulos'] = capitulos.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Capitulos {
  Capitulos({
    required this.id,
    required this.capitulo,
    required this.download,
    required this.downloadPages,
    required this.pages,
  });
  late final int id;
  late final String capitulo;
  late final bool download;
  late final List<String> downloadPages;
  late final List<String> pages;
  
  Capitulos.fromJson(Map<String, dynamic> json){
    id = json['id'];
    capitulo = json['capitulo'];
    download = json['download'];
    downloadPages = List.castFrom<dynamic, String>(json['downloadPages']);
    pages = List.castFrom<dynamic, String>(json['pages']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['capitulo'] = capitulo;
    _data['download'] = download;
    _data['downloadPages'] = downloadPages;
    _data['pages'] = pages;
    return _data;
  }
}