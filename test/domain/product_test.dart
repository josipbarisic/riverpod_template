import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/models/product/product.dart';

import '../test_data/product_test_data.dart';

void main() {
  group('Product', () {
    group('instantiation', () {
      test('creates product with all required fields', () {
        final product = createTestProduct(
          id: 'prod-123',
          imageURL: 'https://example.com/img.png',
          title: 'Test Widget',
          price: 49.99,
          availableQuantity: 50,
        );

        expect(product.id, equals('prod-123'));
        expect(product.imageURL, equals('https://example.com/img.png'));
        expect(product.title, equals('Test Widget'));
        expect(product.price, equals(49.99));
        expect(product.availableQuantity, equals(50));
      });

      test('creates product with zero price', () {
        final product = TestProducts.free;

        expect(product.price, equals(0.0));
      });

      test('creates product with zero quantity', () {
        final product = TestProducts.outOfStock;

        expect(product.availableQuantity, equals(0));
      });
    });

    group('equality', () {
      test('two products with same values are equal', () {
        final product1 = createTestProduct(id: 'same-id', title: 'Same Title');
        final product2 = createTestProduct(id: 'same-id', title: 'Same Title');

        expect(product1, equals(product2));
      });

      test('two products with different ids are not equal', () {
        final product1 = createTestProduct(id: 'id-1');
        final product2 = createTestProduct(id: 'id-2');

        expect(product1, isNot(equals(product2)));
      });

      test('two products with different prices are not equal', () {
        final product1 = createTestProduct(price: 10.0);
        final product2 = createTestProduct(price: 20.0);

        expect(product1, isNot(equals(product2)));
      });
    });

    group('copyWith', () {
      test('copies product with new id', () {
        final original = TestProducts.basic;
        final copied = original.copyWith(id: 'new-id');

        expect(copied.id, equals('new-id'));
        expect(copied.title, equals(original.title));
        expect(copied.price, equals(original.price));
      });

      test('copies product with new price', () {
        final original = TestProducts.basic;
        final copied = original.copyWith(price: 999.99);

        expect(copied.price, equals(999.99));
        expect(copied.id, equals(original.id));
      });

      test('copies product with new quantity', () {
        final original = TestProducts.basic;
        final copied = original.copyWith(availableQuantity: 0);

        expect(copied.availableQuantity, equals(0));
        expect(copied.title, equals(original.title));
      });

      test('copyWith without changes returns equal product', () {
        final original = TestProducts.basic;
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('JSON serialization', () {
      test('toJson returns correct map', () {
        final product = createTestProduct(
          id: 'json-test',
          imageURL: 'https://test.com/image.jpg',
          title: 'JSON Test Product',
          price: 19.99,
          availableQuantity: 25,
        );

        final json = product.toJson();

        expect(json['id'], equals('json-test'));
        expect(json['imageURL'], equals('https://test.com/image.jpg'));
        expect(json['title'], equals('JSON Test Product'));
        expect(json['price'], equals(19.99));
        expect(json['availableQuantity'], equals(25));
      });

      test('fromJson creates correct product', () {
        final json = TestProducts.basicJson;

        final product = Product.fromJson(json);

        expect(product.id, equals('test-product-id'));
        expect(product.imageURL, equals('https://example.com/image.jpg'));
        expect(product.title, equals('Test Product'));
        expect(product.price, equals(29.99));
        expect(product.availableQuantity, equals(100));
      });

      test('toJson and fromJson round-trip preserves data', () {
        final original = TestProducts.expensive;

        final json = original.toJson();
        final restored = Product.fromJson(json);

        expect(restored, equals(original));
      });
    });

    group('TestProducts factory', () {
      test('list generates correct number of products', () {
        final products = TestProducts.list(5);

        expect(products, hasLength(5));
      });

      test('list generates products with unique ids', () {
        final products = TestProducts.list(3);
        final ids = products.map((p) => p.id).toSet();

        expect(ids, hasLength(3));
      });

      test('list generates products with incrementing prices', () {
        final products = TestProducts.list(3);

        expect(products[0].price, equals(10.0));
        expect(products[1].price, equals(20.0));
        expect(products[2].price, equals(30.0));
      });
    });
  });
}
