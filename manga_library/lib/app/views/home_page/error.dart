import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/home_page_controller.dart';

class ErrorHomePage extends StatelessWidget {
  const ErrorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            width: 100,
            height: 100,
            child: Icon(Icons.info),
          ),
          const Text('Error'),
          Text(HomePageController.errorMessage),
        ],
      ),
    );
  }
}