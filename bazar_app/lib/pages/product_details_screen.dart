

import 'package:bazar_app/models/product_model.dart';
import 'package:bazar_app/services/firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsScreen extends StatefulWidget {

  final String productId;
  const ProductDetailsScreen({
    super.key,
    required this.productId
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<ProductModel>(
          future: firestoreService.getProductById(widget.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final product = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(                
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.image,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 250,
                          width: 250,
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
                    const SizedBox(height: 15),
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('\$${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                            Text('${product.stock} units'),
                          ],
                        ),
                        RatingBar.builder(
                          initialRating: product.stars,
                          allowHalfRating: true,
                          itemSize: 25,
                          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {},
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    Center(child: Text(product.description, style: const TextStyle(fontSize: 18))),
                    const SizedBox(height: 35),
                    const Spacer(),
                    Container(                  
                      padding: const EdgeInsets.only(bottom: 45),
                      width: double.infinity,
                      height: 110,
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green[500]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                        ),
                        onPressed: (){},
                        child: const Text('Buy', style: TextStyle(fontWeight: FontWeight.bold))
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}