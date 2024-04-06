// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddModelAdapter extends TypeAdapter<AddModel> {
  @override
  final int typeId = 1;

  @override
  AddModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddModel(
      name: fields[1] as String,
      image: fields[2] as String,
      categoryId: fields[3] as int?,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AddModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 2;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int?,
      productname: fields[2] as String,
      productVolume: fields[4] as String,
      productAutherName: fields[3] as String,
      productCategory: fields[5] as String,
      productmrp: fields[6] as String,
      producount: fields[7] as int?,
      categoryId: fields[8] as int?,
      subCategoryId: fields[9] as int?,
      imagePath: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.productname)
      ..writeByte(3)
      ..write(obj.productAutherName)
      ..writeByte(4)
      ..write(obj.productVolume)
      ..writeByte(5)
      ..write(obj.productCategory)
      ..writeByte(6)
      ..write(obj.productmrp)
      ..writeByte(7)
      ..write(obj.producount)
      ..writeByte(8)
      ..write(obj.categoryId)
      ..writeByte(9)
      ..write(obj.subCategoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SellProductAdapter extends TypeAdapter<SellProduct> {
  @override
  final int typeId = 3;

  @override
  SellProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SellProduct(
      id: fields[0] as int?,
      sellName: fields[1] as String,
      sellPhone: fields[2] as String,
      sellBook: fields[3] as String,
      sellPrice: fields[4] as String,
      sellDate: fields[5] as DateTime?,
      sellDiscount: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SellProduct obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sellName)
      ..writeByte(2)
      ..write(obj.sellPhone)
      ..writeByte(3)
      ..write(obj.sellBook)
      ..writeByte(4)
      ..write(obj.sellPrice)
      ..writeByte(5)
      ..write(obj.sellDate)
      ..writeByte(6)
      ..write(obj.sellDiscount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SellProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReturnProductAdapter extends TypeAdapter<ReturnProduct> {
  @override
  final int typeId = 4;

  @override
  ReturnProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReturnProduct(
      id: fields[0] as int?,
      returnName: fields[1] as String,
      returnPhone: fields[2] as String,
      returnProductName: fields[3] as String,
      returnReason: fields[4] as String,
      returnDate: fields[5] as DateTime?,
      returnPrice: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReturnProduct obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.returnName)
      ..writeByte(2)
      ..write(obj.returnPhone)
      ..writeByte(3)
      ..write(obj.returnProductName)
      ..writeByte(4)
      ..write(obj.returnReason)
      ..writeByte(5)
      ..write(obj.returnDate)
      ..writeByte(6)
      ..write(obj.returnPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReturnProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
