import 'package:flutter/material.dart';
import 'package:simucash/data_architecture.dart';
import 'create_account_page.dart';
import 'home_page.dart';

class Login extends StatefulWidget {

  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var allAccounts = <Account>[Account('user1', '1234', userCard('0001',100))];
  final username = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int indexCheck = -1;
  late Account loggedInUser;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white),
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
                          controller: username,
                          decoration: const InputDecoration(
                            hintText: 'Username',
                            border: OutlineInputBorder(),
                            labelText: 'Enter your username',
                          ),
                          validator: (username) {
                            if (username != null && checkUsername(username) != -1) {
                              indexCheck = checkUsername(username);
                              return null;
                            }
                            else if (username != null && username.isEmpty) {
                              return 'Enter a user ID';
                            }
                            else if (username != null && checkUsername(username) == -1){
                              return 'Invalid user ID';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                            labelText: 'Enter your password',
                          ),
                          validator: (password) {
                            if (password != null && indexCheck != -1 && allAccounts[indexCheck].password == password) {
                              return null;
                            }
                            else if (password != null && password.isEmpty) {
                              return 'Enter a password';
                            }
                            else if (password != null && indexCheck != -1 && allAccounts[indexCheck].password != password){
                              return 'Incorrect password';
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
                        ),
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: const Color(0xffbe9e44),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              // Create Account
                              if (_formKey.currentState!.validate()) {
                                username.clear();
                                password.clear();
                                loggedInUser = allAccounts[indexCheck];
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) =>
                                    HomePage(ownerCard: loggedInUser.primary_card)));
                              }
                            },
                            child: const Text(
                              'Login',
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

            const SizedBox(
              height: 80,
            ),
            TextButton(
              onPressed: () {
                _asyncTransferPage(context);
              },
              child: const Text(
                'Create Account',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _asyncTransferPage(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(allAccounts: allAccounts),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      allAccounts = result;
    });
  }

  int checkUsername(String userName){
    var index = -1;
    for (var i = 0; i<allAccounts.length; i++){
      if (allAccounts[i].username == userName){
        index = i;
      }
    }
    return index;
  }

  int checkPassword(String userPass){
    var index = -1;
    for (var i = 0; i<allAccounts.length; i++){
      if (allAccounts[i].password == userPass){
        index = i;
      }
    }
    return index;
  }
}