
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
  
  ModelMangaInfo.fromJson(Map<String, dynamic> json){
    chapterName = json['chapter_name'];
    chapters = json['chapters'];
    description = json['description'];
    cover = json['cover'];
    genres = List.castFrom<dynamic, String>(json['genres']);
    chapterList = json['chapter_list'];
    alternativeName = json['alternative_name'];
    allposts = List.from(json['allposts']).map((e)=>Allposts.fromJson(e)).toList();
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
    _data['allposts'] = allposts.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Allposts {
  Allposts({
    required this.id,
    required this.num,
    required this.date,
    required this.scan,
    required this.scanuri,
  });
  late final int id;
  late final String num;
  late final String date;
  late final String scan;
  late final String scanuri;
  
  Allposts.fromJson(Map<String, dynamic> json){
    id = json['id'];
    num = json['num'];
    date = json['date'];
    scan = json['scan'];
    scanuri = json['scanuri'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['num'] = num;
    _data['date'] = date;
    _data['scan'] = scan;
    _data['scanuri'] = scanuri;
    return _data;
  }
}