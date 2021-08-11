import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

//used mixins to allow the class to use ChangeNotifier functionalities
class Products with ChangeNotifier {
  String _authToken;
  String _userId;
  Products(this._authToken, this._userId, this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // )
  ];
  //_items must be private and only changable through this classes methods so it can notify listeners

  //of the changes made...
  //that why we return a copy of the instance so it can't be changed
  List<Product> get items {
    return [
      ..._items
    ]; //returns a copy of items, and not a reference to the object
  }

  List<Product> get filteredItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  //work with async code using .then and .catch error
  // Future<void> addProduct(Product newProduct) {
  //   final url = Uri.parse(
  //       'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/products.json');
  //   //returning the whole block because post return future and then also return future
  //   //in this case Future of the then will be returned once the then block executes and a product is added
  //   return http
  //       .post(url,
  //           body: json.encode({
  //             'title': newProduct.title,
  //             'price': newProduct.price,
  //             'description': newProduct.description,
  //             'imageUrl': newProduct.imageUrl,
  //             'isFavorite': newProduct.isFavorite
  //           }))
  //       .then((response) {
  //     final Product toBeAdded = Product(
  //         title: newProduct.title,
  //         price: newProduct.price,
  //         description: newProduct.description,
  //         imageUrl: newProduct.imageUrl,
  //         id: json.decode(response.body)['name']);
  //     _items.add(toBeAdded);
  //     notifyListeners();
  //   }).catchError((error) {
  //     print(error);
  //     throw error; //throwing the error here to catch it in edit product screen where we get stuck in a circular progesses indicator in case of errors.
  //   });
  // }

  //work with async code using async and await
  //neater and more readable way
  //explained in lecture 246
  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse(
        'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/products.json?auth=$_authToken');
    //returning the whole block because post return future and then also return future
    //in this case Future of the then will be returned once the then block executes and a product is added
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'creatorId': _userId
          }));
      final Product toBeAdded = Product(
          title: newProduct.title,
          price: newProduct.price,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(toBeAdded);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; //throwing the error here to catch it in edit product screen where we get stuck in a circular progesses indicator in case of errors.
    }
  }

  //use [] to make a parameter optional with a default value, not {} (named parameter)
  //this method is used in product overview and user product, in overview we want to see all products
  //not only user specific product so we pass a bool to see if we need to filter products or not
  //all filtering happens on the sever not the client
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    //fitter products by creator Id so that users can only edit products they created/own
    //IMPORTANT!! to be able to filter we need to change firebase rules i.e "products": {".indexOn": ["creatorId"]}  must be added under read and write
    var url = Uri.parse(
        'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString');
    try {
      var response = await http.get(url);
      //print(json.decode(response.body)); //FireBase return Map<String, Map> for Products where String is the ID
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; //dart does not understand a Map with Map values
      final List<Product> loadedProducts = [];

      //get user specific favorties using his id
      url = Uri.parse(
          'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');
      response = await http.get(url);
      final favoriteData = json.decode(
          response.body); //Map<String, bool) productId and bool for favorite

      if (extractedData == null) return;

      extractedData.forEach((prodId, productData) {
        loadedProducts.add(Product(
            id: prodId,
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            title: productData['title'],
            //?? checks if the value before it is null
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      //we throw error here but we do not handle it in products_overview_screen... not the focus of the module
      print(error);
      throw (error);
    }
  }

  //the logic is done in Product.dart
  // Future<void> updateProductFavorite(String id, Product prod) async {
  //   final url = Uri.parse(
  //       'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/products/$id.json');

  //   final response = await http.patch(url,
  //       body: json.encode({'isFavorite': prod.isFavorite}));
  //   if (response.statusCode >= 400) {
  //     prod.toggleFavoriteStatus();
  //     notifyListeners();
  //     throw HttpException('Failed to change favorite');
  //   }

  //   notifyListeners();
  // }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[
        existingProductIndex]; //remove product from _list but keep a copy of it
    _items.removeAt(existingProductIndex);
    notifyListeners();
    //on error we roll back delete locally
    //this is called optimistic update

    //for get and post http package throws an error when something go wrong (status code >= 400)
    //it does not for delete so we have to throw our own error.
    // http.delete(url).then((response) {
    //   if(response.statusCode >= 400)
    //   {
    //     throw HttpException('Failed to delete');
    //   }
    //   existingProduct = null;
    // }).catchError((_) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    // });

    //Same code as above but using async and await
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Failed to delete');
    }
    existingProduct = null;
  }

  void updateUser(String token, String id) {
    this._userId = id;
    this._authToken = token;
    notifyListeners();
  }
}
