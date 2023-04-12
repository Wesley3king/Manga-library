import '../../models/libraries_model.dart';

/// checks if it can remove the book from the database. It doesn't remove it just checks.
// bool verifyToRemoveFromDB(List<Map> list) {
//   // List<Map> lista = [
//   //   {"library": "favoritos", "selected": false},
//   //   {"library": "kkk", "selected": false},
//   //   {"library": "kkk", "selected": false},
//   //   {"library": "Finalizado", "selected": false},
//   //   {"library": "novos", "selected": false},
//   // ];
//   int deleteCount = 0;
//   for (Map map in list) {
//     if (!map["selected"]) ++deleteCount;
//   }
//   if (deleteCount == list.length) {
//     return true;
//   }
//   return false;
// }

///test to see if the book is already in the category
bool testBook(
    {required String dataLibraryName, required String categoryName, required Map<String, dynamic> book, required Books bookLibrary}) {
  return (dataLibraryName == categoryName) &&
    (bookLibrary.link == book['link']) &&
    (bookLibrary.idExtension == book['idExtension']);
}

/// remove book from library
LibraryModel removeFromLibrary(
    {required LibraryModel dataLibrary,
    required Map<String, dynamic> book}) {
  dataLibrary.books.removeWhere((element) =>
      (element.link == book['link']) &&
      element.idExtension == book['idExtension']);
  return dataLibrary;
}

/// add book to library
LibraryModel addToLibrary(
    {required LibraryModel dataLibrary,
    required Map<String, dynamic> book}) {
  dataLibrary.books.add(Books.fromJson(book));
  return dataLibrary;
}
