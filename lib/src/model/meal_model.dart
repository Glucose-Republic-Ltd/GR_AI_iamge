class FoodItem {
  final String name;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
  final double servingSize;
  final double sugar;

  FoodItem({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.servingSize,
    required this.sugar,
  });

  factory FoodItem.fromJson(String name, Map<String, dynamic> json) {
    return FoodItem(
      name: name,
      calories: json['calories'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      protein: json['protein'].toDouble(),
      servingSize: json['serving_size(g)'].toDouble(),
      sugar: json['sugar'].toDouble(),
    );
  }
}