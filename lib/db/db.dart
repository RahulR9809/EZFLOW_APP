// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// this is for categories
ValueNotifier<List<AddModel>> AddListNotifier = ValueNotifier([]);

class IDGenerator {
  static const String _counterBoxKey = 'counterBoxKey';
  static late Box<int> _counterBox;
  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}

Future<void> Addlist(AddModel value) async {
  final AddModelBox = await Hive.openBox<AddModel>('category');
  await IDGenerator.initialize();

  final _id = IDGenerator.generateUniqueID();
  print('id: $_id');

  value.id = _id;
  value.categoryId = DateTime.now().microsecondsSinceEpoch;
  final addedid = AddModelBox.add(value);
  // ignore: unnecessary_null_comparison
  if (addedid != null) {
    AddListNotifier.value.add(value);
    AddListNotifier.notifyListeners();
  }
}

Future<void> editModel(int id, AddModel updatedValue) async {
  final AddModelBox = await Hive.openBox<AddModel>('category');
  if (AddModelBox.containsKey(id)) {
    await AddModelBox.put(id, updatedValue);
  } else {
    print('Record with id $id not found.');
  }
}

Future<void> deletemodel(int id) async {
  final AddModelBox = await Hive.openBox<AddModel>('category');
  await AddModelBox.delete(id);

  AddListNotifier.value.removeWhere((model) => model.id == id);
  AddListNotifier.notifyListeners();
}

// for subcategory
ValueNotifier<List<Product>> AddProductNotifier = ValueNotifier([]);

class IDGenproduct {
  static const String _productBoxkey = 'productboxkey';
  static late Box<int> _productbox;
  static int _count = 0;

  static Future<void> initialize() async {
    _productbox = await Hive.openBox<int>(_productBoxkey);
    _count = _productbox.get('count') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _count++;
    _productbox.put('count', _count);
    return generatedID;
  }
}

Future<void> Addproduct(
  Product value,
) async {
  final subcategoryBox = await Hive.openBox<Product>('product');
  await IDGenproduct.initialize();

  final _Id = IDGenproduct.generateUniqueID();

  value.id = _Id;

  value.subCategoryId = DateTime.now().microsecondsSinceEpoch;
  final addedId = subcategoryBox.add(value);

  // ignore: unnecessary_null_comparison
  if (addedId != null) {
    AddProductNotifier.value.add(value);
    AddProductNotifier.notifyListeners();
  }
}

Future<void> getAllProducts() async {
  final productBox = await Hive.openBox<Product>('product');
  AddProductNotifier.value.clear();
  AddProductNotifier.value.addAll(productBox.values);
  AddProductNotifier.notifyListeners();

}


Future<void> editproduct(int id2, Product updatedData) async {
  try {
    final productBox = await Hive.openBox<Product>('product');
    print(id2);
    final existingData = productBox.get(id2);

    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.imagePath = updatedData.imagePath;
      existingData.productAutherName = updatedData.productAutherName;
      existingData.productCategory = updatedData.productCategory;
      existingData.productVolume = updatedData.productVolume;
      existingData.productmrp = updatedData.productmrp;
      existingData.productname = updatedData.productname;
      existingData.producount=updatedData.producount;

      await productBox.put(id2, existingData);
      print('hello');
      // Update dataListNotifier2 after editing
      int index = AddProductNotifier.value.indexWhere((data) => data.id == id2);
      if (index != -1) {
        AddProductNotifier.value[index] = existingData;
        AddProductNotifier.notifyListeners();
      }
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

Future<void> deleteproduct(int id) async {
  final subcategoryBox = await Hive.openBox<Product>('product');
  await subcategoryBox.delete(id);

  AddProductNotifier.value.removeWhere((element) => element.id == id);
  AddProductNotifier.notifyListeners();
}

  
ValueNotifier<List<SellProduct>> sellListNotifier = ValueNotifier([]);

Future<void> addSellProduct(SellProduct value, ) async {
  try {
    final sellBox = await Hive.openBox<SellProduct>('sell_products'); // Changed 'students' to 'sell_products'
    final id = await sellBox.add(value);
    value.id = id;
    sellListNotifier.value = sellBox.values.toList();
    print('Sell product added: $value');
  } catch (e) {
    print('Error adding sell product: $e');
  }
}



Future<void> getsellproduct() async {
  final studentBox = await Hive.openBox<SellProduct>('sell_products');
  sellListNotifier.value.clear();
  sellListNotifier.value.addAll(studentBox.values);
  sellListNotifier.notifyListeners();
    print('Retrieved sell products: ${sellListNotifier.value}');
}



ValueNotifier<List<ReturnProduct>>returnListNotifier=ValueNotifier([]);
Future<void> addReturn(ReturnProduct value)async {
  try{
    final returnBox=await Hive.openBox<ReturnProduct>('retunItems');
    final id=await returnBox.add(value);
    value.id=id;
    returnListNotifier.value=returnBox.values.toList();
    print('Return items added successfully: ${returnListNotifier.value}');
  }catch(e){
    print('Error adding return items: $e');
  }
}

Future<void> getReturn() async {
  try {
final returnGet = await Hive.openBox<ReturnProduct>('retunItems');
    returnListNotifier.value.clear();
    returnListNotifier.value.addAll(returnGet.values);
    returnListNotifier.notifyListeners();
    print('Retrieved return products: ${returnListNotifier.value}');
  } catch (e) {
    print('Error retrieving return items: $e');
  }
}




