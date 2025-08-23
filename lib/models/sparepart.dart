import 'package:aplikasi_sparepart/config.dart';

class SparePart {
  final int id;
  final String name;
  final double price;
  final bool stock;
  final String image;
  final String description;
  final String category;

  SparePart({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.image,
    required this.description,
    required this.category,
  });

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'] as bool,
      image: json['image_url'],
      description: json['description'].toString(),
      category: json['category'].toString(),
    );
  }

  String get fullImageUrl => AppConfig.baseUrl + image;
}
