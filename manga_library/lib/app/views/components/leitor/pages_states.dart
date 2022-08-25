import 'package:flutter/material.dart';

class PagesStates {
  Widget _loading() {
    return const SizedBox(
      width: double.infinity,
      height: 350,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _error(String src) {
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.info),
            const SizedBox(
              height: 10,
            ),
            const Text('Error!'),
            Text('image: $src')
          ],
        ),
      ),
    );
  }

  Widget page(String src) {
    return IntrinsicHeight(
      child: Image.network(
        src,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            // aqui já esta carregada
            return child;
          }
          return _loading();
        },
        errorBuilder: (context, error, stackTrace) => _error(src),
      ),
    );
  }

  Widget listPages() {
    return ListView(
      children: [],
    );
  }

  AnimatedBuilder pages(Listenable state) {
    return AnimatedBuilder(
      animation: state,
      builder: ((context, child) => listPages()),
    );
  }
}
