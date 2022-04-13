import 'dart:async';
import 'Widgets.dart';

import 'package:flutter/material.dart';
import 'data_architecture.dart';

import 'login_page.dart';

class CreateAccount extends StatefulWidget {
  var allAccounts = <Account>[];

  CreateAccount({Key? key, required this.allAccounts}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final username = TextEditingController();
  final cardID = TextEditingController();
  final usercard = TextEditingController();
  final password = TextEditingController();
  final repeatpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    username.dispose();
    cardID.dispose();
    usercard.dispose();
    password.dispose();
    repeatpassword.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/simucash_logo.png',
          fit: BoxFit.cover,
          height: 40,
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child:
            const Text('Back', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Container(
                  width: 300,
                  height: 225,
                  child: Image.asset('assets/images/simucash_logo_light.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: cardID,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter your SimuCash Card Number',
                              hintText: 'Card Number'),
                          validator: (cardID) {
                            if (cardID != null && cardAssigned(cardID) == false) {
                              return null;
                            }
                            else if (cardID != null && cardID.isEmpty) {
                              return 'Enter a card number';
                            }
                            else if (cardID != null && cardAssigned(cardID) == true){
                              return 'Card already in use. Enter a different card number.';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: username,
                          decoration: const InputDecoration(
                            labelText: 'Please enter your username here',
                            hintText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                          validator: (username) {
                            if (username != null && userNameExists(username) == false) {
                              return null;
                            }
                            else if (username != null && username.isEmpty) {
                              return 'Enter a username';
                            }
                            else if (username != null && userNameExists(username) == true){
                              return 'Username taken. Choose a different username.';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Enter a strong password with at least 8 characters, with least an upper&lowercase character and a digit',
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (password) {
                            if (password != null && isStrongPassword(password) == true) {
                              return null;
                            }
                            else if (password != null && password.isEmpty) {
                              return 'Enter a password';
                            }
                            else if (password != null && isStrongPassword(password) == false){
                              return 'Password too weak. Please enter a stronger password';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: repeatpassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter matching password from above',
                            hintText: 'Confirm Password',
                          ),
                          validator: (repeatpassword) {
                            if (repeatpassword != null && repeatpassword==password.text) {
                              return null;
                            }
                            else if (repeatpassword != null && repeatpassword.isEmpty) {
                              return 'Re-enter password';
                            }
                            else if (repeatpassword != null && repeatpassword!=password.text){
                              return 'Password doesn\'t match. Please re-confirm password.';
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          decoration: BoxDecoration(
                              color: const Color(0xffbe9e44),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()){
                                var card = userCard(cardID.text, receivedAmount());
                                var account =Account(username.text, password.text, card);
                                widget.allAccounts.add(account);
                                final waitDuration = waitTime();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Creating your account'),
                                    duration: Duration(milliseconds: waitDuration),
                                  ),
                                );
                                cardID.clear();
                                username.clear();
                                password.clear();
                                repeatpassword.clear();
                                Timer(Duration(milliseconds: waitDuration+((waitDuration)/100).round()), () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: const Text("You have successfully created your account."),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,widget.allAccounts);
                                            },
                                            child: const Text('Return'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }

                            },
                            child: const Text(
                              'Create Your Account',
                              style: TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      ], //Form Children
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool cardAssigned(String cardID){
    bool exist = false;
    for (var i = 0; i<widget.allAccounts.length; i++){
      for (var j = 0; j<widget.allAccounts[i].cards.length; j++){
        if (widget.allAccounts[i].cards[j].card_key == cardID){
          exist = true;
          return exist;
        }
      }

    }
    return exist;
  }

  bool userNameExists(String userName){
    bool exist = false;
    for (var i = 0; i<widget.allAccounts.length; i++){
      if (widget.allAccounts[i].username == userName){
        exist = true;
        return exist;
      }
    }
    return exist;
  }

  bool isStrongPassword(String password) {
    bool check = true;
    if (password.length < 8) {
      check = false;
      return check;
    }
    else if (!password.contains(RegExp(r"[a-z]"))){
      check = false;
      return check;
    }
    if (!password.contains(RegExp(r"[A-Z]"))) {
        check = false;
        return check;
    }
    if (!password.contains(RegExp(r"[0-9]"))) {
      check = false;
      return check;
    }
    return check;
  }
}