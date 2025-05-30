class Receita {
  String? id; // Adicionado para edição
  String titulo;
  String imagemUrl;
  String descricao;
  List<Ingredient> ingredientes;

  Receita({
    this.id,
    required this.titulo,
    this.imagemUrl = '',
    required this.descricao,
    this.ingredientes = const [],
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'],
      titulo: json['titulo'],
      imagemUrl: json['imagemUrl'] ?? '',
      descricao: json['descricao'],
      ingredientes:
          (json['ingredientes'] as List<dynamic>?)
              ?.map((i) => Ingredient.fromJson(i))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'imagemUrl': imagemUrl,
      'descricao': descricao,
      'ingredientes': ingredientes.map((i) => i.toJson()).toList(),
    };
  }
}

class Ingredient {
  String name;
  String quantity;
  String unit;

  Ingredient({required this.name, required this.quantity, required this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'unit': unit};
  }
}
