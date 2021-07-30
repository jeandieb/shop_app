import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as OP; //Orders Provider

class OrderItem extends StatelessWidget {
  @required
  final orderIndex;

  OrderItem(this.orderIndex);

  @override
  Widget build(BuildContext context) {
    List<OP.OrderItem> orders = Provider.of<OP.Orders>(context).orders;
    return orders[orderIndex].isOrderEmpty()
        ? Container(
            width: 0.0,
            height:
                0.0) //empty invisible container that takes as less space as poss.
        : Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: Text('\$${orders[orderIndex].total}'),
                  subtitle: Text(
                    DateFormat('MM/dd/yyyy hh:mm')
                        .format(orders[orderIndex].orderDate),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.expand_more),
                    onPressed: (){
                      
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
