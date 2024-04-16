import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_template/domain/item/item.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

// Run "dart run build_runner build -d" to start code generation
@freezed
class Cart with _$Cart {
  const factory Cart({
    required List<Item> items,
    required double total,
  }) = _Cart;

  factory Cart.fromJson(Map<String, Object?> json) => _$CartFromJson(json);
}
