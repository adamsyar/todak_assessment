import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/shared_preferences.dart';

void showInformDialog(BuildContext context,
    {String? title, String? message, int popCount = 1}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          title ?? 'Error',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text(
              'OK',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.black),
            ),
            onPressed: () {
              SharedPreferencesHandler.clearCart();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
