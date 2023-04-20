import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  String value;
  String hintText;
  bool obsecure;
  final String? Function(String?)? validator;
  CustomTextFormField({
    required this.value,
    required this.hintText,
    required this.validator,
    required this.obsecure,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obsecure,
      onChanged: (value) {
        setState(() {
          widget.value = value;
          // print(value);
        });
      },
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
        //   borderSide: BorderSide(color: Colors.blue),
        // ),

        hintStyle: TextStyle(color: Color(0xff8391A1)),
      ),
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(
      //       color: Color.fromARGB(255, 31, 31, 31)),
      // ),
    );
  }
}
