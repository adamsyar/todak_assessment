import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/screen_content/widget/custom_elavated_button.dart';
import 'package:todak_assessment/shared_preferences.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: CupertinoColors.black,
        foregroundColor: CupertinoColors.white,
        title: const Text('Add Address',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
      ),
      bottomNavigationBar: buildBottomAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: addressController,
                labelText: 'Address',
                errorMessage: 'Please enter your address',
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: cityController,
                labelText: 'City',
                errorMessage: 'Please enter your city',
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: postcodeController,
                labelText: 'Postcode',
                errorMessage: 'Please enter your postcode',
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: stateController,
                labelText: 'State',
                errorMessage: 'Please enter your state',
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
        color: CupertinoColors.white,
        elevation: 0,
        child: CustomButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final address = '${addressController.text}, '
                  '${cityController.text}, '
                  '${postcodeController.text}, '
                  '${stateController.text}';
              final success =
                  await SharedPreferencesHandler.addAddress(address);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address added successfully')),
                );
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to add address')),
                );
              }
            }
          },
          text: 'Save',
        ));
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String errorMessage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            labelText: labelText,
            isDense: false,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          },
        ),
      ),
    );
  }
}
