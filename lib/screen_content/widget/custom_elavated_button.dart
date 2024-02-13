import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final IconData? iconData;
  final Color backgroundColor;
  final Color textColor;
  final double iconSize;
  final bool hasIcon;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.iconData,
    this.backgroundColor = CupertinoColors.black,
    this.textColor = CupertinoColors.white,
    this.iconSize = 20,
    this.hasIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 56)),
      ),
      child: hasIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: iconSize,
                  color: textColor,
                ),
                SizedBox(width: 5),
                Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(color: textColor),
            ),
    );
  }
}
