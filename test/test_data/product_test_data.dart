import 'package:riverpod_template/domain/product/product.dart';

/// Factory function to create test products with optional overrides
Product createTestProduct({
  String? id,
  String? imageURL,
  String? title,
  double? price,
  int? availableQuantity,
}) =>
    Product(
      id: id ?? 'test-product-id',
      imageURL: imageURL ?? 'https://example.com/image.jpg',
      title: title ?? 'Test Product',
      price: price ?? 29.99,
      availableQuantity: availableQuantity ?? 100,
    );

/// Pre-built test product constants for common scenarios
class TestProducts {
  TestProducts._();

  /// Basic product with default values
  static Product get basic => createTestProduct();

  /// Product with zero quantity (out of stock)
  static Product get outOfStock => createTestProduct(
        id: 'out-of-stock',
        title: 'Out of Stock Product',
        availableQuantity: 0,
      );

  /// Expensive product
  static Product get expensive => createTestProduct(
        id: 'expensive-product',
        title: 'Premium Product',
        price: 999.99,
        availableQuantity: 5,
      );

  /// Free product
  static Product get free => createTestProduct(
        id: 'free-product',
        title: 'Free Sample',
        price: 0.0,
        availableQuantity: 1000,
      );

  /// Generate a list of test products
  static List<Product> list(int count) => List.generate(
        count,
        (i) => createTestProduct(
          id: 'product-$i',
          title: 'Product $i',
          price: (i + 1) * 10.0,
          availableQuantity: (i + 1) * 10,
        ),
      );

  /// JSON representation for testing fromJson
  static Map<String, dynamic> get basicJson => {
        'id': 'test-product-id',
        'imageURL': 'https://example.com/image.jpg',
        'title': 'Test Product',
        'price': 29.99,
        'availableQuantity': 100,
      };
}
