import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        content: Text(
          message ?? 'An error occurred. Please try again later.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text(
              'OK',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue),
            ),
            onPressed: () {
              for (int i = 0; i < popCount; i++) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
