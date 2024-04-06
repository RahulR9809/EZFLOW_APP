import 'package:firstproject/addReturn.dart';
import 'package:flutter/material.dart';
import 'package:firstproject/HomePage.dart';
import 'package:firstproject/db/db.dart'; // Assuming this is where getsellproduct() is defined
import 'package:firstproject/db/data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SellDetails extends StatefulWidget {
  final List<Product> selectedProducts;
  // ignore: use_key_in_widget_constructors
  const SellDetails({
    Key? key,
    required this.selectedProducts,
  }) : super(key: key);
  @override
  State<SellDetails> createState() => _SellDetailsState();
}

class _SellDetailsState extends State<SellDetails> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    getsellproduct();
    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: Text(
          'Sell Details',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
            ValueListenableBuilder<List<SellProduct>>(
                valueListenable: sellListNotifier,
                builder: (context, sellProducts, child) {
                  if (_selectedDate != null && sellProducts.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text(
                          'No sell products available',
                          style: GoogleFonts.andika(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    sellProducts
                        .sort((a, b) => b.sellDate!.compareTo(a.sellDate!));

                    List<SellProduct> displayedSellProducts;
                    if (_selectedDate != null) {
                      displayedSellProducts = sellProducts
                          .where((sellProduct) =>
                              sellProduct.sellDate != null &&
                              DateFormat('yyyy-MM-dd')
                                      .format(sellProduct.sellDate!) ==
                                  DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate!))
                          .toList();
                    } else {
                      displayedSellProducts = sellProducts;
                    }

                    if (_selectedDate != null &&
                        displayedSellProducts.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            'No sell products available',
                            style: GoogleFonts.andika(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 35, 35, 35),
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: displayedSellProducts.map((sellProduct) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20.0),
                            color: Colors.red,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm"),
                                  content: Text(
                                      "Are you sure you want to delete this sell entry?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("CANCEL"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("DELETE"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            // Remove the sell product from the list
                            setState(() {
                              sellProducts.remove(sellProduct);
                            });
                          },
                          child: Container(
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
                                        'Customer',
                                        style: GoogleFonts.anaheim(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        sellProduct.sellDate != null
                                            ? DateFormat(
                                                    'dd/MM/yyyy \n hh:mm:ss a')
                                                .format(sellProduct.sellDate!)
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
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline_rounded,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      SizedBox(width: 15),
                                      Text(sellProduct.sellName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Icon(
                                        Icons.call_outlined,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        sellProduct.sellPhone,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Text(
                                        'Product :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: Colors.white),
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: () {
                                      Map<String, int> productCountMap = {};
                                      List<String> products =
                                          sellProduct.sellBook.split(',');

                                      for (String product in products) {
                                        String productName = product.trim();
                                        if (productCountMap
                                            .containsKey(productName)) {
                                          productCountMap[productName] =
                                              (productCountMap[productName] ??
                                                      0) +
                                                  1;
                                        } else {
                                          productCountMap[productName] = 1;
                                        }
                                      }
                                      List<Widget> productWidgets = [];
                                      productCountMap
                                          .forEach((productName, productCount) {
                                        // Find the product in AddProductNotifier list
                                        Product? product;
                                        for (var element
                                            in AddProductNotifier.value) {
                                          if (element.productname ==
                                              productName) {
                                            product = element;
                                            break;
                                          }
                                        }

                                        // ignore: unnecessary_null_comparison
                                        if (product != null) {
                                          double productPrice = double.parse(
                                              product.productmrp);
                                          productWidgets.add(
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '$productName * $productCount = ₹${productPrice * productCount}',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      });
                                      return productWidgets;
                                    }(),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Discount',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '₹${sellProduct.sellDiscount}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Price:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '₹${sellProduct.sellPrice}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddReturn(
                                                    name: sellProduct.sellName,
                                                    phone:
                                                        sellProduct.sellPhone,
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      backgroundColor:
                                          Color.fromARGB(255, 51, 52, 111),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 3),
                                      child: Text(
                                        'Return Product',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                }),
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
