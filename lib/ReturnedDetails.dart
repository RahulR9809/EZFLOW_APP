import 'package:flutter/material.dart';
import 'package:firstproject/db/db.dart'; // Assuming this is where getReturn() is defined
import 'package:firstproject/db/data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReturnPage extends StatefulWidget {
  const ReturnPage({Key? key}) : super(key: key);

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    getReturn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
       
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        title: Text(
          'Returned',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder<List<ReturnProduct>>(
              valueListenable: returnListNotifier,
              builder: (context, returnProducts, child) {
                // ignore: unnecessary_null_comparison
                if (returnProducts == null || returnProducts.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        'No return products available.',
                        style: GoogleFonts.andika(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                } else {
                  List<ReturnProduct> displayedReturnProducts;
                  if (_selectedDate != null) {
                    displayedReturnProducts = returnProducts
                        .where((returnProduct) =>
                            returnProduct.returnDate != null &&
                            DateFormat('yyyy-MM-dd')
                                    .format(returnProduct.returnDate!) ==
                                DateFormat('yyyy-MM-dd').format(_selectedDate!))
                        .toList();
                  } else {
                    displayedReturnProducts = returnProducts;
                  }

                  if (_selectedDate != null &&
                      displayedReturnProducts.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text(
                          'No return products available',
                          style: GoogleFonts.andika(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children:
                        displayedReturnProducts.reversed.map((returnProduct) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Return Details',
                                    style: GoogleFonts.anaheim(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    returnProduct.returnDate != null
                                        ? DateFormat('dd/MM/yyyy \n hh:mm:ss a')
                                            .format(returnProduct.returnDate!)
                                        : 'N/A',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.white),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              title: Text(
                                'Name: ${returnProduct.returnName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone: ${returnProduct.returnPhone}',
                                  style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                  ),
                                  Divider(color: Colors.white),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Reason: ${returnProduct.returnReason}',
                                  style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(color: Colors.white),
                                  Text(
                                    'Product:',
                                   style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                  ),
                                  Divider(color: Colors.white),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    ' ₹${returnProduct.returnProductName}',
                                  style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Price:',
                                        style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                                                      ),
                                      ),
                                        Text(
                                        ' ₹${returnProduct.returnPrice}',
                                        style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                                                      ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
