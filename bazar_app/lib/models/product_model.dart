

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {

  final String id;
  final String name;
  final String description;
  final double price;
  final double stars;
  final int stock;
  final String image;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stars,
    required this.stock,
    required this.image,
    required this.category
  });

  factory ProductModel.fromFireStore(DocumentSnapshot map) {
    final data = map.data() as Map<String, dynamic>;
    final id = map.id;
    return ProductModel(
      id: id,
      name: data['name'],
      description: data['description'],
      stock: data['stock'],
      price: data['price'].toDouble(),
      stars: data['stars'].toDouble(),
      image: data['image'],
      category: data['category']  
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stars': stars,
      'stock': stock,
      'image': image,
      'category': category
    };
  }

}