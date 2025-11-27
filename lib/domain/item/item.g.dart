// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
  productID: json['productID'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'productID': instance.productID,
  'quantity': instance.quantity,
};
