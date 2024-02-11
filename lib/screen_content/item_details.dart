import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todak_assessment/bloc/product_bloc.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/cart_obj.dart';
import 'package:todak_assessment/object/product_obj.dart';

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
        backgroundColor: CupertinoColors.white,
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
            Row(
              children: [
                Text(
                  widget.product.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'RM${widget.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
      child: buildCustomButton(context, () {
        buildBottomSheet(context);
      }),
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
        // Define fixed button height
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 56)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 20,
            color: CupertinoColors.white,
          ), // Add cart icon here
          SizedBox(width: 5),
          Text(
            'Add to Cart',
            style: TextStyle(color: CupertinoColors.white),
          ),
        ],
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
                color: Colors.white,
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
                            borderRadius: BorderRadius.circular(10)),
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
                                fontSize: 20,
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
                  // Inside buildBottomSheet method
                  buildCustomButton(context, () {
                    BlocProvider.of<ProductBloc>(context).add(StoreCartItems([
                      CartItem(
                        product: widget.product,
                        quantity: counter,
                      )
                    ]));
                  }),

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
              color: Colors.blue,
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
