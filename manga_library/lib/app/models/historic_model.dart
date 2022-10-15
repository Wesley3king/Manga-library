class HistoricModel {
  late final String name;
  late final String img;
  late final String link;
  late final int idExtension;
  late String date;
  late String chapter;

  HistoricModel({required this.name, required this.img, required this.link, required this.date, required this.chapter,
      required this.idExtension});

  HistoricModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
    link = json['link'];
    idExtension = json['idExtension'];
    date = json['date'];
    chapter = json['chapter'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['img'] = img;
    data['link'] = link;
    data['idExtension'] = idExtension;
    data['date'] = date;
    data['chapter'] = chapter;
    return data;
  }
}
