import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todak_assessment/api/product_api.dart';
import 'package:todak_assessment/bloc/product_bloc.dart';
import 'package:todak_assessment/screen_content/cart.dart';
import 'package:todak_assessment/screen_content/home.dart';
import 'package:todak_assessment/screen_content/order.dart';
import 'package:todak_assessment/screen_content/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductApi productApi = ProductApi();
  int _selectedIndex = 0;

  static const TextStyle appbarStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  static final List<Widget> widgetOptions = <Widget>[
    Home(),
    CompletedOrder(),
    Profile(),
  ];

  static const List<Widget> title = <Widget>[
    Text(
      'eShop',
      style: appbarStyle,
    ),
    Text(
      'Order',
      style: appbarStyle,
    ),
    Text(
      'Profile',
      style: appbarStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(productApi)..add(FetchProduct()),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: title.elementAt(_selectedIndex),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart), // Use whatever icon you prefer
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(),
                  ),
                );
              },
            ),
          ],
        ),
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: CupertinoColors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepPurple,
      onTap: _onItemTapped,
    );
  }
}
