import 'package:riverpod_template/models/item/item.dart';
import 'package:riverpod_template/models/order/order.dart';
import 'package:riverpod_template/core/enums/order_status_enum.dart';

/// Factory function to create test items with optional overrides
Item createTestItem({
  String? productID,
  int? quantity,
}) =>
    Item(
      productID: productID ?? 'test-product-id',
      quantity: quantity ?? 1,
    );

/// Factory function to create test orders with optional overrides
Order createTestOrder({
  String? id,
  String? userID,
  List<Item>? items,
  OrderStatus? status,
  DateTime? date,
  double? total,
}) =>
    Order(
      id: id ?? 'test-order-id',
      userID: userID ?? 'test-user-id',
      items: items ?? [createTestItem()],
      status: status ?? OrderStatus.processing,
      date: date ?? DateTime(2024, 1, 15, 10, 30),
      total: total ?? 99.99,
    );

/// Pre-built test item constants
class TestItems {
  TestItems._();

  /// Single item
  static Item get single => createTestItem();

  /// Item with multiple quantity
  static Item get bulk => createTestItem(
        productID: 'bulk-product',
        quantity: 10,
      );

  /// Generate a list of test items
  static List<Item> list(int count) => List.generate(
        count,
        (i) => createTestItem(
          productID: 'product-$i',
          quantity: i + 1,
        ),
      );

  /// JSON representation for testing fromJson
  static Map<String, dynamic> get basicJson => {
        'productID': 'test-product-id',
        'quantity': 1,
      };
}

/// Pre-built test order constants
class TestOrders {
  TestOrders._();

  /// Basic processing order
  static Order get processing => createTestOrder();

  /// Order waiting for delivery
  static Order get waitingForDelivery => createTestOrder(
        id: 'waiting-order',
        status: OrderStatus.waitingForDelivery,
        total: 129.99,
      );

  /// Order being delivered
  static Order get delivering => createTestOrder(
        id: 'delivering-order',
        status: OrderStatus.delivering,
        total: 89.99,
      );

  /// Completed order
  static Order get completed => createTestOrder(
        id: 'completed-order',
        status: OrderStatus.completed,
        total: 149.99,
      );

  /// Order with multiple items
  static Order get multipleItems => createTestOrder(
        id: 'multi-item-order',
        items: TestItems.list(3),
        total: 299.97,
      );

  /// Generate a list of test orders
  static List<Order> list(int count) => List.generate(
        count,
        (i) => createTestOrder(
          id: 'order-$i',
          total: (i + 1) * 50.0,
        ),
      );

  /// JSON representation for testing fromJson
  static Map<String, dynamic> get basicJson => {
        'id': 'test-order-id',
        'userID': 'test-user-id',
        'items': [TestItems.basicJson],
        'status': 'processing',
        'date': '2024-01-15T10:30:00.000',
        'total': 99.99,
      };
}
