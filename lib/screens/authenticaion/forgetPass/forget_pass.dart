import 'package:flutter/material.dart';
import 'package:ice_helphand/size_config.dart';
import '../../../provider/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/navigateback_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = "/ForgetPasswordScreen";
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => __ForgetPasswordScreenState();
}

class __ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  final AuthProvider auth = AuthProvider();
  String email = '';
  String pass = '';
  
  // String error = '';

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavigateBackButton(
                  function: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                const Text(
                  'Enter Email Adress To Change Password!',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(150),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (value) =>
                                value!.isEmpty ? "Enter an Email" : null,
                            decoration: InputDecoration(
                              hintText: 'Email adress',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintStyle: TextStyle(color: Color(0xff8391A1)),
                            ),
                          ),
                          // SizedBox(
                          //   height: height * .012,
                          // ),
                          
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(40),
                      ),
                      CustomButton(
                        function: () async {
                          if (_formkey.currentState!.validate()) {
                           auth.passwordRest(email, context);
                          }
                        },
                        height: 56,
                        isSelected: true,
                        text: 'Send',
                        width: 350,
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
