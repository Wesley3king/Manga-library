import 'package:manga_library/app/controllers/hive/hive_controller.dart';

import '../../models/libraries_model.dart';

/// check if the book is in the library
Future<bool> isInLibrary(
    {required HiveController hiveController,
    required String link,
    required int idExtension}) async {
  List<LibraryModel> dataLibrary = await hiveController.getLibraries();
  for (int categoryIndex = 0;
      categoryIndex < dataLibrary.length;
      ++categoryIndex) {
    for (int bookIndex = 0;
        bookIndex < dataLibrary[categoryIndex].books.length;
        ++bookIndex) {
      // check if they are the same book
      if ((dataLibrary[categoryIndex].books[bookIndex].link == link) &&
          (dataLibrary[categoryIndex].books[bookIndex].idExtension ==
              idExtension)) {
        return true;
      }
    }
  }
  return false;
}

/// check if the book is in the ocultLibrary
Future<bool> isInOcultLibrary(
    {required HiveController hiveController,
    required String link,
    required int idExtension}) async {
  List<LibraryModel> dataLibrary = await hiveController.getOcultLibraries();
  for (int categoryIndex = 0;
      categoryIndex < dataLibrary.length;
      ++categoryIndex) {
    for (int bookIndex = 0;
        bookIndex < dataLibrary[categoryIndex].books.length;
        ++bookIndex) {
      // check if they are the same book
      if ((dataLibrary[categoryIndex].books[bookIndex].link == link) &&
          (dataLibrary[categoryIndex].books[bookIndex].idExtension ==
              idExtension)) {
        return true;
      }
    }
  }
  return false;
}
///test to see if the book is already in the category
bool testBook(
    {required String dataLibraryName,
    required String categoryName,
    required Map<String, dynamic> book,
    required Books bookLibrary}) {
  return (dataLibraryName == categoryName) &&
      (bookLibrary.link == book['link']) &&
      (bookLibrary.idExtension == book['idExtension']);
}

/// remove book from library
LibraryModel removeFromLibrary(
    {required LibraryModel dataLibrary, required Map<String, dynamic> book}) {
  dataLibrary.books.removeWhere((element) =>
      (element.link == book['link']) &&
      element.idExtension == book['idExtension']);
  return dataLibrary;
}

/// add book to library
LibraryModel addToLibrary(
    {required LibraryModel dataLibrary, required Map<String, dynamic> book}) {
  dataLibrary.books.add(Books.fromJson(book));
  return dataLibrary;
}
