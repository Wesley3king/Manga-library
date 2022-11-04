import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/union_mangas/repositories/fetch_services.dart';

void main() {
  test("deve retornar um json com os dados", () async {
    var data = await searchService("eleceed");
    print(data);
  });
}
