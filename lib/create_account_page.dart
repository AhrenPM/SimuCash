import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'data_architecture.dart';

import 'login_page.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final username = TextEditingController();
  final cardID = TextEditingController();
  final usercard = TextEditingController();
  final password = TextEditingController();
  final repeatpassword = TextEditingController();


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
              child: TextField(
                controller: cardID,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card Number',
                    hintText: 'Enter your SimuCash Card Number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15.0, bottom: 0.0),
              child: TextField(
                controller: username,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15.0, bottom: 0.0),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your new password',
                ),
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15.0, bottom: 2.0),
              child: TextField(
                controller: repeatpassword,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Enter matching password',
                ),
              ),
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
                  var card = userCard(cardID.text, 300);
                  var account =Account(cardID.text, password.text, card);
                  final waitDuration = waitTime();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Creating your account'),
                      duration: Duration(milliseconds: waitDuration),
                    ),
                  );
                  Timer(Duration(milliseconds: waitDuration+((waitDuration)/100).round()), () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text("You have successfully created your account."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) => Login()));
                              },
                              child: const Text('Return to login page'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                child: const Text(
                  'Create Your Account',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int waitTime(){
    Random time = new Random();
    return time.nextInt(1000)+3000;
  }
}