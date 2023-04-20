import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  String text;
  VoidCallback function;
  bool isSelected;
  int height;
  int width;
  CustomButton({
    super.key,
    required this.text,
    required this.function,
    required this.isSelected,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: width.toDouble(),
        height: height.toDouble(),
        decoration: BoxDecoration(
            color: isSelected ? Color(0xffE74140) : Colors.white,
            border: Border.all(
                color: isSelected ? Colors.transparent : Color(0xff1E232C)),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              color: isSelected ? Colors.white : Color(0xff1E232C),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
