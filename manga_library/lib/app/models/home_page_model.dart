
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