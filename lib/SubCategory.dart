// ignore: file_names
// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously, avoid_types_as_parameter_names, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'package:firstproject/AddSubCtgry.dart';
import 'package:firstproject/SubDetails.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:firstproject/subcategoryEdit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

@override
// ignore: must_be_immutable
class SubCategory extends StatefulWidget {
  final List<String> bookNames;
  final Map<String, String> bookPrices;
  AddModel data;
  final VoidCallback? onCategoryUpdated;

  SubCategory(
      {Key? key,
      required this.data,
      this.onCategoryUpdated,
      required String selectedCategory,
      required this.bookNames,
      required this.bookPrices})
      : super(key: key);

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

final subcategoryBox = Hive.box<Product>('product');

class _SubCategoryState extends State<SubCategory> {
  final TextEditingController _productSearch = TextEditingController();
  List<Product> allProduct = [];
  List<Product> filteredProduct = [];

  @override
  void initState() {
    GetAllproducts();
    super.initState();
  }

  Future<void> GetAllproducts({String? filter}) async {
    final addProductBox = await Hive.openBox<Product>('product');
    allProduct = addProductBox.values.toList();

    if (filter != null && filter.isNotEmpty) {
      filteredProduct = allProduct
          .where((data) =>
              data.productname.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      filteredProduct = List.from(allProduct);
    }
    setState(() {
      AddProductNotifier.value = filteredProduct;
    });
  }

  Future<void> _onDeleteButtonPressed(int id) async {
    try {
      await _confirmationDialog(context, id);
    } catch (e) {
      print('Error during deletion: $e');
    }
  }

  Future<void> _confirmationDialog(BuildContext context, int? id) async {
    return showDialog<void>(
      context: context,
      builder: ((BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Confirm Deletion')),
          content: const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text('Are you sure?'),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await deleteproduct(id!);
                      await GetAllproducts();
                      Navigator.of(context).pop();

                      setState(() {});
                    },
                    child: const Text('Confirm'),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const Padding(
                  padding: EdgeInsets.only(left: 85),
                  child: Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing as needed
            TextFormField(
              controller: _productSearch,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                GetAllproducts(filter: value);
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: AddProductNotifier,
                  builder: (BuildContext context, List<Product> productList,
                      Widget? child) {
                    List<Product> filterdata = productList
                        .where((Product) =>
                            Product.categoryId == widget.data.categoryId)
                        .toList();
                    if (filterdata.isEmpty) {
                      return const Center(
                        child: Text('No Products Found'),
                      );
                    } else {
                      filterdata = filterdata.reversed.toList();
                      return SingleChildScrollView(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filterdata.length,
                          itemBuilder: (context, index) {
                            final Product products = filterdata[index];
                            _onCategoryUpdated() async {
                              await GetAllproducts();
                              setState(() {});
                              print('Product count updated successfully.');
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubDetails(
                                        product: products,
                                        selectedCategory: widget.data.name,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      _onCategoryUpdated.call();
                                    }
                                  });
                                },
                                child: Container(
                                  height: 150,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 251, 251, 251),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: products.imagePath != null
                                                ? FileImage(File(
                                                        products.imagePath!))
                                                    as ImageProvider<Object>
                                                : const AssetImage(
                                                    'assets/placeholder_image.png'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 40),
                                                    child: Text(
                                                        products.productname,
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                              
                                                        )),
                                                  ),
                                                ),
                                                PopupMenuButton<String>(
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          [
                                                    const PopupMenuItem<String>(
                                                      value: 'edit',
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem<String>(
                                                      value: 'delete',
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  onSelected:
                                                      (String value) async {
                                                    if (value == 'edit') {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  subcategoryEdit(
                                                                    product:
                                                                        products,
                                                                  ))).then(
                                                          (value) {
                                                        print(
                                                            'subcategoryEdit completed with value: $value');
                                                        if (value == true) {
                                                          _onCategoryUpdated
                                                              .call();
                                                        }
                                                      });
                                                    } else if (value ==
                                                        'delete') {
                                                      await _onDeleteButtonPressed(
                                                          products.id!);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 23),
                                                    child: Text(
                                                        'MRP:${products.productmrp}',
                                                        style:
                                                            GoogleFonts.andika(
                                                              
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          36, 0, 0, 0),
                                                  child: Text(
                                                      'Count:${products.producount}',
                                                      style: GoogleFonts.andika(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCategories(
                        data: widget.data,
                      )),
            );
          },
          child: const Icon(Icons.add),
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  Future<void> updateProduct(Product product) async {
    final productBox = await Hive.openBox<Product>('product');
    await productBox.put(product.id, product);
  }
}
