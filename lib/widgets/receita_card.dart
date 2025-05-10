import 'package:flutter/material.dart';
import '../models/recipe.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final VoidCallback onVer;

  const ReceitaCard({required this.receita, required this.onVer, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          receita.imagemUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
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
