
// import '../../../models/libraries_model.dart';

// class OrdenateLibrary {
//   final String letters = "0123456789abcdefghijklmnopqrstuvwxyz";
//   Future<List<LibraryModel>> reverse(List<LibraryModel> models) async {
//     for (int i = 0; i < models.length; ++i) {
//       models[i].books = models[i].books.reversed.toList();
//     }
//     return models;
//   }

//   Future<List<LibraryModel>> toAZ(List<LibraryModel> models) async {
//     // MODELS
//     for (int i = 0; i < models.length; ++i) {
//       List<Books> allBooks = models[i].books;
//       List<Books> books = [];
//       List<Map<String, dynamic>> removeLinks = [];
//       // LETTERS
//       for (int letterIndex = 0; letterIndex < letters.length; ++letterIndex) {
//         String letter = letters[letterIndex];
//         // bool added = false;
//         // BOOKS
//         for (int bookIndex = 0; bookIndex < allBooks.length; ++bookIndex) {
//           // debugPrint("teste: ${allBooks[bookIndex].name.startsWith(letter)}");
//           RegExp regex = RegExp(letter, caseSensitive: false);
//           if (allBooks[bookIndex].name.startsWith(regex, 0)) {
//             books.add(allBooks[bookIndex]);
//             removeLinks.add({
//               "link": allBooks[bookIndex].link,
//               "idExtension": allBooks[bookIndex].idExtension
//             });
//             // break;
//           }
//         }
//         // remove estes livros, depois limpa a lista de remoção
//         for (Map<String, dynamic> map in removeLinks) {
//           allBooks.removeWhere((book) => (book.link == map['link']) && (book.idExtension == map['idExtension']));
//         }
//         removeLinks.clear();
//       }
//       books.addAll(allBooks);
//       models[i].books = books;
//     }
//     return models;
//   }
// }