import 'package:flutter/material.dart';
import 'dart:io'; // Import for File class
import '../models/recipe.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final VoidCallback onVer;

  const ReceitaCard({required this.receita, required this.onVer, super.key});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (receita.imagemUrl.isNotEmpty) {
      if (receita.imagemUrl.startsWith('http')) {
        // It's a network image
        imageWidget = Image.network(
          receita.imagemUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 60),
        );
      } else {
        // It's a local file path
        final File localImageFile = File(receita.imagemUrl);
        imageWidget = Image.file(
          localImageFile,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 60),
        );
      }
    } else {
      // No image URL/path
      imageWidget = const Icon(Icons.fastfood, size: 60);
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: imageWidget,
        title: Text(receita.titulo),
        subtitle: Text(
          receita.descricao,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: ElevatedButton(onPressed: onVer, child: const Text("Ver")),
      ),
    );
  }
}
