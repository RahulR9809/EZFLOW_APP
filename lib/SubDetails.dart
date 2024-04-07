// ignore_for_file: file_names, unnecessary_string_escapes

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:google_fonts/google_fonts.dart';

class SubDetails extends StatefulWidget {
  final Product product;
  final String selectedCategory;

  const SubDetails({
    Key? key,
    required this.product,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<SubDetails> createState() => _SubDetailsState();
}

class _SubDetailsState extends State<SubDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,

      appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,

        title: Text(
          'Details',
          style: GoogleFonts.acme(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Image with Volume
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 32, 32, 32).withOpacity(0.8),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(widget.product.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, 
                  left: 0,
                  right: 0,
                  child: Container(
                    
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: const Color.fromARGB(255, 21, 20, 20).withOpacity(0.7),
                    ),
                    child: Text(
                      'Volume: ${widget.product.productVolume}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Product Details Container
            Container(
             height: MediaQuery.of(context).size.height*0.45,  
             width: MediaQuery.of(context).size.width*0.95,
              // width: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 73, 73, 73).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ], 
                color: const Color.fromARGB(255, 48, 48, 48),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetail('Product Name', widget.product.productname),
                  _buildDetail('Author', widget.product.productAutherName),
                  _buildDetail('Category', widget.selectedCategory),
                  _buildDetail('Count', '\₹${widget.product.producount}'),
                  _buildDetail('MRP', '\₹${widget.product.productmrp}'),
                 
                ],
              ),
            ),
          ], 
        ),
      ),
    );
  }

   Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
