class ModelMangaInfo {
  ModelMangaInfo({
    required this.chapterName,
    required this.chapters,
    required this.description,
    required this.cover,
    required this.genres,
    required this.chapterList,
    required this.alternativeName,
    required this.allposts,
  });
  late final String chapterName;
  late final int chapters;
  late final String description;
  late final String cover;
  late final List<dynamic> genres;
  late final String chapterList;
  late final alternativeName;
  late final List<Allposts> allposts;

  ModelMangaInfo.fromJson(Map<String, dynamic> json) {
    chapterName = json['chapter_name'];
    chapters = json['chapters'];
    description = json['description'];
    cover = json['cover'];
    genres = List.castFrom<dynamic, String>(json['genres']);
    chapterList = json['chapter_list'];
    alternativeName = json['alternative_name'];
    allposts =
        List.from(json['allposts']).map((e) => Allposts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['chapter_name'] = chapterName;
    _data['chapters'] = chapters;
    _data['description'] = description;
    _data['cover'] = cover;
    _data['genres'] = genres;
    _data['chapter_list'] = chapterList;
    _data['alternative_name'] = alternativeName;
    _data['allposts'] = allposts.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Allposts {
  Allposts({
    required this.id,
    required this.num,
  });
  late final int id;
  late final String num;

  Allposts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['num'] = num;
    return _data;
  }
}

class ModelCapitulosCorrelacionados {
  ModelCapitulosCorrelacionados({
    required this.id,
    required this.capitulo,
    required this.disponivel,
    required this.readed,
  });
  late final int id;
  late final String capitulo;
  late final bool disponivel;
  late final bool readed;

  ModelCapitulosCorrelacionados.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    capitulo = json['num'];
    disponivel = json['disponivel'];
    readed = json['readed'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['num'] = capitulo;
    _data['disponivel'] = disponivel;
    _data['readed'] = readed;
    return _data;
  }
}
