import 'dart:io';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class subcategoryEdit extends StatefulWidget {
  final Product product;



  subcategoryEdit({
    required this.product,
     
  });

  @override
  State<subcategoryEdit> createState() => _subcategoryEditState();
}

class _subcategoryEditState extends State<subcategoryEdit> {
  late TextEditingController _productName;
  late TextEditingController _productVolume;
  late TextEditingController _productAuther;
  late TextEditingController _productCategory;
  late TextEditingController _productMrp;
  late TextEditingController _productCount;
  File? _subImage;
    late String _selectedCategory = 'Select Category';// Variable to hold selected category
  List<String> _categories = []; 
  
  @override
  void initState() {
    super.initState();
    _productName = TextEditingController(text: widget.product.productname);
    _productVolume = TextEditingController(text: widget.product.productVolume);
    _productAuther =
        TextEditingController(text: widget.product.productAutherName);
    _productCategory =
        TextEditingController(text: widget.product.productCategory);
    _productMrp = TextEditingController(text: widget.product.productmrp);
    _subImage = File(widget.product.imagePath!);
_productCount = TextEditingController(text: widget.product.producount?.toString());
    fetchCategories();
  }

    
   Future<void> fetchCategories() async {
    try {
      List<AddModel> categories = await getAllModels();
      setState(() {
        _categories.addAll(categories.map((category) => category.name));
        _selectedCategory = _categories.first;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Subcategory'),
      ),
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
                      await _getImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1),
                      child: Container(
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
                  child: Column(
                children: [
                  TextFormField(
                    controller: _productName,
                    decoration: InputDecoration(
                        hintText: 'Product Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _productAuther,
                    decoration: InputDecoration(
                        hintText: 'Auter Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
              controller: TextEditingController(text: _selectedCategory),
              onTap: () {
                _showCategoryDialog(context);
              },
              validator: (value) {
                if (value == null || value.isEmpty || value == 'Select Category') {
                  return 'Please select a category';
                }
                return null;
              }, 
            ),  
              SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _productCount,
                     keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Count',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _updateProduct();
                    },
                    child: Text(
                      'update',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              children: _categories.map((category) {
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


  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _subImage = File(pickedFile.path);
      });
    }
  }

void _updateProduct() async {
  print('Updating product...');
  if (_productName.text.isEmpty &&
      _productAuther.text.isEmpty &&
      _productCategory.text.isEmpty &&
      _productMrp.text.isEmpty &&
      _productCount.text.isEmpty &&
      _productVolume.text.isEmpty) {
    return;
  }


  int count = int.tryParse(_productCount.text) ?? 0;

  Product updatedProduct = Product(
    id: widget.product.id,
    productname: _productName.text,
    productVolume: _productVolume.text,
    productAutherName: _productAuther.text,
    productCategory: _productCategory.text,
    productmrp: _productMrp.text,
    imagePath: _subImage?.path,
    subCategoryId: widget.product.subCategoryId,
    producount: count, 
  );

  await editproduct(widget.product.id!, updatedProduct);
  print('Product updated: ${updatedProduct.productname}');
  _onCategoryUpdated();
  Navigator.pop(context, true);
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
 void _onCategoryUpdated() {
    fetchCategories();
  }
}
 