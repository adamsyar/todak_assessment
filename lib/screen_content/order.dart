import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todak_assessment/object/order_obj.dart';
import 'package:todak_assessment/shared_preferences.dart';

class CompletedOrder extends StatefulWidget {
  @override
  State<CompletedOrder> createState() => _CompletedOrderState();
}

class _CompletedOrderState extends State<CompletedOrder> {
  late Future<List<Order>> _orderFuture; // Change Future type to List<Order>

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    _orderFuture = SharedPreferencesHandler.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<List<Order>>(
          future: _orderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitChasingDots(
                  color: Colors.deepPurple,
                  size: 40,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final orders = snapshot.data;
              if (orders != null && orders.isNotEmpty) {
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display order items
                        for (var cartItem in order.cartItems)
                          ListTile(
                            title: Text(cartItem.product.title),
                            subtitle: Text(
                                'Price: \$${cartItem.product.price.toStringAsFixed(2)}'),
                            // Add more details if needed
                          ),
                        // Display total price
                        Text(
                          'Total Price: \$${order.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20),
                        ),
                        // Display address
                        Text(
                          'Address: ${order.address}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Divider(), // Add divider between orders
                      ],
                    );
                  },
                );
              } else {
                return Text('No orders found.');
              }
            }
          },
        ),
      ),
    );
  }
}
