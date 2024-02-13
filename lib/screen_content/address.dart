import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/profile_obj.dart';
import 'package:todak_assessment/screen_content/add_address.dart';
import 'package:todak_assessment/screen_content/widget/custom_elavated_button.dart';
import 'package:todak_assessment/shared_preferences.dart';

class Address extends StatefulWidget {
  final Function(String) onAddressSelected;
  final String selectedAddress;

  Address({required this.onAddressSelected, required this.selectedAddress});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  late String selectedAddress;
  late Future<ProfileInfo> _profileFuture;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.selectedAddress;
    _profileFuture = SharedPreferencesHandler.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: CupertinoColors.black,
        foregroundColor: CupertinoColors.white,
        title: const Text(
          'Address',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomNavigationBar: buildAddToCartButton(context),
      body: FutureBuilder<ProfileInfo>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final profile = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: profile.addresses.length,
                itemBuilder: (context, index) {
                  final address = profile.addresses[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAddress = address;
                      });
                      widget.onAddressSelected(address);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedAddress == address
                                  ? CupertinoColors.black
                                  : Colors.transparent,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              CupertinoIcons.check_mark,
                              size: 14,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  BottomAppBar buildAddToCartButton(BuildContext context) {
    return BottomAppBar(
        color: CupertinoColors.white,
        child: CustomButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAddressPage()),
            ).then((value) {
              if (value == true) {
                setState(() {
                  _profileFuture = SharedPreferencesHandler.getProfile();
                });
              }
            });
          },
          text: 'Add Address',
          iconData: Icons.add,
        ));
  }
}
