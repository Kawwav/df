import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'dart:io'; // Import for File class
import '../models/recipe.dart';

class RecipeFormPage extends StatefulWidget {
  final void Function(Receita) onSalvar;
  final Receita? receita; // Optional: for editing existing recipes

  const RecipeFormPage({super.key, required this.onSalvar, this.receita});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late List<Ingredient> _ingredientes;
  File? _selectedImage; // To store the selected image file

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(
      text: widget.receita?.titulo ?? '',
    );
    _descricaoController = TextEditingController(
      text: widget.receita?.descricao ?? '',
    );
    _ingredientes = List.from(widget.receita?.ingredientes ?? []);

    // If editing and there's an image URL, try to load it as a File if it's a local path
    if (widget.receita != null && widget.receita!.imagemUrl.isNotEmpty) {
      // This assumes if it's not a network URL, it might be a local path
      // For a real app, you'd have more robust checks (e.g., starts with 'http', 'file://')
      if (!widget.receita!.imagemUrl.startsWith('http')) {
        _selectedImage = File(widget.receita!.imagemUrl);
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _adicionarIngrediente() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedItem;
        final TextEditingController quantityController =
            TextEditingController();
        final TextEditingController unitController = TextEditingController();

        final List<String> availableIngredients = [
          'Farinha de Trigo',
          'Açúcar',
          'Ovos',
          'Leite',
          'Manteiga',
          'Fermento em Pó',
          'Sal',
          'Pimenta do Reino',
          'Cebola',
          'Alho',
          'Tomate',
          'Frango',
          'Carne Bovina',
          'Macarrão',
          'Queijo Parmesão',
          'Bacon',
          'Azeite',
        ];

        return AlertDialog(
          title: const Text('Adicionar Ingrediente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedItem,
                  hint: const Text('Selecione o Ingrediente'),
                  items:
                      availableIngredients.map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                  onChanged: (value) {
                    selectedItem = value;
                    if (value == 'Farinha de Trigo' ||
                        value == 'Açúcar' ||
                        value == 'Sal' ||
                        value == 'Fermento em Pó') {
                      unitController.text = 'g';
                    } else if (value == 'Ovos') {
                      unitController.text = 'unidade(s)';
                    } else if (value == 'Leite' || value == 'Azeite') {
                      unitController.text = 'ml';
                    } else if (value == 'Manteiga' ||
                        value == 'Queijo Parmesão' ||
                        value == 'Bacon' ||
                        value == 'Frango' ||
                        value == 'Carne Bovina') {
                      unitController.text = 'g';
                    } else {
                      unitController.text = '';
                    }
                  },
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'Unidade'),
                  readOnly: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedItem != null &&
                    quantityController.text.isNotEmpty &&
                    unitController.text.isNotEmpty) {
                  setState(() {
                    _ingredientes.add(
                      Ingredient(
                        name: selectedItem!,
                        quantity: quantityController.text,
                        unit: unitController.text,
                      ),
                    );
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor, preencha todos os campos do ingrediente.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _removerIngrediente(int index) {
    setState(() {
      _ingredientes.removeAt(index);
    });
  }

  Future<void> _salvarReceita() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final titulo = _tituloController.text;
      final descricao = _descricaoController.text;
      final String imagemPath =
          _selectedImage?.path ?? ''; // Use the path of the selected image

      final String ingredientesDescricao = _ingredientes
          .map((i) => '${i.quantity} ${i.unit} ${i.name}')
          .join(', ');

      Receita novaReceita = Receita(
        id: widget.receita?.id,
        titulo: titulo,
        imagemUrl: imagemPath, // Save the image path
        descricao: descricao.isEmpty ? ingredientesDescricao : descricao,
        ingredientes: _ingredientes,
      );

      try {
        if (widget.receita == null) {
          await Future.delayed(const Duration(seconds: 1));
          novaReceita.id = 'rec_${DateTime.now().millisecondsSinceEpoch}';
          widget.onSalvar(novaReceita);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita criada com sucesso!')),
          );
        } else {
          await Future.delayed(const Duration(seconds: 1));
          widget.onSalvar(novaReceita);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita atualizada com sucesso!')),
          );
        }
        Navigator.pop(
          context,
          true,
        ); // Pass true to indicate a successful save/update
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar receita: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita == null ? "Nova Receita" : "Editar Receita"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título da Receita',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título da receita é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Imagem da Receita', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Center(
                child:
                    _selectedImage != null
                        ? Image.file(
                          _selectedImage!,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                        : (widget.receita?.imagemUrl.startsWith('http') == true
                            ? Image.network(
                              widget.receita!.imagemUrl,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 100),
                            )
                            : const Text('Nenhuma imagem selecionada')),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Selecionar Imagem'),
              ),
              const SizedBox(height: 16),
              const Text('Ingredientes', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              if (_ingredientes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Nenhum ingrediente adicionado.'),
                ),
              ..._ingredientes.asMap().entries.map((entry) {
                final index = entry.key;
                final ingrediente = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${ingrediente.quantity} ${ingrediente.unit} ${ingrediente.name}',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerIngrediente(index),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: _adicionarIngrediente,
                child: const Text('+ Adicionar Ingrediente'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarReceita,
                child: const Text('Salvar Receita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
