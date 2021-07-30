import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 150,
            width: double.infinity,
            color: Colors.brown,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Best Shop App Ever!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.shop,
                size: 30,
              ),
              title: Text('SHOP'),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ),
          Divider(color: Colors.brown, height: 1, thickness: 1,),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.payment,
                size: 30,
              ),
              title: Text('MY ORDERS'),
              onTap: () => Navigator.pushNamed(context, OrdersScreen.routeName),
            ),
          )
        ],
      ),
    );
  }
}
