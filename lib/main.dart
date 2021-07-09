import 'package:flutter/material.dart';
import 'package:stockit/app/sign-in/sign_in_page.dart';
import 'app/ItemsList.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockIt',
      theme: ThemeData(

        primarySwatch: Colors.indigo,
      ),
      home: itemlist(),

    );
  }
}