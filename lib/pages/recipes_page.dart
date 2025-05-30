import 'package:flutter/material.dart';
import '../recipe.dart'; // Corrigido: importa de lib/recipe.dart
import '../widgets/widgets.dart'; // Corrigido: importa de lib/widgets/widgets.dart
import 'recipe_form_page.dart'; // Corrigido: importa de recipe_form_page.dart

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<Receita>> _futureRecipes;
  List<Receita> _allRecipes = [];
  List<Receita> _filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureRecipes = _fetchRecipes();
    _searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Simulate fetching recipes from a backend
  Future<List<Receita>> _fetchRecipes() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    final List<Receita> fetched = [
      Receita(
        id: '1',
        titulo: "Macarrão Carbonara",
        imagemUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Spaghetti_carbonara.jpg/1200px-Spaghetti_carbonara.jpg",
        descricao:
            "Um clássico italiano cremoso com ovos, queijo, guanciale e pimenta do reino.",
        ingredientes: [
          Ingredient(name: 'Macarrão', quantity: '200', unit: 'g'),
          Ingredient(name: 'Ovos', quantity: '2', unit: 'unidades'),
          Ingredient(name: 'Queijo Pecorino Romano', quantity: '50', unit: 'g'),
          Ingredient(name: 'Guanciale', quantity: '100', unit: 'g'),
          Ingredient(name: 'Pimenta do Reino', quantity: 'a gosto', unit: ''),
        ],
      ),
      Receita(
        id: '2',
        titulo: "Bolo de Laranja",
        imagemUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Bolo_de_laranja.jpg/800px-Bolo_de_laranja.jpg",
        descricao:
            "Um bolo fofinho e úmido com o sabor cítrico da laranja, perfeito para o café da tarde.",
        ingredientes: [
          Ingredient(name: 'Ovos', quantity: '3', unit: 'unidades'),
          Ingredient(name: 'Açúcar', quantity: '200', unit: 'g'),
          Ingredient(name: 'Óleo', quantity: '100', unit: 'ml'),
          Ingredient(name: 'Suco de Laranja', quantity: '150', unit: 'ml'),
          Ingredient(name: 'Farinha de Trigo', quantity: '250', unit: 'g'),
          Ingredient(
            name: 'Fermento em Pó',
            quantity: '1',
            unit: 'colher de sopa',
          ),
        ],
      ),
    ];
    setState(() {
      _allRecipes = fetched;
      _filteredRecipes = _allRecipes;
    });
    return fetched;
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes =
          _allRecipes.where((receita) {
            return receita.titulo.toLowerCase().contains(query);
          }).toList();
    });
  }

  void _navegarParaAdicionarOuEditarReceita({Receita? receita}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RecipeFormPage(
              receita: receita,
              onSalvar: (novaReceita) {
                setState(() {
                  if (novaReceita.id == null ||
                      !_allRecipes.any((r) => r.id == novaReceita.id)) {
                    _allRecipes.add(novaReceita);
                  } else {
                    final index = _allRecipes.indexWhere(
                      (r) => r.id == novaReceita.id,
                    );
                    if (index != -1) {
                      _allRecipes[index] = novaReceita;
                    }
                  }
                  _filterRecipes(); // Refiltra após adicionar/editar
                });
              },
            ),
      ),
    );

    if (result == true) {
      setState(() {
        _futureRecipes = Future.value(
          _allRecipes,
        ); // Atualiza com os dados já em memória, não precisa de novo fetch
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receitas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navegarParaAdicionarOuEditarReceita(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Pesquisar pelo nome da receita",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Receita>>(
                future: _futureRecipes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar receitas: ${snapshot.error}',
                      ),
                    );
                  } else if (!snapshot.hasData || _filteredRecipes.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma receita cadastrada."),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: _filteredRecipes.length,
                      itemBuilder: (context, index) {
                        return ReceitaCard(
                          receita: _filteredRecipes[index],
                          onVer:
                              () => _navegarParaAdicionarOuEditarReceita(
                                receita: _filteredRecipes[index],
                              ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
