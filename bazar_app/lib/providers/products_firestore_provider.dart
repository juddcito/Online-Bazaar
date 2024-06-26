

import 'package:bazar_app/models/product_model.dart';
import 'package:bazar_app/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final productsProvider = StateNotifierProvider<ProductsFromFirestoreProvider, List<ProductModel>>((ref) {
  final firestoreService = ref.watch(fromFireStoreProvider);
  return ProductsFromFirestoreProvider(firestoreService: firestoreService);
});

class ProductsFromFirestoreProvider extends StateNotifier<List<ProductModel>> {

  FirestoreService firestoreService;

  ProductsFromFirestoreProvider({
    required this.firestoreService
  }) : super([]);

  late DocumentSnapshot _lastDocument;

  //* get 10 products from firestore
  Future<List<ProductModel>> getProducts() async {
    try {
      final productsCollection = await firestoreService.getProducts();
      _lastDocument = productsCollection.docs.last;
      final List<ProductModel> productsList = productsCollection.docs.map((doc) => ProductModel.fromFireStore(doc)).toList();
      state = productsList;
    } catch (e) {
      print('Ocurrió un error: $e');
      rethrow;
    }
    return state;    
  }

  //* get next 10 products from firestore
  Future<void> getNextProducts() async {
    try {
      final productsCollection = await firestoreService.getProducts(lastDocument: _lastDocument);
      _lastDocument = productsCollection.docs.last;
      final List<ProductModel> productsList = productsCollection.docs.map((doc) => ProductModel.fromFireStore(doc)).toList();
      state = [...state, ...productsList];
    } catch (e) {
      rethrow;
    }
  }


}