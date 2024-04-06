import 'dart:io';

import 'package:firstproject/SubCategory.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AddCategories extends StatefulWidget {
  AddModel data;
  AddCategories({Key? key, required this.data}) : super(key: key);

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  final _productName = TextEditingController();
  final _productVolume = TextEditingController();
  final _productAuther = TextEditingController();
  final _productCategory = TextEditingController();
  final _productMrp = TextEditingController();
  final _producCount = TextEditingController();
  File? _subImage;
  late String _selectedCategory;
  List<String> _categories = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 List<Product> sellProducts = [];
 
  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.data.name;
    fetchCategories();
    
  }

  Future<void> fetchCategories() async {
    try {
      List<AddModel> categories = await getAllModels();
      setState(() {
        _categories.addAll(categories.map((category) => category.name));
        _selectedCategory = _categories as String ;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Add Products',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () async {
                      await pickImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 250,
                            width: 300,
                            color: Colors.grey,
                            child: _subImage != null
                                ? Image.file(
                                    _subImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    child: Icon(Icons.add_a_photo_sharp),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _productName,
                        decoration: InputDecoration(
                            hintText: 'Product Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a product name';
                          }
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return 'Product name must contain only letters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _productVolume,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'volume',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the volume';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Volume must contain only numbers';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _productAuther,
                        decoration: InputDecoration(
                            hintText: 'Author Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the author name';
                          }
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return 'Author name must contain only letters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        controller:
                            TextEditingController(text: _selectedCategory),
                        onTap: () {
                          _showCategoryDialog(context);
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == 'Select Category') {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _producCount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Product Count',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product count';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _productMrp,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'MRP',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product MRP';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Product MRP must contain only numbers';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            if (_subImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please add an image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              final newProduct = Product(
                                imagePath: _subImage!.path,
                                productname: _productName.text,
                                productVolume: _productVolume.text,
                                productAutherName: _productAuther.text,
                                productCategory: _selectedCategory,
                                productmrp: _productMrp.text,
                                producount: int.parse(_producCount.text),
                                categoryId: widget.data.categoryId,
                               
                              );

                              await Addproduct(newProduct);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubCategory(
                                    data: widget.data,
                                    selectedCategory: '',
                                    bookNames: [],
                                    bookPrices: {},
                                 
                                  ),
                                ),
                              );

                              setState(() {
                                _productName.clear();
                                _productVolume.clear();
                                _productAuther.clear();
                                _productCategory.clear();
                                _productMrp.clear();
                                _subImage = null;
                              });
                            }
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
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
                  )),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _showCategoryDialog(BuildContext context) async {
  final String? selectedCategory = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Category'),
        content: SingleChildScrollView(
          child: Column(
            children: _categories
                .where((category) => category == widget.data.name)
                .map((category) {
              return ListTile(
                title: Text(category),
                onTap: () {
                  Navigator.pop(context, category);
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );

  if (selectedCategory != null) {
    setState(() {
      _selectedCategory = selectedCategory;
      
    });
  }
}


  Future<void> pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _subImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<List<AddModel>> getAllModels() async {
    try {
      final addModelBox = await Hive.openBox<AddModel>('category');
      return addModelBox.values.toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return []; 
  }
}
}