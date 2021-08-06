import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  bool isOrderEmpty() {
    if (items.isEmpty)
      return true;
    else
      return false;
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double orderTotal) async{
    final url = Uri.parse(
        'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/orders.json');
    final dateTime = DateTime.now();
     final response = await http.post(url,
        body: json.encode({
          'total': orderTotal,
          'dateTime': dateTime.toIso8601String(),
          'products': cartProducts
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'price': prod.price,
                    'quantity': prod.quantity
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        total: orderTotal,
        items: cartProducts,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
