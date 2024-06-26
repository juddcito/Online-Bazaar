

import 'package:bazar_app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fromFireStoreProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {

  // get collection of products
  final CollectionReference products = FirebaseFirestore.instance.collection('products');

  // add product to database
  Future<void> addProduct(ProductModel product) async {
    try {
      await products.add(product.toMap());
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  // read products from database
  Future<QuerySnapshot<Object?>> getProducts({DocumentSnapshot? lastDocument}) async {

    Query productsQuery = products.orderBy('name', descending: true);

    if (lastDocument != null ) {
      productsQuery = productsQuery.startAfterDocument(lastDocument);
    }

    final QuerySnapshot querySnapshot = await productsQuery.get();
    return querySnapshot;

  }

  Future<ProductModel> getProductById(String productId) async {

    try {

      DocumentSnapshot document = await products.doc(productId).get();

      if (document.exists) {
        return ProductModel.fromFireStore(document);
      } else {
        throw Exception('Product not found');
      }

    } catch (e) {
      throw Exception('Error getting product: $e');
    }

  }
}