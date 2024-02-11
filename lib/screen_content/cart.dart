// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/cart_obj.dart';
import 'package:todak_assessment/object/order_obj.dart';
import 'package:todak_assessment/screen_content/widget/inform_dialog.dart';
import 'package:todak_assessment/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Future<List<CartItem>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    _cartItemsFuture = SharedPreferencesHandler.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Cart'),
      ),
      bottomNavigationBar: buildAddToCartButton(context),
      body: Column(
        children: [
          buildCartItemsSection(),
          buildBottomSection(),
        ],
      ),
    );
  }

  Widget buildCartItemsSection() {
    return Expanded(
      flex: 8,
      child: Center(
        child: FutureBuilder<List<CartItem>>(
          future: _cartItemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final cartItems = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return buildCartItemWidget(cartItems[index]);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildCartItemWidget(CartItem cartItem) {
    final product = cartItem.product;
    final itemPrice = product.price * cartItem.quantity;

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CupertinoColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity: ${cartItem.quantity}'),
                        Text(
                          'RM$itemPrice',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBottomSection() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'No 1, Jalan Desa Aman S10/1 Desa Aman,09410 Padang Serai Kedah',
                                    softWrap: true,
                                    maxLines: 2,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            CupertinoButton(
                              minSize: 0,
                              padding: EdgeInsets.only(
                                  left: 10, right: 0, bottom: 3, top: 0),
                              child: Icon(
                                CupertinoIcons.chevron_forward,
                                color: Colors.deepPurple,
                                size: 16,
                              ),
                              onPressed: null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<double>(
                        future: SharedPreferencesHandler.getTotalPriceInCart(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final totalPrice = snapshot.data!;
                            return Row(
                              children: [
                                Text(
                                  'Total',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'RM${totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  BottomAppBar buildAddToCartButton(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      color: CupertinoColors.white,
      child: buildCustomButton(
        context,
        () async {
          final cartItems = await SharedPreferencesHandler.getCart();
          final order = Order(
            cartItems: cartItems,
            address:
                'No 1, Jalan Desa Aman S10/1 Desa Aman,09410 Padang Serai Kedah', // You can change the address here
            totalPrice: await SharedPreferencesHandler.getTotalPriceInCart(),
          );
          bool orderSaved = await SharedPreferencesHandler.saveOrder(order);
          if (orderSaved) {
            bool cartCleared = await SharedPreferencesHandler.clearCart();
            if (cartCleared) {
              _loadCartItems();
              showInformDialog(context, title: 'Order Completed', popCount: 2);
            }
          }
        },
      ),
    );
  }

  ElevatedButton buildCustomButton(BuildContext context, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 56)),
      ),
      child: const Text(
        'Complete Order',
        style: TextStyle(color: CupertinoColors.white),
      ),
    );
  }
}
