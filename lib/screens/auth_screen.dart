import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(children: [
          //background
          Container(
            height: deviceSize.height - mediaQuery.padding.top,
            width: deviceSize.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.amber[700],
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              //color: Colors.white60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber[700],
                            Theme.of(context).primaryColor,
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: deviceSize.width * 0.7,
                      height: deviceSize.height * 0.13,
                      child: Center(
                          child: Text(
                        'My Shop',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60,
                        ),
                      )),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        width: deviceSize.width * 0.7,
                        height: deviceSize.height * 0.6,
                        //color: Colors.green,
                        child: AuthCard()),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  Map<String, String> _authData = {'email': '', 'password': ''};
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login)
      setState(() {
        _authMode = AuthMode.Signup;
      });
    else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred..'),
              content: Text(errorMessage),
              actions: [TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Okay'))],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .singup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS'))
        errorMessage = 'This email address is already used';
      if (error.toString().contains('INVALID_EMAIL'))
        errorMessage = 'This is not a valid email address';
      if (error.toString().contains('WEAK_PASSWORD'))
        errorMessage = 'This password is too weak';
      if (error.toString().contains('INVALID_PASSWORD'))
        errorMessage = 'Wrong password';
      _showErrorDialog(errorMessage);

    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!value.contains('@')) return 'Invalid email address';
                  return null;
                },
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _authData['email'] = value;
                }),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 15),
            child: TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.length < 5) {
                  return 'choose a longer password';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
          ),
          if (_authMode == AuthMode.Signup)
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 50),
              child: TextFormField(
                enabled: _authMode == AuthMode.Signup,
                decoration: InputDecoration(labelText: 'Confirm password'),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text)
                    return 'password does not match';
                  return null;
                },
              ),
            ),
          // Stack(children: [
          //   Positioned.fill(
          //    child:
          //     Container(
          //       width: 200, height: 50,
          //       decoration: BoxDecoration(border: Border.all(),
          //           borderRadius: BorderRadius.circular(10),
          //           boxShadow: [
          //             BoxShadow(
          //                 color: Colors.black.withOpacity(0.5),
          //                 spreadRadius: 1,
          //                 blurRadius: 6,
          //                 offset: Offset(5, 8))
          //           ],
          //           color: Colors.orange,
          //           shape: BoxShape.rectangle),
          //     ),
          //  ),
          //   _isLoading
          //       ? Center(child: CircularProgressIndicator())
          //       : TextButton(
          //           //style: ButtonStyle(backgroundColor: Colors.deepOrange),
          //           child: _authMode == AuthMode.Login
          //               ? Text(
          //                   'Log In',
          //                   style: TextStyle(fontWeight: FontWeight.bold),
          //                 )
          //               : Text(
          //                   'Sign Up',
          //                   style: TextStyle(fontWeight: FontWeight.bold),
          //                 ),
          //           onPressed: _submit),
          // ]),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.orange,
                ))
              : ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _authMode == AuthMode.Login ? 'Log In' : 'Sign up',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),

          TextButton(
            child: _authMode == AuthMode.Login
                ? Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white54),
                  )
                : Text(
                    'Log In',
                    style: TextStyle(color: Colors.white54),
                  ),
            onPressed: _switchAuthMode,
          )
        ],
      )),
    );
  }
}
