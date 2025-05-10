import 'package:flutter/material.dart';
import '../models/recipe.dart';

class AdicionarReceitaPage extends StatefulWidget {
  final void Function(Receita) onSalvar;

  const AdicionarReceitaPage({super.key, required this.onSalvar});

  @override
  State<AdicionarReceitaPage> createState() => _AdicionarReceitaPageState();
}

class _AdicionarReceitaPageState extends State<AdicionarReceitaPage> {
  final _tituloController = TextEditingController();
  final _imagemController = TextEditingController();
  final List<Ingredient> _ingredientes = [];

  void _adicionarIngrediente() {
    setState(() {
      _ingredientes.add(Ingredient(name: '', quantity: '', unit: ''));
    });
  }

  void _salvarReceita() {
    final titulo = _tituloController.text;
    final imagem = _imagemController.text;
    final descricao = _ingredientes
        .map((i) => '${i.quantity} ${i.unit} ${i.name}')
        .join(', ');

    final novaReceita = Receita(
      titulo: titulo,
      imagemUrl: imagem,
      descricao: descricao,
    );

    widget.onSalvar(novaReceita);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Receita")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título da Receita'),
            ),
            TextField(
              controller: _imagemController,
              decoration: const InputDecoration(labelText: 'URL da Imagem'),
            ),
            const SizedBox(height: 16),
            const Text('Ingredientes', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ..._ingredientes.map((ingrediente) {
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Nome'),
                      onChanged: (value) => ingrediente.name = value,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Qtd'),
                      onChanged: (value) => ingrediente.quantity = value,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Unidade'),
                      onChanged: (value) => ingrediente.unit = value,
                    ),
                  ),
                ],
              );
            }),
            TextButton(
              onPressed: _adicionarIngrediente,
              child: const Text('+ Adicionar Ingrediente'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarReceita,
              child: const Text('Salvar Receita'),
            ),
          ],
        ),
      ),
    );
  }
}
