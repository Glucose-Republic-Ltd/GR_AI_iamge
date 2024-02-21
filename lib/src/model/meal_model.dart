class FoodItem {
  final String name;
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final int servingSize;
  final int sugar;

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
      calories: json['calories'],
      carbs: json['carbs'],
      fat: json['fat'],
      protein: json['protein'],
      servingSize: json['serving_size(g)'],
      sugar: json['sugar'],
    );
  }
}