import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'color_pallet.dart';

class CustomWidgets {
  static BoxDecoration textInputDecoration = BoxDecoration(
      color: Palette.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Palette.cuiPurple.withOpacity(0.25),
          blurRadius: 8.0,
          offset: const Offset(0.0, 2.0),
        ),
      ]);

  static BoxDecoration buttonDecoration = BoxDecoration(
      color: Palette.cuiPurple,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Palette.cuiPurple.withOpacity(0.25),
          blurRadius: 8.0,
          offset: const Offset(0.0, 2.0),
        ),
      ]);

  static GestureDetector textButton(
      {required String text,
      required MediaQueryData mediaQuery,
      double? borderRadius,
      Color? color,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: mediaQuery.size.width,
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.size.height * 0.02,
        ),
        decoration: BoxDecoration(
            color: color ?? Palette.cuiPurple,
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            boxShadow: [
              BoxShadow(
                color: Palette.cuiBlue.withOpacity(0.25),
                blurRadius: 8.0,
                offset: const Offset(0.0, 2.0),
              ),
            ]),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Palette.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static dialogBox(
      {required BuildContext context,
      required MediaQueryData mediaQuery,
      required String text,
      required String buttonText,
      required Color color,
      required IconData icon,
      void Function()? onTap}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Icon(icon, color: color, size: 60),
            content: Text(text, textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.02,
                      horizontal: mediaQuery.size.width * 0.02),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0.0, 2.0),
                        blurRadius: 16.0,
                        color: color.withOpacity(0.15),
                      )
                    ],
                  ),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Palette.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  static GestureDetector iconButton(
      {required String path, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Palette.cuiBlue.withOpacity(0.25),
                blurRadius: 8.0,
                offset: const Offset(0.0, 2.0),
              ),
            ]),
        child: SvgPicture.asset(path),
      ),
    );
  }
}
