import 'package:flutter/material.dart';

class ManualLibraryPage extends StatelessWidget {
  const ManualLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "Biblioteca",
          style: TextStyle(
            fontSize: 20
          ),
        ),
        Divider(),
        Text("A Biblioteca armazena seus livros favoritos, e separa-os por Categorias que você mesmo cria."),
        Image.asset("assets/manual-imgs/library-3.png"),
        SizedBox(height: 10),
        Text("Criando, editando e deletando uma Categoria"),
        SizedBox(height: 5),
        Text("A edição de Categorias está em: Outros > Biblioteca."),
        Text("Para criar uma Categoria, clique no botão com o icone +, em seguida digite o nome da categoria e clique em Adicionar"),
        Image.asset("assets/manual-imgs/library-1.png"),
        Text(""),
        Image.asset("assets/manual-imgs/library-2.png"),
      ],
    );
  }
}