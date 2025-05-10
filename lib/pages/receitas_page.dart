import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/receita_card.dart';
import 'adicionar_receita_page.dart';

class ReceitasPage extends StatefulWidget {
  const ReceitasPage({super.key});

  @override
  State<ReceitasPage> createState() => _ReceitasPageState();
}

class _ReceitasPageState extends State<ReceitasPage> {
  final List<Receita> _receitas = [
    Receita(
      titulo: "Macarrão Carbonara",
      imagemUrl: "https://example.com/carbonara.jpg",
      descricao: "Bacon picado, queijo ralado, ovo, sal, pimenta-do-reino...",
    ),
    Receita(
      titulo: "Bolo de Laranja",
      imagemUrl: "https://example.com/bolo.jpg",
      descricao: "Ovos, açúcar, óleo, suco de laranja, farinha, fermento...",
    ),
  ];

  void _navegarParaAdicionarReceita() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AdicionarReceitaPage(
              onSalvar: (novaReceita) {
                setState(() {
                  _receitas.add(novaReceita);
                });
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receitas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navegarParaAdicionarReceita,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Pesquisar",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _receitas.length,
                itemBuilder: (context, index) {
                  return ReceitaCard(receita: _receitas[index], onVer: () {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
