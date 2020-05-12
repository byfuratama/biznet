import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/auth.dart';
import '../models/http_exception.dart';

// import '../providers/auth.dart';
// import '../models/http_exception.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  // final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
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
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'],
        _authData['password'],
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
      print({'err' : error});
    } catch (error) {
      const errorMessage =
          'Tidak bisa login. Mohon coba lagi';
      _showErrorDialog(errorMessage);
      print({'error' : error});
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    final InputDecoration boxDecoration = InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.accentColor, width: 1.0),
        ),
        fillColor: Colors.white60,
        filled: true,
        labelStyle: TextStyle(color: Colors.white));

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Biznet Branch Ubud \nWork Order',
                style: theme.textTheme.display1.copyWith(color: Colors.white),
              ),
              Container(
                height: deviceSize.height - 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: theme.textTheme.display2
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            TextFormField(
                              initialValue: 'fefe@biznet.com',
                              decoration:
                                  boxDecoration.copyWith(labelText: 'Username'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['email'] = value;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              initialValue: 'fefefefe',
                              obscureText: true,
                              decoration:
                                  boxDecoration.copyWith(labelText: 'Password'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                            ),
                            SizedBox(height: 10),
                            if (_isLoading)
                              CircularProgressIndicator()
                            else
                              RaisedButton(
                                onPressed: _submit,
                                color: theme.accentColor,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
