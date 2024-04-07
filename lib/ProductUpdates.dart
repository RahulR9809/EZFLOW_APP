// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductUpdates extends StatefulWidget {
  const ProductUpdates({super.key});

  @override
  State<ProductUpdates> createState() => _ProductUpdatesState();
}

class _ProductUpdatesState extends State<ProductUpdates> {
  List<Product> stockout = [];
  List<Product> allProducts = [];

  @override
  void initState() {
    super.initState();
    getAllProduct();

    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
       title: Text(
          'Stock Updates',
          style: GoogleFonts.libreFranklin(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 5,
                ), 
              ],
            ),
          ),
        ),
      ),
      body: buildStockoutList(),
    );
  }

  Future<void> getAllProduct() async {
    allProducts = AddProductNotifier.value;
    stockoutproducts();
  }

  Widget buildStockoutList() {
    if (stockout.isNotEmpty) {
      return ListView.builder(
        itemCount: stockout.length,
        itemBuilder: (context, index) {
          final product = stockout[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  product.productname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                subtitle: const Text(
                  'Out of Stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                size: 50,
                color: Colors.blue,
              ),
              const SizedBox(height: 10.0),
              Text(
                'No stockout products found.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void stockoutproducts() {
    stockout.clear();
    for (var prod in allProducts) {
      if (prod.producount == 0) {
        stockout.add(prod);
      }
    }
    setState(() {});
  }
}
