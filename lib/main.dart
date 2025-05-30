import 'package:flutter/material.dart';
import 'pages/recipes_page.dart'; // Changed import path

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
      home: const RecipesPage(), // Changed to RecipesPage
    );
  }
}
