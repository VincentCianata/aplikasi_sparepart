import 'package:aplikasi_sparepart/config.dart';

class SparePart {
  final int id;
  final String name;
  final double price;
  final bool stock;
  final String image;

  SparePart({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'] as bool,
      image: json['image_url'],
    );
  }

  String get fullImageUrl => AppConfig.baseUrl + image;
}
