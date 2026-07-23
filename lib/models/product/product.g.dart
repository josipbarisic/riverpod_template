// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  imageURL: json['imageURL'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  availableQuantity: (json['availableQuantity'] as num).toInt(),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'imageURL': instance.imageURL,
  'title': instance.title,
  'price': instance.price,
  'availableQuantity': instance.availableQuantity,
};
