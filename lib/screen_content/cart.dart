import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Import flutter_slidable package
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/cart_obj.dart';
import 'package:todak_assessment/object/order_obj.dart';
import 'package:todak_assessment/object/profile_obj.dart';
import 'package:todak_assessment/screen_content/address.dart';
import 'package:todak_assessment/screen_content/widget/custom_elavated_button.dart';
import 'package:todak_assessment/screen_content/widget/inform_dialog.dart';
import 'package:todak_assessment/shared_preferences.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Future<List<CartItem>> _cartItemsFuture;
  String selectedAddress = '';

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    _cartItemsFuture = SharedPreferencesHandler.getCart();
    ProfileInfo profile = await SharedPreferencesHandler.getProfile();
    setState(() {
      selectedAddress = profile.addresses.isNotEmpty
          ? profile.addresses.first
          : 'No address available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        foregroundColor: CupertinoColors.white,
        backgroundColor: CupertinoColors.black,
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
                    return buildSlidableCartItemWidget(cartItems[index]);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildSlidableCartItemWidget(CartItem cartItem) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Slidable(
        key: ValueKey(cartItem),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) async {
                bool itemRemoved =
                    await SharedPreferencesHandler.removeCartItem(cartItem);
                if (itemRemoved) {
                  setState(() {
                    _cartItemsFuture = SharedPreferencesHandler.getCart();
                  });
                }
              },
              backgroundColor: CupertinoColors.destructiveRed,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: buildCartItemWidget(cartItem),
      ),
    );
  }

  Widget buildCartItemWidget(CartItem cartItem) {
    final product = cartItem.product;
    final itemPrice = product.price * cartItem.quantity;

    return Container(
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
                          color: CupertinoColors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomSection() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      // Navigate to the AddressListPage
                      context,
                      MaterialPageRoute(
                          builder: (context) => Address(
                                onAddressSelected: (address) {
                                  setState(() {
                                    selectedAddress = address;
                                  });
                                },
                                selectedAddress: selectedAddress,
                              )),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CupertinoColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      selectedAddress,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const CupertinoButton(
                                minSize: 0,
                                padding: EdgeInsets.only(
                                    left: 10, right: 0, bottom: 3, top: 0),
                                child: Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: CupertinoColors.black,
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
                                const Text(
                                  'Total',
                                  style: TextStyle(
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
      child: CustomButton(
        onPressed: () async {
          final cartItems = await SharedPreferencesHandler.getCart();

          if (cartItems.isNotEmpty) {
            String formattedDate =
                DateFormat('dd-MM-yyyy').format(DateTime.now());

            final order = Order(
              cartItems: cartItems,
              address: selectedAddress,
              totalPrice: await SharedPreferencesHandler.getTotalPriceInCart(),
              date: formattedDate, // Passing the formatted date
            );
            bool orderSaved = await SharedPreferencesHandler.saveOrder(order);
            if (orderSaved) {
              for (int i = 0; i < 1; i++) {
                Navigator.of(context).pop();
              }
              showInformDialog(context, title: 'Order Completed', popCount: 2);
            }

            _loadCartItems();
          } else {
            showInformDialog(context, title: 'Cart is Empty');
          }
        },
        text: 'Complete Order',
        backgroundColor: CupertinoColors.activeGreen,
        textColor: CupertinoColors.white,
      ),
    );
  }
}
