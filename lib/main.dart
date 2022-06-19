import 'package:clnapp/views/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CLNApp());
}

class CLNApp extends StatelessWidget {
  const CLNApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CLN App',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
