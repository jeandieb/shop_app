import 'package:flutter/foundation.dart';
import 'cart.dart';

class OrderItem {
  @required
  String id;
  @required
  double total;
  @required
  List<CartItem> items;
  @required
  DateTime orderDate;

  OrderItem({this.id, this.total, this.items, this.orderDate});

  bool isOrderEmpty ()
  {
    if(items.isEmpty) return true;
    else return false;
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double orderTotal) {
    _orders.insert(0, OrderItem(
        id: DateTime.now().toString(),
        total: orderTotal,
        items: cartProducts,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }


}
