import 'package:pocket_market_module_a/models/product_model.dart';

class DetailModel extends ProductModel {
  final String description, barcode, conditionLabel, tradeTypeLabel;
  final Map<String, dynamic> seller;

  new({
    required super.id,
    required super.price,
    required super.likes,
    required super.name,
    required super.category,
    required super.condition,
    required super.tradeType,
    required super.imageUrl,
    required super.isFavorite,
    required super.createdAt,
    required this.barcode,
    required this.conditionLabel,
    required this.description,
    required this.seller,
    required this.tradeTypeLabel,
  });

  factory DetailModel.fromJson(Map<String, dynamic> j) {
    return DetailModel(
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
      barcode: j['barcode'],
      conditionLabel: j['conditionLabel'],
      description: j['description'],
      seller: Map.from(j['seller']),
      tradeTypeLabel: j['tradeTypeLabel'],
    );
  }
}
