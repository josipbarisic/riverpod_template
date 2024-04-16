// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      imageURL: json['imageURL'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      availableQuantity: json['availableQuantity'] as int,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageURL': instance.imageURL,
      'title': instance.title,
      'price': instance.price,
      'availableQuantity': instance.availableQuantity,
    };
