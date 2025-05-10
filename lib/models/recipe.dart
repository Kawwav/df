class Receita {
  final String titulo;
  final String imagemUrl;
  final String descricao;

  Receita({
    required this.titulo,
    required this.imagemUrl,
    required this.descricao,
  });
}

class Ingredient {
  String name;
  String quantity;
  String unit;

  Ingredient({required this.name, required this.quantity, required this.unit});
}

class Recipe {
  String title;
  List<Ingredient> ingredients;

  Recipe({required this.title, required this.ingredients});
}
