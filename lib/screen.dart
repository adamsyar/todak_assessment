import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todak_assessment/api/product_api.dart';
import 'package:todak_assessment/bloc/product_bloc.dart';
import 'package:todak_assessment/screen_content/cart.dart';
import 'package:todak_assessment/screen_content/menu.dart';
import 'package:todak_assessment/screen_content/order.dart';
import 'package:todak_assessment/screen_content/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductApi productApi = ProductApi();
  int _selectedIndex = 0;

  static const TextStyle appbarStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, color: CupertinoColors.white);

  static final List<Widget> widgetOptions = <Widget>[
    Menu(),
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
    return PopScope(
      canPop: false,
      child: BlocProvider(
        create: (context) => ProductBloc(productApi)..add(FetchProduct()),
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: CupertinoColors.black,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/Todak_lightmode.png',
                    height: 35,
                    width: 35,
                    color: CupertinoColors.white,
                  ),
                  const SizedBox(width: 5),
                  title.elementAt(_selectedIndex),
                ],
              ),
            ),
            leadingWidth: 300,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: CupertinoColors.white,
                ),
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
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: CupertinoColors.black,
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
                icon: Icon(
                  Icons.person,
                ),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: CupertinoColors.activeBlue,
            unselectedItemColor: CupertinoColors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
