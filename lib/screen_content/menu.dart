import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todak_assessment/bloc/product_bloc.dart';
import 'package:todak_assessment/object/product_obj.dart';
import 'package:todak_assessment/screen_content/item_details.dart';
import 'package:todak_assessment/screen_content/widget/item_container.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Menu extends StatefulWidget {
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String? selectedCategory;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    // Get current time
    DateTime now = DateTime.now();
    int hour = now.hour;

    // Decide whether it's morning or evening
    String greeting = (hour < 12) ? 'Good Morning.' : 'Good Evening.';

    return BlocBuilder<ProductBloc, ProductBlocState>(
      builder: (context, state) {
        if (state.status == ApiStatus.loading) {
          return const Center(
            child: SpinKitChasingDots(
              color: CupertinoColors.black,
              size: 40,
            ),
          );
        } else if (state.status == ApiStatus.fail) {
          return const Center(
            child: Text('Failed to fetch products'),
          );
        } else if (state.status == ApiStatus.success) {
          final List<String> categories =
              state.product.map((product) => product.category).toSet().toList();
          List<Product> filteredProducts = selectedCategory != null
              ? state.product
                  .where((product) => product.category == selectedCategory)
                  .toList()
              : state.product;

          if (searchText.isNotEmpty) {
            filteredProducts = filteredProducts
                .where((product) => product.title
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
                .toList();
          }

          return Scaffold(
            backgroundColor: CupertinoColors.white,
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        color: CupertinoColors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                greeting,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildSearchField(),
                            ),
                          ],
                        )),
                  ]),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  sliver: SliverToBoxAdapter(
                    child: buildCarousel(state.product),
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        ' Discover',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.black),
                      ),
                      buildCategory(categories),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: buildGridItem(filteredProducts),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Error load'),
          );
        }
      },
    );
  }

  SliverGrid buildGridItem(List<Product> filteredProducts) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final product = filteredProducts[index];
          return ProductGridItem(product: product);
        },
        childCount: filteredProducts.length,
      ),
    );
  }

  SizedBox buildCategory(List<String> categories) {
    return SizedBox(
      height: 35,
      child: ListView(
        padding: const EdgeInsets.all(3),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: categories.map((String category) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory =
                    selectedCategory == category ? null : category;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: selectedCategory == category
                    ? Colors.black
                    : CupertinoColors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: selectedCategory == category
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSearchField() {
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchText = value;
              selectedCategory = null;
            });
          },
          decoration: const InputDecoration(
              isDense: false,
              contentPadding: EdgeInsets.all(2),
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none),
        ),
      ),
    );
  }

  Widget buildCarousel(List<Product> products) {
    return CarouselSlider(
      items: products.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: product),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        aspectRatio: 19 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
