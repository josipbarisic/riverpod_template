import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

// Run "dart run build_runner build -d" to start code generation
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String imageURL,
    required String title,
    required double price,
    required int availableQuantity,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
}
