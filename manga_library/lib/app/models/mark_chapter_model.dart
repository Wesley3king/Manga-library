class MarkChaptersModel {
  MarkChaptersModel({
    required this.idExtension,
    required this.link,
    required this.marks,
  });
  late final int idExtension;
  late final String link;
  late final List<String> marks;
  
  MarkChaptersModel.fromJson(Map<String, dynamic> json){
    idExtension = json['idExtension'];
    link = json['link'];
    marks = List.castFrom<dynamic, String>(json['marks']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idExtension'] = idExtension;
    data['link'] = link;
    data['marks'] = marks;
    return data;
  }
}