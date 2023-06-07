import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../color_pallet.dart';
import '../../custom_widget.dart';
import '../../provider/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = "/profileScreen";

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = true;
  Map? userData;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController email2Controller = TextEditingController();
  final AuthProvider auth = AuthProvider();

  // TextEditingController phoneController = TextEditingController();
  // TextEditingController regNoController = TextEditingController();
  // TextEditingController addressController = TextEditingController();

  XFile? pickedImage;

  // late UserModel user;

  @override
  void initState() {
    // user = BlocProvider.of<AuthBloc>(context).state.user!;
    super.initState();
    // firstNameController.text = userData!['firstName'];
    // lastNameController.text = userData!['lastName'];
    // emailController.text = userData!['email'];
    // phoneController.text = user.phoneNo;
    // regNoController.text = user.regNo;
    // regController.text = user.regNo;

    // print('hjfdgfdijijfgi   ${user.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final myArgument = ModalRoute.of(context)!.settings.arguments as Map;
    userData = myArgument['userData'];
    firstNameController.text = userData!['firstName'];
    lastNameController.text = userData!['lastName'];
    emailController.text = userData!['email'];
    setState(() {
      isLoading = false;
    });
    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.04),
                child: Column(
                  children: [
                    SizedBox(height: mediaQuery.size.height * 0.03),
                    buildHeader(mediaQuery),
                    SizedBox(height: mediaQuery.size.height * 0.01),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.02),
                          child: Column(
                            children: [
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              createContactPicture(
                                  mediaQuery, userData!['image']),
                              SizedBox(height: mediaQuery.size.height * 0.03),
                              Container(
                                decoration: CustomWidgets.textInputDecoration,
                                padding: EdgeInsets.symmetric(
                                    horizontal: mediaQuery.size.width * 0.04,
                                    vertical: 4),
                                child: TextFormField(
                                  controller: firstNameController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "First Name",
                                    hintStyle: TextStyle(
                                      color: Palette.hintGrey,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  onTap: () {
                                    showSimpleNotification(
                                      const Text("Sorry, Cannot be changed"),
                                      background:
                                          Palette.yellow.withOpacity(0.9),
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.03),
                              Container(
                                decoration: CustomWidgets.textInputDecoration,
                                padding: EdgeInsets.symmetric(
                                    horizontal: mediaQuery.size.width * 0.04,
                                    vertical: 4),
                                child: TextFormField(
                                  controller: lastNameController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Last Name",
                                    hintStyle: TextStyle(
                                      color: Palette.hintGrey,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  onTap: () {
                                    showSimpleNotification(
                                      const Text("Sorry cannot be changed"),
                                      background:
                                          Palette.yellow.withOpacity(0.9),
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.03),
                              Container(
                                decoration: CustomWidgets.textInputDecoration,
                                padding: EdgeInsets.symmetric(
                                    horizontal: mediaQuery.size.width * 0.04,
                                    vertical: 4.0),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Palette.hintGrey,
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () {
                                    showSimpleNotification(
                                      const Text(
                                          "Sorry email is cannot be changed"),
                                      background:
                                          Palette.yellow.withOpacity(0.9),
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                ),
                              ),
                              // SizedBox(height: mediaQuery.size.height * 0.03),
                              // Container(
                              //   decoration: CustomWidgets.textInputDecoration,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: mediaQuery.size.width * 0.04,
                              //       vertical: 4.0),
                              //   child: TextFormField(
                              //     controller: phoneController,
                              //     decoration: const InputDecoration(
                              //       border: InputBorder.none,
                              //       hintText: "Phone no",
                              //       hintStyle: TextStyle(
                              //         color: Palette.hintGrey,
                              //       ),
                              //     ),
                              //     keyboardType: TextInputType.phone,
                              //   ),
                              // ),
                              // SizedBox(height: mediaQuery.size.height * 0.03),
                              // Container(
                              //   decoration: CustomWidgets.textInputDecoration,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: mediaQuery.size.width * 0.04,
                              //       vertical: 4.0),
                              //   child: TextFormField(
                              //     controller: regNoController,
                              //     decoration: const InputDecoration(
                              //       border: InputBorder.none,
                              //       hintText: "Reg No",
                              //       hintStyle: TextStyle(
                              //         color: Palette.hintGrey,
                              //       ),
                              //     ),
                              //     readOnly: true,
                              //     onTap: () {
                              //       showSimpleNotification(
                              //         const Text("Sorry cannot be changed"),
                              //         background: Palette.yellow.withOpacity(0.9),
                              //         duration: const Duration(seconds: 2),
                              //       );
                              //     },
                              //   ),
                              // ),
                              SizedBox(height: mediaQuery.size.height * 0.03),
                              // Container(
                              //   decoration: CustomWidgets.textInputDecoration,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: mediaQuery.size.width * 0.04,
                              //       vertical: 4.0),
                              //   child: TextFormField(
                              //     controller: addressController,
                              //     decoration: const InputDecoration(
                              //       border: InputBorder.none,
                              //       hintText: 'address',
                              //       hintStyle: TextStyle(
                              //         color: Palette.hintGrey,
                              //       ),
                              //     ),
                              //     keyboardType: TextInputType.streetAddress,
                              //   ),
                              // ),
                              // SizedBox(height: mediaQuery.size.height * 0.04),
                              GestureDetector(
                                onTap: () {
                                  reauthenticationBox(context, mediaQuery);
                                },
                                child: Container(
                                  width: mediaQuery.size.width,
                                  padding: EdgeInsets.symmetric(
                                      vertical: mediaQuery.size.height * 0.02,
                                      horizontal: mediaQuery.size.width * 0.02),
                                  decoration: BoxDecoration(
                                    color: Palette.red,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0.0, 2.0),
                                        blurRadius: 16.0,
                                        color: Palette.red.withOpacity(0.15),
                                      )
                                    ],
                                  ),
                                  child: const Text(
                                    "Delete your account!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Palette.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: mediaQuery.size.width * 0.04),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Future<dynamic> deleteDialogBox(
  //     BuildContext context, MediaQueryData mediaQuery) {
  //   return showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       backgroundColor: Palette.white,
  //       contentPadding: EdgeInsets.symmetric(
  //           horizontal: mediaQuery.size.width * 0.08,
  //           vertical: mediaQuery.size.height * 0.02),
  //       actionsAlignment: MainAxisAlignment.spaceEvenly,
  //       title: const Text(
  //         "Are you sure you want to delete your account?",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: Palette.textColor,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 14.0,
  //         ),
  //       ),
  //       content: const Text(
  //         "Once done this can't be reverted. Your contacts, messages, notificaions and devices will be removed from our system with immediate effect!",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: Palette.textColor,
  //           fontSize: 12.0,
  //         ),
  //       ),
  //       actions: [
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.of(context, rootNavigator: true).pop('dialog');
  //             // Navigator.of(context).pop();
  //             // RouteGenerator.navigatorKey.currentState!
  //             //     .pop('dialog');
  //           },
  //           child: const Text(
  //             "Cancel",
  //             style: TextStyle(color: Palette.textColor, fontSize: 12.0),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             reauthenticationBox(context, mediaQuery);
  //             // auth.deleteUser();
  //             // Navigator.of(context, rootNavigator: true)
  //             //     .pop('dialog');
  //             // BlocProvider.of<AuthBloc>(context).add(
  //             //   AuthDeleteAccountEvent(
  //             //       email: BlocProvider.of<AuthBloc>(
  //             //               context)
  //             //           .state
  //             //           .user!
  //             //           .email),
  //             // );
  //           },
  //           child: Container(
  //             padding:
  //                 const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
  //             decoration: BoxDecoration(
  //               color: Palette.red,
  //               borderRadius: BorderRadius.circular(8.0),
  //               boxShadow: [
  //                 BoxShadow(
  //                   offset: const Offset(0.0, 0.0),
  //                   blurRadius: 16.0,
  //                   color: Palette.red.withOpacity(0.25),
  //                 ),
  //               ],
  //             ),
  //             child: const Text(
  //               "Delete",
  //               style: TextStyle(color: Palette.white, fontSize: 12.0),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<dynamic> reauthenticationBox(
      BuildContext context, MediaQueryData mediaQuery) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Palette.white,
        contentPadding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.08,
            vertical: mediaQuery.size.height * 0.02),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: const Text(
          "Enter Credentials To Delete Account",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Palette.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              TextField(
                controller: email2Controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Palette.hintGrey,
                  ),
                ),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Palette.hintGrey,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              // Navigator.of(context).pop();
              // RouteGenerator.navigatorKey.currentState!
              //     .pop('dialog');
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Palette.textColor, fontSize: 12.0),
            ),
          ),
          GestureDetector(
            onTap: () {
              auth
                  .deleteUser(email2Controller.text, passController.text)
                  .then((value) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pop(context);
              });
              // auth.deleteUser();
              // Navigator.of(context, rootNavigator: true)
              //     .pop('dialog');
              // BlocProvider.of<AuthBloc>(context).add(
              //   AuthDeleteAccountEvent(
              //       email: BlocProvider.of<AuthBloc>(
              //               context)
              //           .state
              //           .user!
              //           .email),
              // );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Palette.red,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 16.0,
                    color: Palette.red.withOpacity(0.25),
                  ),
                ],
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Palette.white, fontSize: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createContactPicture(
      MediaQueryData mediaQuery, String profilePicture) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: mediaQuery.size.width * 0.4,
          height: mediaQuery.size.width * 0.4,
          decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(200.0),
            boxShadow: [
              BoxShadow(
                color: Palette.frenchBlue.withOpacity(0.25),
                offset: const Offset(0.0, 2.0),
                blurRadius: 16.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200.0),
            child: pickedImage != null
                ? Image.file(
                    File(pickedImage!.path),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    profilePicture,
                    width: mediaQuery.size.width * 0.4,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                bottomSheet(context);
              },
              child: Container(
                width: mediaQuery.size.width * 0.36,
                padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.size.height * 0.02,
                    horizontal: mediaQuery.size.width * 0.02),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 16.0,
                      color: Palette.appredColor.withOpacity(0.15),
                    )
                  ],
                ),
                child: const Text(
                  "Upload Picture",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Palette.appredColor),
                ),
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            (pickedImage != null)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        pickedImage = null;
                      });
                    },
                    child: Container(
                      width: mediaQuery.size.width * 0.36,
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.size.height * 0.02,
                          horizontal: mediaQuery.size.width * 0.02),
                      decoration: BoxDecoration(
                        color: Palette.red,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0.0, 2.0),
                            blurRadius: 16.0,
                            color: Palette.red.withOpacity(0.15),
                          )
                        ],
                      ),
                      child: const Text(
                        "Delete Picture",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Palette.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget buildHeader(MediaQueryData mediaQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Palette.white,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.08,
                  vertical: mediaQuery.size.height * 0.02),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              title: const Text(
                "Discard changes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              content: const Text(
                "Are you sure you want to discard?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.textColor,
                  fontSize: 12.0,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    // RouteGenerator.navigatorKey.currentState!.pop('dialog');
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Palette.textColor, fontSize: 12.0),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Navigator.pop(context);
                    // RouteGenerator.navigatorKey.currentState!.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Palette.red,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 16.0,
                          color: Palette.red.withOpacity(0.25),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Discard",
                      style: TextStyle(color: Palette.white, fontSize: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.close),
          color: Palette.textColor,
        ),
        const Text(
          "Account",
          style: TextStyle(
            color: Palette.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            // if (pickedImage != null) {
            //   BlocProvider.of<AuthBloc>(context).add(
            //     AuthUpdateUserDataEvent(
            //         userid: BlocProvider.of<AuthBloc>(context).state.user!.uid,
            //         file: pickedImage,
            //         oldImageKey:
            //             BlocProvider.of<AuthBloc>(context).state.user!.imageKey,
            //         dataChanged: {
            //           "first-name": firstNameController.text,
            //           "last-name": lastNameController.text,
            //           "phone": phoneController.text,
            //           "address": addressController.text,
            //         }),
            //   );
            // } else {
            //   BlocProvider.of<AuthBloc>(context).add(
            //     AuthUpdateUserDataEvent(
            //         userid: BlocProvider.of<AuthBloc>(context).state.user!.uid,
            //         file: null,
            //         oldImageKey: null,
            //         dataChanged: {
            //           "first-name": firstNameController.text,
            //           "last-name": lastNameController.text,
            //           "phone": phoneController.text,
            //           "address": addressController.text,
            //         }),
            //   );
            // }
            // RouteGenerator.navigatorKey.currentState!.pop(context);
          },
          child: Container(
            decoration: CustomWidgets.buttonDecoration,
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            child: const Icon(
              Icons.check,
              color: Palette.white,
            ),
          ),
        ),
      ],
    );
  }

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

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            height: MediaQuery.of(context).size.height * 0.22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(Icons.browse_gallery_outlined),
                  title: const Text("Choose Gallery"),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Camera"),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
