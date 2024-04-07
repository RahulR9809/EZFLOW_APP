// ignore: file_names
// ignore_for_file: sort_child_properties_last

import 'package:firstproject/sellDetails.dart';
import 'package:flutter/material.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class SellProducts extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const SellProducts({
    Key? key,
  });

  @override
  State<SellProducts> createState() => _SellProductsState();
}

class _SellProductsState extends State<SellProducts> {
  final _sellName = TextEditingController();
  final _sellPhone = TextEditingController();
  final _sellBook = TextEditingController();
  final _sellPrice = TextEditingController();
  final _selldiscount = TextEditingController();

  List<Product> selectedProducts = [];
  int totalSoldCount = 0;
  late Future<List<Product>> allProductsFuture;
  late Function(double) updateTodayRevenue;

  @override
  void dispose() {
    _sellName.dispose();
    _sellPhone.dispose();
    _sellBook.dispose();
    _sellPrice.dispose();
    _selldiscount.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    allProductsFuture = getAllProducts();
  }

  Future<List<Product>> getAllProducts() async {
    final addProductBox = await Hive.openBox<Product>('product');
    final allProduct = addProductBox.values.toList();
    return List<Product>.from(allProduct);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double totalPrice = selectedProducts.fold<double>(
      0,
      (previousValue, element) =>
          previousValue + double.parse(element.productmrp),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: Container(),
        title: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Text(
            'Sell Products',
            style: GoogleFonts.abel(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _sellName,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _sellPhone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length != 10) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
              TextFormField(
  maxLines: null,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  decoration: InputDecoration(
    labelText: 'Choose Product',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    suffixIcon: IconButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      icon: const Icon(Icons.arrow_drop_down),
    ),
  ),
  readOnly: true,
  controller: _sellBook,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please choose a product';
    }
    return null;
  },
),

                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _selldiscount,
                      decoration: InputDecoration(
                        labelText: 'Discount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (discount) {
                        setState(() {
                          if (discount.isNotEmpty) {
                            double discountAmount = double.parse(discount);
                            double totalprice = selectedProducts.fold<double>(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    double.parse(element.productmrp));
                            totalprice -= discountAmount;
                            _sellPrice.text = totalprice.toString();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      controller: _sellPrice,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final newSellproduct = SellProduct(
                              sellName: _sellName.text,
                              sellPhone: _sellPhone.text,
                              sellBook: selectedProducts
                                  .map((e) => e.productname)
                                  .join(', '),
                              sellPrice: totalPrice.toString(),
                              sellDate: DateTime?.now(),
                              sellDiscount: _selldiscount.text,
                            );

                            for (var product in selectedProducts) {
                              if (product.producount != null &&
                                  product.producount! > 0) {
                                product.producount = product.producount! - 1;
                                await updateProduct(product);
                              }
                            }

                            await addSellProduct(newSellproduct);

                            setState(() {
                              totalSoldCount += selectedProducts.length;
                              // ignore: avoid_print
                              print('Total Sold Count: $totalSoldCount');
                            });

                            updateTotalSoldCount(selectedProducts.length);
                            Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SellDetails(selectedProducts:selectedProducts,)));

                            setState(() {
                              _sellName.clear();
                              _sellPhone.clear();
                              _sellBook.clear();
                              _sellPrice.clear();
                            });
                          } catch (e) {
                            // ignore: avoid_print
                            print('An error occurred: $e');
                          }
                        }
                      },
                     child: const Text(
                          'Sell',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTotalSoldCount(int count) {
    setState(() {
      totalSoldCount += count;
    });
  }

  Future<void> updateProduct(Product product) async {
    try {
      final productBox = await Hive.openBox<Product>('product');
      await productBox.put(product.id, product);
    } catch (e) {
      // ignore: avoid_print
      print('Error updating product: $e');
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await showDialog<List<Product>>(
      context: context,
      builder: (BuildContext context) {
        return ProductSelectionScreen();
      },
    );

    if (result != null) {
      setState(() {
        selectedProducts = result;
        _sellBook.text = '';
        double totalPrice = 0;
        Map<String, int> productCounts = {};

        for (var product in selectedProducts) {
          totalPrice += double.parse(product.productmrp);
          if (productCounts.containsKey(product.productname)) {
            productCounts[product.productname] =
                productCounts[product.productname]! + 1;
          } else {
            productCounts[product.productname] = 1;
          }
        }

        for (var entry in productCounts.entries) {
          String productName = entry.key;
          int count = entry.value;
          double productPrice = double.parse(selectedProducts
                  .firstWhere((product) => product.productname == productName)
                  .productmrp) *
              count;
          String formattedProduct =
              '$productName = $count * ${selectedProducts.firstWhere((product) => product.productname == productName).productmrp} = $productPrice';
          // ignore: prefer_interpolation_to_compose_strings
          _sellBook.text += formattedProduct + '\n';
        }

        _sellPrice.text = totalPrice.toString();
      });
    }
  }
}

// ignore: use_key_in_widget_constructors
class ProductSelectionScreen extends StatefulWidget {
  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();

  void onUpdateSelectedProducts(List<Product> selectedProducts) {}

  void onUpdateReturnName(param0) {}

  void onUpdateReturnPhone(param0) {}
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  late List<Product> allProducts;
  late List<Product> displayedProducts = [];
  late List<int> selectedCounts = [];

  @override
  void initState() {
    super.initState();
    getAllProducts().then((products) {
      setState(() {
        allProducts = products;

        displayedProducts =
            allProducts.where((product) => product.producount! > 0).toList();
        selectedCounts = List.generate(displayedProducts.length, (_) => 0);
      });
    });
  }

  Future<List<Product>> getAllProducts() async {
    final addProductBox = await Hive.openBox<Product>('product');
    final allProduct = addProductBox.values.toList();
    return List<Product>.from(allProduct);
  }

  void filterProducts(String query) {
    setState(() {
      displayedProducts = allProducts
          .where((product) =>
              product.productname.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

 void _openCountDialog(BuildContext context, int index) {
  int count = selectedCounts[index];
  Product product = displayedProducts[index];
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int newCount = count;
      return AlertDialog(
        title: const Text('Enter Count'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available Stock: ${product.producount}'),
            TextFormField(
              initialValue: count.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                newCount = int.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              setState(() {
                newCount = newCount.clamp(0, product.producount!);
                selectedCounts[index] = newCount;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // ignore: sized_box_for_whitespace
      child: Container(
        height: MediaQuery.of(context).size.height * 0.58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: filterProducts,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  Product product = displayedProducts[index];
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        _openCountDialog(context, index);
                      },
                      child: Text(product.productname),
                    ),
                    // subtitle: Text('Available: ${product.producount}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      
                        Text(selectedCounts[index].toString()),
                     
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      List<Product> selectedProducts = [];
                      for (int i = 0; i < displayedProducts.length; i++) {
                        for (int j = 0; j < selectedCounts[i]; j++) {
                          selectedProducts.add(displayedProducts[i]);
                        }
                      }
                      Navigator.pop(context, selectedProducts);
                    },
                    child: const Text('Add'),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                      setState(() {
                        selectedCounts =
                            List.generate(allProducts.length, (_) => 0);
                      });
                    },
                    child: const Text('Clear'),
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
