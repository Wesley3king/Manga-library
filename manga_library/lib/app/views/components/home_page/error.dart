import 'package:flutter/material.dart';

class ErrorHomePage extends StatelessWidget {
  const ErrorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const <Widget>[
          SizedBox(
            width: 100,
            height: 100,
            child: Icon(Icons.info),
          ),
          Text('Error'),
        ],
      ),
    );
  }
}