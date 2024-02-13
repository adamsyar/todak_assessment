import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/order_obj.dart';

class OrderDetail extends StatelessWidget {
  final Order order;

  const OrderDetail({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: CupertinoColors.black,
        foregroundColor: CupertinoColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildOrderStatus(),
                    const SizedBox(height: 30),
                    buildOrderInfo('Date', order.date, 14),
                    buildDynamicDivider(),
                    buildOrderInfo('Delivery Address', '', 14),
                    const SizedBox(height: 10),
                    Text(order.address),
                    buildDynamicDivider(),
                    buildItemList(),
                    buildDynamicDivider(),
                    buildOrderInfo('Total',
                        'RM${order.totalPrice.toStringAsFixed(2)}', 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOrderStatus() {
    return const Center(
      child: Column(
        children: [
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            size: 70,
            color: CupertinoColors.activeGreen,
          ),
          Text(
            'Order Completed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.activeGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderInfo(
    String title,
    String value,
    double fontSize,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.black),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.black),
        ),
      ],
    );
  }

  Widget buildItemList() {
    return Column(
      children: order.cartItems
          .map((item) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CupertinoColors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        item.product.thumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: CupertinoColors.black),
                          ),
                          Row(
                            children: [
                              Text(
                                'Quantity: ${item.quantity}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: CupertinoColors.black),
                              ),
                              const Spacer(),
                              Text(
                                'RM${item.product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: CupertinoColors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget buildDynamicDivider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(),
    );
  }
}
