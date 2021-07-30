import 'package:flutter/material.dart';

class UserProduct extends StatelessWidget {
  final String productTitle;
  final String productImageUrl;

  UserProduct(this.productTitle, this.productImageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(productImageUrl),),
      title: Text(productTitle),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ), //edit product

            IconButton(
                onPressed: () {}, //delete a product 
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ))
          ],
        ),
      ),
    );
  }
}
