class ModelLeitor {
  ModelLeitor({
    required this.capitulo,
    required this.id,
    required this.pages,
  });
  late final dynamic id;
  late final String capitulo;
  late final dynamic pages;

  ModelLeitor.fromJson(List<dynamic> lista) {
    try {
      // print("lista: ${lista[1]}");
      List<String> corte = lista[0].split('#');
      try {
        id = lista[1];
      } catch (e) {
        print('erro id');
      }

      try {
        capitulo = corte[1];
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
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['num'] = capitulo;
    _data['pages'] = pages;
    return _data;
  }
}
