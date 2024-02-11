import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todak_assessment/bloc/product_bloc.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/product_obj.dart';
import 'package:todak_assessment/screen_content/widget/item_container.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedCategory;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductBlocState>(
      builder: (context, state) {
        if (state.status == ApiStatus.loading) {
          return const Center(
            child: SpinKitChasingDots(
              color: Colors.deepPurple,
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
            backgroundColor: primaryBackgroundColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  buildSearchField(),
                  const SizedBox(height: 10),
                  buildCategory(categories),
                  const SizedBox(height: 10),
                  buildGridItem(filteredProducts),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Unknown state'),
          );
        }
      },
    );
  }

  Container buildCategory(List<String> categories) {
    return Container(
      height: 40,
      child: ListView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = categories[index];
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: selectedCategory == categories[index]
                    ? Colors.deepPurple
                    : CupertinoColors.white,
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
              child: Text(
                categories[index],
                style: TextStyle(
                  color: selectedCategory == categories[index]
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchField() {
    return SizedBox(
      height: 45,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(20),
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
              contentPadding: EdgeInsets.zero,
              labelText: 'Search',
              hintText: 'Search',
              labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none),
        ),
      ),
    );
  }

  Expanded buildGridItem(List<Product> filteredProducts) {
    return Expanded(
      child: GridView.builder(
        itemCount: filteredProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final product = filteredProducts[index];
          return ProductGridItem(product: product);
        },
      ),
    );
  }
}
