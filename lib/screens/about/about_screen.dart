import 'package:flutter/material.dart';
import 'package:ice_helphand/color_pallet.dart';
import 'package:ice_helphand/size_config.dart';
class AboutScreen extends StatelessWidget {
  static const routeName = "/AboutScreen";
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.appredColor,
        title: const Text('About'),
      ),
      body:  Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: 20.0),
            Image.asset('assets/icons/Logo.png',width: getProportionateScreenHeight(100),),
            SizedBox(height: 16.0),
            Text(
              'Ice Help Hand',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'ICE Help hand is a platform or an app where any Individual gets help in case of emergency. This app is for individuals who are in any emergency such as theft, accident, harassment etc. Alert will be generated from victim end and will be popped on devices that are nearby in specific radius and will send message to the specific selected contacts so that the victim gets help from those who are nearby.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              children: [
                Text(
              'Contact Us at',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              'AdminIceHelpHand@gmail.com'
            ),
              ],
            )
          ],
        ),
      ),
    );
  }
}