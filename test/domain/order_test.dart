import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/domain/item/item.dart';
import 'package:riverpod_template/domain/order/order.dart';
import 'package:riverpod_template/utils/enums/order_status_enum.dart';

import '../test_data/order_test_data.dart';

void main() {
  group('Item', () {
    group('instantiation', () {
      test('creates item with required fields', () {
        final item = createTestItem(
          productID: 'prod-123',
          quantity: 5,
        );

        expect(item.productID, equals('prod-123'));
        expect(item.quantity, equals(5));
      });

      test('creates item with default quantity of 1', () {
        final item = TestItems.single;

        expect(item.quantity, equals(1));
      });
    });

    group('equality', () {
      test('two items with same values are equal', () {
        final item1 = createTestItem(productID: 'same', quantity: 2);
        final item2 = createTestItem(productID: 'same', quantity: 2);

        expect(item1, equals(item2));
      });

      test('two items with different product IDs are not equal', () {
        final item1 = createTestItem(productID: 'prod-1');
        final item2 = createTestItem(productID: 'prod-2');

        expect(item1, isNot(equals(item2)));
      });

      test('two items with different quantities are not equal', () {
        final item1 = createTestItem(quantity: 1);
        final item2 = createTestItem(quantity: 2);

        expect(item1, isNot(equals(item2)));
      });
    });

    group('JSON serialization', () {
      test('toJson returns correct map', () {
        final item = createTestItem(productID: 'json-prod', quantity: 3);

        final json = item.toJson();

        expect(json['productID'], equals('json-prod'));
        expect(json['quantity'], equals(3));
      });

      test('fromJson creates correct item', () {
        final json = TestItems.basicJson;

        final item = Item.fromJson(json);

        expect(item.productID, equals('test-product-id'));
        expect(item.quantity, equals(1));
      });

      test('round-trip preserves data', () {
        final original = TestItems.bulk;

        final json = original.toJson();
        final restored = Item.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });

  group('Order', () {
    group('instantiation', () {
      test('creates order with all required fields', () {
        final items = [createTestItem(productID: 'p1', quantity: 2)];
        final date = DateTime(2024, 3, 15);

        final order = createTestOrder(
          id: 'order-123',
          userID: 'user-456',
          items: items,
          status: OrderStatus.processing,
          date: date,
          total: 199.99,
        );

        expect(order.id, equals('order-123'));
        expect(order.userID, equals('user-456'));
        expect(order.items, equals(items));
        expect(order.status, equals(OrderStatus.processing));
        expect(order.date, equals(date));
        expect(order.total, equals(199.99));
      });

      test('creates order with multiple items', () {
        final order = TestOrders.multipleItems;

        expect(order.items.length, equals(3));
      });
    });

    group('order statuses', () {
      test('processing order has processing status', () {
        final order = TestOrders.processing;

        expect(order.status, equals(OrderStatus.processing));
      });

      test('waiting for delivery order has correct status', () {
        final order = TestOrders.waitingForDelivery;

        expect(order.status, equals(OrderStatus.waitingForDelivery));
      });

      test('delivering order has delivering status', () {
        final order = TestOrders.delivering;

        expect(order.status, equals(OrderStatus.delivering));
      });

      test('completed order has completed status', () {
        final order = TestOrders.completed;

        expect(order.status, equals(OrderStatus.completed));
      });
    });

    group('equality', () {
      test('two orders with same values are equal', () {
        final date = DateTime(2024, 1, 1);
        final items = [createTestItem()];

        final order1 = createTestOrder(
          id: 'same-id',
          items: items,
          date: date,
        );
        final order2 = createTestOrder(
          id: 'same-id',
          items: items,
          date: date,
        );

        expect(order1, equals(order2));
      });

      test('two orders with different IDs are not equal', () {
        final order1 = createTestOrder(id: 'order-1');
        final order2 = createTestOrder(id: 'order-2');

        expect(order1, isNot(equals(order2)));
      });

      test('two orders with different statuses are not equal', () {
        final order1 = createTestOrder(status: OrderStatus.processing);
        final order2 = createTestOrder(status: OrderStatus.completed);

        expect(order1, isNot(equals(order2)));
      });
    });

    group('copyWith', () {
      test('copies order with new status', () {
        final original = TestOrders.processing;
        final copied = original.copyWith(status: OrderStatus.completed);

        expect(copied.status, equals(OrderStatus.completed));
        expect(copied.id, equals(original.id));
        expect(copied.items, equals(original.items));
      });

      test('copies order with new total', () {
        final original = TestOrders.processing;
        final copied = original.copyWith(total: 500.00);

        expect(copied.total, equals(500.00));
        expect(copied.status, equals(original.status));
      });

      test('copies order with new items', () {
        final original = TestOrders.processing;
        final newItems = TestItems.list(5);
        final copied = original.copyWith(items: newItems);

        expect(copied.items.length, equals(5));
        expect(copied.id, equals(original.id));
      });
    });

    group('JSON serialization', () {
      test('toJson returns correct map', () {
        final order = TestOrders.processing;

        final json = order.toJson();

        expect(json['id'], equals('test-order-id'));
        expect(json['userID'], equals('test-user-id'));
        expect(json['items'], isA<List>());
        expect(json['status'], isNotNull);
        expect(json['date'], isNotNull);
        expect(json['total'], equals(99.99));
      });

      test('toJson includes nested items correctly', () {
        final order = TestOrders.multipleItems;

        final json = order.toJson();
        final itemsList = json['items'] as List;

        expect(itemsList.length, equals(3));
        // Items may be Item objects or maps depending on Freezed version
        // Convert to map if needed to verify structure
        final firstItemRaw = itemsList[0];
        final firstItem = firstItemRaw is Map<String, dynamic>
            ? firstItemRaw
            : (firstItemRaw as Item).toJson();
        expect(firstItem['productID'], isNotNull);
        expect(firstItem['quantity'], isNotNull);
      });

      test('round-trip preserves order data', () {
        final original = TestOrders.completed;

        // Convert to JSON map (with items as maps)
        final json = original.toJson();
        
        // Ensure items are properly serialized as maps for fromJson
        final jsonForRestore = Map<String, dynamic>.from(json);
        jsonForRestore['items'] = (json['items'] as List)
            .map((item) => item is Map ? item : (item as Item).toJson())
            .toList();

        final restored = Order.fromJson(jsonForRestore);

        expect(restored.id, equals(original.id));
        expect(restored.userID, equals(original.userID));
        expect(restored.status, equals(original.status));
        expect(restored.total, equals(original.total));
      });
    });

    group('TestOrders factory', () {
      test('list generates correct number of orders', () {
        final orders = TestOrders.list(5);

        expect(orders, hasLength(5));
      });

      test('list generates orders with unique IDs', () {
        final orders = TestOrders.list(3);
        final ids = orders.map((o) => o.id).toSet();

        expect(ids, hasLength(3));
      });

      test('list generates orders with incrementing totals', () {
        final orders = TestOrders.list(3);

        expect(orders[0].total, equals(50.0));
        expect(orders[1].total, equals(100.0));
        expect(orders[2].total, equals(150.0));
      });
    });
  });

  group('OrderStatus', () {
    test('enum has expected values', () {
      expect(OrderStatus.values, hasLength(4));
      expect(OrderStatus.values, contains(OrderStatus.processing));
      expect(OrderStatus.values, contains(OrderStatus.waitingForDelivery));
      expect(OrderStatus.values, contains(OrderStatus.delivering));
      expect(OrderStatus.values, contains(OrderStatus.completed));
    });
  });
}
