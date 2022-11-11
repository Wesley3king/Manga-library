class DownloadPagesModel {
  DownloadPagesModel({
    required this.idExtension,
    required this.id,
    required this.chapter,
    required this.link,
    required this.img,
    required this.name,
    required this.pages,
  });
  late final int idExtension;
  late final String id;
  late final String chapter;
  late final String img;
  late final String name;
  late final String link;
  late final List<String> pages;

  DownloadPagesModel.fromJson(Map<String, dynamic> json) {
    idExtension = json['idExtension'];
    id = json['id'];
    chapter = json['chapter'];
    link = json['link'];
    img = json['img'];
    name = json['name'];
    pages = List.castFrom<dynamic, String>(json['pages']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idExtension'] = idExtension;
    data['id'] = id;
    data['chapter'] = chapter;
    data['link'] = link;
    data['img'] = img;
    data['name'] = name;
    data['pages'] = pages;
    return data;
  }
}
