// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  userID: json['userID'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  date: DateTime.parse(json['date'] as String),
  total: (json['total'] as num).toDouble(),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'userID': instance.userID,
  'items': instance.items,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'date': instance.date.toIso8601String(),
  'total': instance.total,
};

const _$OrderStatusEnumMap = {
  OrderStatus.processing: 'processing',
  OrderStatus.waitingForDelivery: 'waitingForDelivery',
  OrderStatus.delivering: 'delivering',
  OrderStatus.completed: 'completed',
};
