import 'package:flutter/material.dart';
import 'package:multi_network_api/pages/HomePage.dart';
import 'package:multi_network_api/pages/detale_page.dart';
import 'package:multi_network_api/pages/saerch_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        SearchPage.id: (context) => SearchPage(),
        DetailPage.id: (context) => DetailPage(),
      },
    );
  }
}


