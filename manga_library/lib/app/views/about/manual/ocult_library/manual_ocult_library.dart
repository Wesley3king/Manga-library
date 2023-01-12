import 'package:flutter/material.dart';

class ManualOcultLibraryPage extends StatelessWidget {
  const ManualOcultLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "Biblioteca Oculta",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text(
                "A Biblioteca Oculta funciona do mesmo jeito que a biblioteca principal, mas é necessário fazer uma autenticação toda vez que dejesa entrar/alterar algo."),
            const SizedBox(height: 5),
            const Text("Para acessar a Biblioteca Oculta deve-se ir a Biblioteca principal e pressionar o botão com icone de cadeado na parte superior da tela. Agora insira a senha e clique em confirmar."),
            const Text("Caso nunca tenha acessado a Biblioteca Oculta, por padrão a senha é: 0000. tebha em mente que você pode alterar a senha nas configurações, porém não há como recupera-la, mesmo que você faça um backup ainda mantida a mesma senha para abrila", style: TextStyle(),),
            Image.asset(
              "assets/manual-imgs/ocult-library-1.png",
              width: 200,
              height: 380,
            ),
            const SizedBox(height: 5),
            const Text("Editando a Biblioteca Oculta"),
            const SizedBox(height: 5),
            const Text("O processo é o mesmo que na Biblioteca principal, porem na edição da biblioteca deve-se acessar pelo item de cadeado na parte superior da tela(no lado esquerdo do lapis)."),
            Image.asset("assets/manual-imgs/library-1.png", width: 200, height: 380,),
          ],
        ),
      ),
    );
  }
}
