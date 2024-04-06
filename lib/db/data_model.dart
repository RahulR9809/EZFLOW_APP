import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 1)
class AddModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
   int? categoryId;

  AddModel({required this.name, required this.image,this.categoryId, this.id});

  get product => null;
}

@HiveType(typeId: 2)
class Product {
  @HiveField(0)
  int? id;

  @HiveField(1)
   String? imagePath;  

  @HiveField(2)
   String productname;

  @HiveField(3)
   String productAutherName;

  @HiveField(4)
   String productVolume;

  @HiveField(5)
   String productCategory;

  @HiveField(6)
   String productmrp;

 @HiveField(7)
int? producount;

  @HiveField(8)
  int? categoryId;

  @HiveField(9)
  int? subCategoryId;  


   

  Product({
    this.id,
    required this.productname,
    required this.productVolume,
    required this.productAutherName,
    required this.productCategory,
    required this.productmrp,
    required this.producount,
    this.categoryId,
    this.subCategoryId,  
    required this.imagePath, 
  });

  static map(Function(dynamic product) param0) {}
}


@HiveType(typeId: 3)
class SellProduct {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String sellName;

  @HiveField(2)
  final String sellPhone;

  @HiveField(3)
  final String sellBook;

  @HiveField(4)
  final String sellPrice;

  @HiveField(5)
 final DateTime? sellDate;

 @HiveField(6)
 final String? sellDiscount;



  SellProduct({
    this.id,
    required this.sellName,
    required this.sellPhone,
    required this.sellBook,
    required this.sellPrice, 
  required this.sellDate,
 required this.sellDiscount,

  });
}

@HiveType(typeId: 4)
class ReturnProduct {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String returnName;

  @HiveField(2)
  final String returnPhone;

  @HiveField(3)
  final String returnProductName;

  @HiveField(4)
  final String returnReason;

    @HiveField(5)
  final DateTime? returnDate;

    @HiveField(6)
  final String returnPrice;

  ReturnProduct({
    this.id,
    required this.returnName,
    required this.returnPhone,
    required this.returnProductName,
    required this.returnReason,
    required this.returnDate,
    required this.returnPrice
  });
}
