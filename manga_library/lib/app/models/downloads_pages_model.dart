class DownloadPagesModel {
  DownloadPagesModel({
    required this.idExtension,
    required this.id,
    required this.link,
    required this.pages,
  });
  late final int idExtension;
  late final String id;
  late final String link;
  late final List<String> pages;
  
  DownloadPagesModel.fromJson(Map<String, dynamic> json){
    idExtension = json['idExtension'];
    id = json['id'];
    link = json['link'];
    pages = List.castFrom<dynamic, String>(json['pages']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idExtension'] = idExtension;
    data['id'] = id;
    data['link'] = link;
    data['pages'] = pages;
    return data;
  }
}