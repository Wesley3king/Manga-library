import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/search_controller.dart';
import 'package:manga_library/app/views/search/search_result_list.dart';

class SearchResult extends StatefulWidget {
  final SearchController searchController;
  const SearchResult({super.key, required this.searchController});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {

  Widget _error() {
    return Center(
      child: Column(
        children: const <Widget>[
          Icon(
            Icons.report_problem,
            size: 30,
          ),
          Text('Error!')
        ],
      ),
    );
  }

  Widget _stateManagement(SearchStates state) {
    if (SearchStates.error == state) {
      return _error();
    } else {
      return SearchResultsPage(
        results: widget.searchController.result,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.searchController.state,
      builder: (context, child) =>
          _stateManagement(widget.searchController.state.value),
    );
  }
}
