class ProductModel {
  final int id, price, likes;
  final String name, category, condition, tradeType, imageUrl;
  bool isFavorite;
  final DateTime createdAt;

  new({
    required this.id,
    required this.price,
    required this.likes,
    required this.name,
    required this.category,
    required this.condition,
    required this.tradeType,
    required this.imageUrl,
    required this.isFavorite,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> j) {
    return ProductModel(
      id: j['id'],
      price: j['price'],
      likes: j['likes'],
      name: j['name'],
      category: j['category'],
      condition: j['condition'],
      tradeType: j['tradeType'],
      imageUrl: j['imageUrl'],
      isFavorite: j['isFavorite'],
      createdAt: .parse(j['createdAt']),
    );
  }
}
