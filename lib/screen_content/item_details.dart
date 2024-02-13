import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/cart_obj.dart';
import 'package:todak_assessment/object/product_obj.dart';
import 'package:todak_assessment/screen_content/widget/custom_elavated_button.dart';
import 'package:todak_assessment/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        foregroundColor: CupertinoColors.white,
        backgroundColor: CupertinoColors.black,
        scrolledUnderElevation: 0,
        title: Text(widget.product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                widget.product.thumbnail,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 10),
            Text(
              'RM${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.description,
              style: const TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildAddToCartButton(context),
    );
  }

  BottomAppBar buildAddToCartButton(BuildContext context) {
    return BottomAppBar(
      color: CupertinoColors.white,
      child: CustomButton(
        onPressed: () {
          buildBottomSheet(context);
        },
        text: 'Add to Cart',
        iconData: Icons.shopping_cart,
      ),
    );
  }

  Future<dynamic> buildBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 250,
              decoration: const BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Image.network(
                          widget.product.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                buildCounter(setState),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CustomButton(
                    onPressed: () async {
                      bool success = await SharedPreferencesHandler.saveCart([
                        CartItem(
                          product: widget.product,
                          quantity: counter,
                        ),
                      ]);

                      if (success) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Item Added to Cart ')),
                        );
                      } else {
                        print('Failed to save cart.');
                      }
                    },
                    text: 'Add to Cart',
                    iconData: Icons.shopping_cart,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Container buildCounter(StateSetter setState) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.remove_circle,
              size: 25,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                if (counter > 1) counter--;
              });
            },
          ),
          Text(
            counter.toString(),
            style: const TextStyle(fontSize: 18),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.add_circle,
              size: 25,
              color: CupertinoColors.black,
            ),
            onPressed: () {
              setState(() {
                counter++;
              });
            },
          ),
        ],
      ),
    );
  }
}
