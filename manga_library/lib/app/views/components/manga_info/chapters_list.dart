// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../../models/manga_info_offline_model.dart';
// import 'off_line/off_line_widget.dart';

// class MyChaptersListSucess extends StatelessWidget {
//   final List<Capitulos> capitulos;
//   final String link;
//   final Map<String, Function> metodos;
//   const MyChaptersListSucess({super.key, required this.link, required this.capitulos, required this.metodos});
//   // colors
//   final TextStyle indisponivel = const TextStyle(color: Colors.red);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: capitulos.length,
//       itemBuilder: (context, index) {
//         final Capitulos capitulo = capitulos[index];
//           late dynamic id;
//           try {
//             id = int.parse(capitulo.id);
//           } catch (e) {
//             //print("não é um numero!");
//             id = capitulo.id.split("-my");
//             id = id[1];
//             id.toString().replaceAll("/", "");
//             //id.replaceAll("/", "");
//           }
//           // print(capitulo.readed ? "true" : "false");
//           // print(capitulo.disponivel ? " d - true" : "d - false");
//           return ListTile(
//             title: Text(
//               'Capitulo ${capitulo.capitulo}',
//               style: capitulo.disponivel ? const TextStyle() : indisponivel,
//             ),
//             subtitle: Text(capitulo.readed ? "lido" : "não lido"),
//             leading: capitulo.readed
//                 ? metodos['lido']!(capitulo.id.toString(), link)
//                 : metodos['naoLido']!(capitulo.id.toString(), link),
//             trailing: OffLineWidget(
//               capitulo: capitulo,
//               model: ,
//             ),
//             onTap: () => GoRouter.of(context).push('/leitor/$link/$id'),
//           );
//       } ,);
//   }
// }
