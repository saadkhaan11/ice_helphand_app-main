import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ice_helphand/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../widgets/navigateback_button.dart';
import 'dart:io' as io;

class RegisterScreen extends StatefulWidget {
  static const routeName = "/RegisterScreen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Auth auth = Auth();

  final _formkey = GlobalKey<FormState>();
  String email = '';
  String confirmPass = '';
  String pass = '';
  String username = '';
  String error = '';
  // final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;

  Future pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 60,
        maxHeight: 600,
        maxWidth: 600,
      );
      if (image == null) return;
      // final imageTemporary = io.File(image.path);
      setState(() {
        pickedImage = image;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * .05,
                ),
                NavigateBackButton(
                  function: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: height * .05,
                ),
                const Text(
                  'Hello! Register to get\nstarted',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(height: height * .05),
                Center(
                  child: Column(
                    children: [
                      pickedImage != null
                          ? SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.file(
                                    io.File(pickedImage!.path),
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : SizedBox(
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/user.png',
                                  // height: 100,
                                ),
                              ),
                            ),
                      TextButton(
                          onPressed: () {
                            pickImage(ImageSource.gallery);
                          },
                          child: Text(
                            'Select Image',
                            style: TextStyle(color: Color(0xffE74140)),
                          )),
                    ],
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Column(children: [
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                      validator: (value) =>
                          value!.isEmpty ? "Enter Username" : null,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintStyle: TextStyle(color: Color(0xff8391A1)),
                      ),
                    ),
                    SizedBox(
                      height: height * .012,
                    ),
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
                  ]),
                ),
                SizedBox(
                  height: height * .012,
                ),
                TextFormField(
                  validator: (value) =>
                      value!.length < 6 ? "Enter Password 6+ words" : null,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintStyle: const TextStyle(color: Color(0xff8391A1))),
                  obscureText: true,
                  onChanged: ((value) {
                    setState(() {
                      pass = value;
                    });
                  }),
                ),
                SizedBox(
                  height: height * .03,
                ),
                // const SizedBox(
                //   height: 60,
                // ),
                Column(
                  children: [
                    CustomButton(
                      function: () async {
                        if (_formkey.currentState!.validate()) {
                          await auth.signupWithEmailAndPass(
                              email: email,
                              pass: pass,
                              username: username,
                              image: pickedImage!.path,
                              context: context);
                          Navigator.pop(context);
                          // setState(() {});
                          // .then((value) => Navigator.of(context)
                          //     .pushNamed(BottomBarScreen.routeName));
                        }
                      },
                      height: 56,
                      text: 'Register',
                      isSelected: true,
                      width: 331,
                    ),
                    SizedBox(
                      height: height * .020,
                    ),
                    Text(
                      'or Login With',
                      style: TextStyle(color: Color(0xff6A707C)),
                    ),
                    SizedBox(
                      height: height * .020,
                    ),
                    GestureDetector(
                        onTap: (() {}),
                        child: SvgPicture.asset('assets/google_ic.svg')),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already Have Account?',
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Color(0xffE74140)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 20,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
