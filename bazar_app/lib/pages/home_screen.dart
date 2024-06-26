

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              //* shop logo
              const Image(
                height: 200,
                width: 200,
                image: AssetImage('assets/shopping-store.png')
              ),
          
              const SizedBox(height: 10),
          
              //* shop name
              const Text(
                'Online Bazaar',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                )
              ),
          
              const SizedBox(height: 20),
          
              //* product searchbar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  validator: (value) => value!.isEmpty ? 'Enter a product name' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                      )
                    ),
                    hintText: 'Laptops, smartphones...',
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                        context.pushNamed('items', queryParameters: {'query': searchController.text});
                        }
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      )
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  )
                )
              ),
          
              const SizedBox(height: 25),
          
              //* search button
              SizedBox(
                width: 150,            
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green[500]),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.pushNamed('items', queryParameters: {'query': searchController.text});
                    }                  
                  },
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}