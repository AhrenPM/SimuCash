import 'package:flutter/material.dart';
import 'package:simucash/data_architecture.dart';
import 'home_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  userCard ownerCard = userCard('0001',100);
  Account User = Account('user1', '1234', userCard('0001',100));

  final username = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                  padding: EdgeInsets.all(16),
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            hintText: 'Please enter your password here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (username) {
                            if (username == User.u_id) {
                              return null;
                            }
                            else if (username != null && username.isEmpty) {
                              return 'Enter a user ID';
                            }
                            else if (username != null && username != User.u_id){
                              return 'Incorrect user ID';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Please enter your password here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (password) {
                            if (password == User.password) {
                              return null;
                            }
                            else if (password != null && password.isEmpty) {
                              return 'Enter a password';
                            }
                            else if (password != null && password != User.password){
                              return 'Incorrect password';
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15.0, bottom: 0.0),
                        ),
                        TextButton(
                          onPressed: () {
                            // Forgot password
                            // TODO FORGOT PASSWORD SCREEN GOES HERE
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
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
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) =>
                                    HomePage(ownerCard: User.cards)));
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
            const Text('New User? Create Account'),
          ],
        ),
      ),
    );
  }
}