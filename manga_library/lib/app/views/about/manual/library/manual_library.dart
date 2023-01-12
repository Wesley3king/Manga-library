import 'package:flutter/material.dart';

class ManualLibraryPage extends StatelessWidget {
  const ManualLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Biblioteca",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            const Divider(),
            const Text("A Biblioteca armazena seus livros favoritos, e separa-os por Categorias que você mesmo cria."),
            const SizedBox(height: 5),
            Image.asset("assets/manual-imgs/library-3.png", width: 200, height: 380,),
            const SizedBox(height: 10),
            const Text("> Criando, editando e deletando uma Categoria",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),),
            const SizedBox(height: 8),
            const Text("A edição de Categorias(da biblioteca) localizada em: Outros > Biblioteca."),
            const Text("Para criar uma Categoria, clique no botão com o icone +, em seguida digite o nome da categoria e clique em Adicionar"),
            const Text("Você pode alterar a ordem das categorias pressionando seu nome e movendo-o, para salvar a ordem clique no icone de lista."),
            const SizedBox(height: 5),
            Image.asset("assets/manual-imgs/library-1.png", width: 200, height: 380,),
            const SizedBox(height: 10),
            const Text("Para renomear ou deletar uma Categoria clique no icone de lapis, aparecera uma lista com as Categorias, pressionando no icone lateral de uma categoria aparecera as opções renomear e deletar."),
            const SizedBox(height: 5),
            Image.asset("assets/manual-imgs/library-2.png", width: 200, height: 250,),
            const Text("> Adicionando Mangás/novels a Biblioteca",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),),
            const SizedBox(height: 8),
            const Text("Você deve buscar pelos seus livros favoritos na opção Navegar. ao acha-lo em uma extensão clique na opção adicionar a biblioteca."),
            Image.asset("assets/manual-imgs/library-4.png", width: 200, height: 380,),
            const Text("Assim será exibida uma tela com as categorias existentes. você pode adicionar um mesmo livro a quantas categorias quiser.")
          ],
        ),
      ),
    );
  }
}