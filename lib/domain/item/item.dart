import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

// Run "dart run build_runner build -d" to start code generation
@freezed
class Item with _$Item {
  const factory Item({
    required String productID,
    required int quantity,
  }) = _Item;

  factory Item.fromJson(Map<String, Object?> json) => _$ItemFromJson(json);
}
