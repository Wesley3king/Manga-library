class ModelLeitor {
  ModelLeitor({
    required this.capitulo,
    required this.id,
    required this.pages,
  });
  late final int id;
  late final num capitulo;
  late final dynamic pages;

  ModelLeitor.fromJson(List<dynamic> lista) {
    try {
      List<String> corte = lista[0].split('#');
      try {
        id = int.parse(lista[1]);
      } catch (e) {
        print('erro id');
      }

      try {
        capitulo = num.parse(corte[1]);
      } catch (e) {
        print('erro capitulo');
      }
      try {
        pages = lista[4];
      } catch (e) {
        print('here');
      }
    } catch (e) {
      print('erro aqui! $e');
    }
    print('feito sem Erro!');
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['num'] = capitulo;
    _data['pages'] = pages;
    return _data;
  }
}
