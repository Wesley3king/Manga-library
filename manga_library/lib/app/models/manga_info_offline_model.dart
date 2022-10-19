class MangaInfoOffLineModel {
  MangaInfoOffLineModel({
    required this.name,
    required this.authors,
    required this.state,
    required this.description,
    required this.img,
    required this.link,
    required this.idExtension,
    required this.genres,
    required this.alternativeName,
    required this.chapters,
    required this.capitulos,
  });
  late final String name;
  late final String authors;
  late final String description;
  late final String state;
  late final String img;
  late final String link;
  late final int idExtension;
  late final List<String> genres;
  late final dynamic alternativeName;
  late final int chapters;
  late List<Capitulos> capitulos;

  MangaInfoOffLineModel.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    authors = json['authors'];
    state = json['state'];
    description = json['description'];
    img = json['img'];
    link = json['link'];
    idExtension = json['idExtension'];
    genres = List.castFrom<dynamic, String>(json['genres']);
    alternativeName = json['alternativeName'];
    chapters = json['chapters'];
    capitulos = List.from(json['capitulos'])
        .map((e) => Capitulos.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['authors'] = authors;
    data['state'] = state;
    data['description'] = description;
    data['img'] = img;
    data['link'] = link;
    data['idExtension'] = idExtension;
    data['genres'] = genres;
    data['alternativeName'] = alternativeName;
    data['chapters'] = chapters;
    data['capitulos'] = capitulos.map((e) => e.toJson()).toList();
    return data;
  }
}

class Capitulos {
  Capitulos({
    required this.id,
    required this.capitulo,
    required this.description,
    required this.download,
    required this.readed,
    required this.disponivel,
    required this.downloadPages,
    required this.pages,
  });
  late final dynamic id;
  late final String capitulo;
  late String description;
  late bool download;
  late bool readed;
  late bool disponivel;
  late List<String> downloadPages;
  late List<String> pages;

  Capitulos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    capitulo = json['capitulo'];
    description = json['description'];
    download = json['download'];
    disponivel = json['disponivel'];
    readed = json['readed'];
    downloadPages = List.castFrom<dynamic, String>(json['downloadPages']);
    pages = List.castFrom<dynamic, String>(json['pages'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['capitulo'] = capitulo;
    data['description'] = description;
    data['download'] = download;
    data['disponivel'] = disponivel;
    data['readed'] = readed;
    data['downloadPages'] = downloadPages;
    data['pages'] = pages;
    return data;
  }
}
