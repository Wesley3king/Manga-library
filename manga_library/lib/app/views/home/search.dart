import 'package:flutter/material.dart';
import 'package:manga_library/app/views/components/search/search_result.dart';

import '../../controllers/search_controller.dart';

final SearchController searchController = SearchController();

class SearchPage extends StatefulWidget {
  final ScrollController scrollController;
  const SearchPage({super.key, required this.scrollController});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Pesquisar'),
      actions: [
        IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MySearchDelegate()),
            icon: const Icon(Icons.search))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();//buildAppBar()
  }
}

class MySearchDelegate extends SearchDelegate {
// esta cria um widget para sair do search
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

// aqui vai a ação a ser executada como limpar o TextField
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

// aqui é onde será construido o resulatdo
  @override
  Widget buildResults(BuildContext context) {
    if (query != '') {
      searchController.search(query);
      return SearchResult(
        searchController: searchController,
      );
    } else {
      return Container();
    }
  }

// aqui construimos sugestões de pesquisa
  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
