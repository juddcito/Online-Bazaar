

import 'package:bazar_app/models/product_model.dart';
import 'package:bazar_app/providers/products_firestore_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {

  final String searchQuery;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery
  });

  @override
  SearchResultsScreenState createState() => SearchResultsScreenState();
}

class SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {

  TextEditingController searchController = TextEditingController();
  List<ProductModel> products = [];
  Map<String, List<ProductModel>> categories = {};
  bool isSelectedCategory = false;
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();       
    searchController.addListener(onSearchChanged);
    searchController.text = widget.searchQuery;
    initializeProducts();
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();    
    super.dispose();
  }

  void initializeProducts() async {
    await getProductsFromProvider();
    await getCategories();
  }

  Future<void> getProductsFromProvider() async {
    await ref.read(productsProvider.notifier).getProducts();
    final products = ref.read(productsProvider);
    setState(() {
      this.products = products;
    });
    await searchProducts();
  }

  Future<void> getCategories() async {

    categories.clear();

    for (var product in products) {
      if (!categories.containsKey(product.category)) {
        categories[product.category] = [];
      }
      categories[product.category]!.add(product);      
    }

    setState(() {
        categories = categories;
    });

  } 

  Future<void> searchProducts() async {

    List<ProductModel> filteredProducts = [];

    if (searchController.text.isNotEmpty) {
      final products = ref.read(productsProvider);
      filteredProducts = products.where((product) {
        final productName = product.name.toLowerCase();
        final category = product.category.toLowerCase();
        final searchQuery = searchController.text.toLowerCase();
        return ((productName.contains(searchQuery) || category.contains(searchQuery)) && (product.category == selectedCategory || selectedCategory.isEmpty));
      }).toList();
    } else {
      filteredProducts = ref.read(productsProvider);
    }

    setState(() {
      products = filteredProducts;
    });   
    
  }

  onSearchChanged() {
    searchProducts();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(   
      extendBodyBehindAppBar: true,        
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                            
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                        
                      //* shop logo
                      const Image(
                        height: 50,
                        width: 50,
                        image: AssetImage('assets/shopping-store.png')
                      ),
                        
                      const SizedBox(width: 20),
                        
                      //* search textfield
                      Expanded(
                        child: TextField(       
                          controller: searchController,                
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(12),
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 2
                              )
                            ),
                            hintText: 'Search for products...',
                            suffixIcon: searchController.text.isEmpty ? IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // clear search field
                              },
                            ) : IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                searchController.clear();
                              },
                            )
                          ),
                        ),
                      ),                      
                    ],
                  ),
                ),
    
                const SizedBox(width: 20),                   
    
                //* categories horizontal listview
                products.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder:(context, index) {
                      // muestra las categorías horizontalmente
                      final category = categories.keys.elementAt(index);
                      return Container(
                        alignment: Alignment.center,
                        height: 50,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelectedCategory && selectedCategory == category ? Colors.green[500] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            // selecciona la categoría y si la selecciona de nuevo reinicia los productos
                            if (selectedCategory == category) {
                              isSelectedCategory = false;
                              selectedCategory = '';
                              searchProducts();
                            } else {
                              isSelectedCategory = true;
                              selectedCategory = category;
                              products = categories[category]!;                               
                            }                                                                             
                            setState(() {});                                                         
                          },
                          child: Text(
                            '$category (${categories[category]!.length})',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: isSelectedCategory && selectedCategory == category ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ) : Container(),
                      
                searchController.text.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    'Results for "${searchController.text}"',
                    maxLines: 1,
                  ),
                ) : const SizedBox(),
    
                const SizedBox(width: 20),
                
                //* products listview
                products.isNotEmpty ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return MyProductTile(product: product);
                    },
                  ),
                ) : const Center(
                  child: Text('No results'),
                ),      
    
              ],
            ),
          ),
        ),
      ),
    
    );
  }
}

class MyProductTile extends StatelessWidget {
  const MyProductTile({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed('item-details', pathParameters: {'id': product.id}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: product.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    product.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),                      
                      ),
                      RatingBar.builder(
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemSize: 20,
                        initialRating: product.stars,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      )
                    ],
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}