class ExtensionModel {
  ExtensionModel({
    required this.nome,
    required this.id,
    required this.nsfw,
    required this.enable,
    required this.homePage,
    required this.mangaDetail,
    required this.search,
  });
  late final String nome;
  late final int id;
  late final bool nsfw;
  late final bool enable;
  late final dynamic homePage;
  late final dynamic mangaDetail;
  late final dynamic search;
  
  ExtensionModel.fromJson(Map<String, dynamic> json){
    nome = json['nome'];
    id = json['id'];
    nsfw = json['nsfw'];
    enable = json['enable'];
    homePage = json['homePage'];
    mangaDetail = json['mangaDetail'];
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nome'] = nome;
    _data['id'] = id;
    _data['nsfw'] = nsfw;
    _data['enable'] = enable;
    _data['homePage'] = homePage;
    _data['mangaDetail'] = mangaDetail;
    _data['search'] = search;
    return _data;
  }
}