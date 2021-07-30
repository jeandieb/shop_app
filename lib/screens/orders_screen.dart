import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as oiWidget;

class OrdersScreen extends StatelessWidget {

  static const String routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    List<OrderItem> ordersData =  Provider.of<Orders>(context, listen: true).orders;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: Column(children: [
        Expanded(child: ListView.builder(itemCount: ordersData.length ,itemBuilder: (context, index){
          return oiWidget.OrderItem(index); //send the index only and get the order using provider
        }))
      ]),
    );
  }
}
