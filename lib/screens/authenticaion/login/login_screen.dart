import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ice_helphand/screens/authenticaion/registeration/register_screen.dart';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/navigateback_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final AuthProvider auth = AuthProvider();
  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  height: height * .12,
                ),
                const Text(
                  'Welcome back! Glad\nto see you, Again!',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(
                  height: height * .12,
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
                          ),
                          SizedBox(
                            height: height * .012,
                          ),
                          TextFormField(
                            validator: (value) => value!.length < 6
                                ? "Enter Password 6+ words"
                                : null,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintStyle: TextStyle(color: Color(0xff8391A1)),

                              // focusedBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(
                              //       color: Color.fromARGB(255, 31, 31, 31)),
                              // ),
                            ),
                            obscureText: true,
                            onChanged: ((value) {
                              setState(() {
                                pass = value;
                              });
                            }),
                          ),
                          SizedBox(
                            height: height * .030,
                          ),
                          const Text(
                            'Forget Password?',
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Color(0xff6A707C)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .069,
                      ),
                      CustomButton(
                        function: () async {
                          if (_formkey.currentState!.validate()) {
                            await auth.signinWithEmailAndPass(
                                email, pass, context);
                          }
                        },
                        height: 56,
                        isSelected: true,
                        text: 'Login',
                        width: 331,
                      ),
                      SizedBox(
                        height: height * .024,
                      ),
                      const Text(
                        'or Login With',
                        style: TextStyle(color: Color(0xff6A707C)),
                      ),
                      SizedBox(
                        height: height * .030,
                      ),
                      // GestureDetector(
                      //     onTap: (() {
                      //       auth.signInWithGoogle(context);
                      //     }),
                      //     child:
                      //      SvgPicture.asset('assets/google_ic.svg')),
                      // Text(
                      //   error,
                      //   style: const TextStyle(color: Colors.red),
                      // ),
                      // SizedBox(
                      //   height: height * .03,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t Have Account?',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RegisterScreen.routeName);
                            },
                            child: const Text(
                              'Register Now',
                              style: TextStyle(color: Color(0xffE74140)),
                            ),
                          ),
                        ],
                      ),
                      Text(error),
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
