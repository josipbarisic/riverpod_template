import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_template/domain/item/item.dart';
import 'package:riverpod_template/utils/enums/order_status_enum.dart';

part 'order.freezed.dart';
part 'order.g.dart';

// Run "dart run build_runner build -d" to start code generation
@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String userID,
    required List<Item> items,
    required OrderStatus status,
    required DateTime date,
    required double total,
  }) = _Order;

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
}
