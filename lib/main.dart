import 'package:flutter/material.dart';
import 'pages/receitas_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReceitasPage(),
    );
  }
}
