import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit_Product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController =
      TextEditingController(); //allows us to access user's input before
  // the form is sumbitted
  final _imageUrlFocusNode = FocusNode();
  final _form =
      GlobalKey<FormState>(); //so we can access Form widget from outside build

  Product _editedProduct =
      Product(id: null, title: '', description: '', price: 0.0, imageUrl: '');

  @override
  void initState() {
    //add listenr to the focus node to listen on changes in focus
    // in the attached TextFormField..
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _saveForm() {
    bool isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      print(_editedProduct.title);
      print(_editedProduct.description);
      print(_editedProduct.price);
      print(_editedProduct.imageUrl);
    }
  }

  //we need to dispose of focus node manually, otherwise they stick in memeory
  //this has to be done in STATE
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(
        _updateImageUrl); //call remove listener before disposing of the Focus Node
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!(_imageUrlController.text.startsWith('http') ||
              _imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('jpeg')))
              return;
    setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
          title: Text('Edit Product'),
        ),
        body: Form(
            key: _form,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: //ListView(children: [ BAD PRACTICE! LIST VIEW RECYCLES ITEMS THAT ARE NOT IN VIEW
                    //USER INPUT WILL BE LOST WHEN A USER SCROLL DOWN OR UP AND SOME WIDGETS BECOME UNVISIBLE
                    //SOLUTION... SingleChildScrollView does not recycles widgets out of view
                    SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (newValue) => _editedProduct = new Product(
                          id: null,
                          title: newValue,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl),
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter a title';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (newValue) => _editedProduct = new Product(
                          id: null,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue),
                          imageUrl: _editedProduct.imageUrl),
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a price';
                        if (double.tryParse(value) == null)
                          return 'Please enter a valid price (i.e. 12.99)';
                        if (double.parse(value) <= 0)
                          return 'Please enter a number greater than 0';
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      //textInputAction: TextInputAction.next,
                      maxLines:
                          3, // we can't use focus node to go to the next field when we use multi line input !
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,

                      onSaved: (newValue) => _editedProduct = new Product(
                          id: null,
                          title: _editedProduct.title,
                          description: newValue,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl),
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a description';
                        if (value.length < 10)
                          return 'Should be more than 10 characters';
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? (Text(' Enter a URL'))
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  )),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (newValue) => _editedProduct = new Product(
                                id: null,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue),
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please enter an image URL';
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https'))
                                return 'Please enter a valid URL';
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('jpeg'))
                                return 'Please enter a vliad image URL';

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
                ))));
  }
}
