import 'package:flutter/material.dart';
import 'package:simucash/data_architecture.dart';
import 'login_page.dart';


void main() {
  var allAccount = <Account>[];
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var allAccounts = <Account>[];

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
