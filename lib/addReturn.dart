// ignore: file_names
import 'package:firstproject/ReturnedDetails.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddReturn extends StatefulWidget {
  final String? name;
  final String? phone;
  
  const AddReturn({
    Key? key,
    this.name,
    this.phone,
    
  }) : super(key: key);

  @override
  State<AddReturn> createState() => _AddReturnState();
}
class _AddReturnState extends State<AddReturn> {
  final _returnedName = TextEditingController();
  final _returnedPhone = TextEditingController();
  final _returnedProduct = TextEditingController();
  final _returnedReason = TextEditingController();
  final _returnPrice = TextEditingController();
  List<Product> selectedProducts = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getReturn();
    _returnedName.text = widget.name ?? '';
    _returnedPhone.text = widget.phone ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            'Return',
            style: GoogleFonts.abel(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextFormField(
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _returnedName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Customer name',
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _returnedPhone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Phone Number',
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  maxLines: null,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Choose Product',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onTap: () {
                    _navigateAndDisplaySelection(context);
                  },
                  controller: _returnedProduct,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please choose a product';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _returnedReason,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Reason for return',
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _returnPrice,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Return price',
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newReturn = ReturnProduct(
                        returnName: _returnedName.text,
                        returnPhone: _returnedPhone.text,
                        returnProductName: _returnedProduct.text,
                        returnReason: _returnedReason.text,
                        returnDate: DateTime.now(),
                        returnPrice: _returnPrice.text,
                      );
                      await addReturn(newReturn);
                      await getReturn();
                      setState(() {
                        _returnedName.clear();
                        _returnedPhone.clear();
                        _returnedProduct.clear();
                        _returnedReason.clear();
                      });
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => const ReturnPage()),
                      );
                    }
                  },
                  child: const Text('Return'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

void _navigateAndDisplaySelection(BuildContext context) async {
  final result = await showDialog<List<Product>>(
    context: context,
    builder: (BuildContext context) {
      return ProductSelectionScreen(selectedProducts: selectedProducts);
    },
  );

  if (result != null) {
    setState(() {
      selectedProducts = result;
      Map<String, int> productCounts = {};
      for (var product in selectedProducts) {
        if (productCounts.containsKey(product.productname)) {
          productCounts[product.productname] =
              productCounts[product.productname]! + 1;
        } else {
          productCounts[product.productname] = 1;
        }
      }
      String updatedProductText = '';
      productCounts.forEach((productName, count) {
        double productPrice = double.parse(selectedProducts
                .firstWhere((product) => product.productname == productName)
                .productmrp) *
            count;
        updatedProductText +=
            '$productName * $count = ₹$productPrice,\n';
      });
      _returnedProduct.text = updatedProductText;
      double totalPrice = 0;
      for (var product in selectedProducts) {
        totalPrice += double.parse(product.productmrp);
      }
      _returnPrice.text = totalPrice.toString();
    });
  }
}



}

class ProductSelectionScreen extends StatefulWidget {
  final List<Product> selectedProducts;

  const ProductSelectionScreen({
    Key? key,
    required this.selectedProducts,
  }) : super(key: key);

  @override
  State<ProductSelectionScreen> createState() =>
      _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  late List<Product> allProducts = [];
  late List<Product> displayedProducts = [];
  late List<int> selectedCounts = [];

  @override
  void initState() {
    super.initState();
    getAllProducts().then((products) {
      setState(() {
        allProducts = products;
        displayedProducts = List.from(allProducts);
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
      selectedCounts = List.generate(displayedProducts.length, (_) => 0);
    });
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  Product product = displayedProducts[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(product.productname),
                        ),
                        SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (selectedCounts[index] > 0) {
                                      selectedCounts[index]--;
                                    }
                                  });
                                },
                              ),
                              Text(selectedCounts[index].toString()), // Display count here
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    selectedCounts[index]++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
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
                        selectedCounts = List.generate(allProducts.length, (_) => 0);
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
