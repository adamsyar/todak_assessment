import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todak_assessment/api/product_api.dart';
import 'package:todak_assessment/bloc/product_bloc.dart';
import 'package:todak_assessment/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ProductApi productApi = ProductApi();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(productApi)..add(FetchProduct()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}


const Color primaryBackgroundColor = Color(0xFFF2F1F6);
