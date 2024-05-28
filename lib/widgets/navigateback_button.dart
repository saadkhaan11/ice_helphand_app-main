import 'package:flutter/material.dart';

class NavigateBackButton extends StatelessWidget {
  final Function function;
  const NavigateBackButton({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      onPressed: () {
        function();
      },
      child: Icon(
        Icons.navigate_before,
        color: Colors.black,
      ),
    );
  }
}
