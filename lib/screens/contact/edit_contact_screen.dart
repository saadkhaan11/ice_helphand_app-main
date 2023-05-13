// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../models/added_contacts.dart';

// class EditContactScreen extends StatefulWidget {
//   static const routeName = "/editContact";
//   EditContactScreen({Key? key, required this.contact}) : super(key: key);
//   List<AddedContacts> contact;

//   @override
//   State<EditContactScreen> createState() => _EditContactScreenState();
// }

// class _EditContactScreenState extends State<EditContactScreen> {
//   final contactFormKey = GlobalKey<FormState>();

//   // TextEditingController firstNameController = TextEditingController();
//   // TextEditingController lastNameController = TextEditingController();
//   // TextEditingController relationController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController countryCodeController =
//       TextEditingController(text: "+52");
//   BuildContext? myContext;
//   final GlobalKey _addContactKey = GlobalKey();
//   final GlobalKey _phoneContactKey = GlobalKey();
//   final GlobalKey _askingKey = GlobalKey();
//   // final GlobalKey _phoneKey = GlobalKey();

//   bool isSaving = false;
//   DateTime dateTime = DateTime.now();
//   // late String contactImage;
//   XFile? pickedImage;

//   // void addContact() {
//   //   // if (pickedImage != null) {
//   //   FocusScope.of(context).unfocus();
//   //   if (contactFormKey.currentState!.validate()) {
//   //     setState(() {
//   //       isSaving = true;
//   //     });
//   //     User user = BlocProvider.of<AuthBloc>(context).state.user!;
//   //     if (emailController.text == user.email) {
//   //     } else {
//   //       BlocProvider.of<ContactBloc>(context).add(
//   //         SendFreindRequestEvent(
//   //           context: context,
//   //           data: SendFriendRequestModel(
//   //             sentTo: SentData(
//   //               userId: " ",
//   //               phone: countryCodeController.text + phoneController.text,
//   //               email: emailController.text,
//   //             ),
//   //             sentBy: SentData(
//   //               userId: user.uid,
//   //               phone: user.phoneNumber!,
//   //               email: user.email,
//   //             ),
//   //           ),
//   //         ),
//   //       );
//   //     }
//   //   }
//   // }

//   // Future pickImage(ImageSource source) async {
//   //   try {
//   //     final XFile? image = await ImagePicker().pickImage(source: source);
//   //     if (image == null) return;
//   //     setState(() => pickedImage = image);
//   //   } on PlatformException catch (e) {
//   //     debugPrint('Failed to pick image: $e');
//   //   }
//   // }

//   @override
//   void initState() {
//     if (widget.contact != null) {
//       String phone = widget.contact.first.phNo!.first.value != null
//           ? widget.contact.first.phNo!.first.value!
//               .trim()
//               .replaceAll(RegExp('[^A-Za-z0-9+]'), '')
//           : "";
//       if (phone.startsWith("+52")) {
//         phone = phone.replaceRange(0, 3, '');
//       }
//       nameController.text = widget.contact.first.phNo!.first.label ?? "";
//       nameController.text.trim();
//       phoneController.text = phone;
//     }
//     // HelpersFunctions.instance
//     //     .isFirstLaunch(screenName: 'addContactWalk')
//     //     .then((walk) {
//     //   if (walk) {
//     //     WidgetsBinding.instance.addPostFrameCallback((_) {
//     //       Future.delayed(const Duration(milliseconds: 500), () {
//     //         ShowCaseWidget.of(myContext!)
//     //             .startShowCase([_askingKey, _addContactKey, _phoneContactKey]);
//     //       });
//     //     });
//     //   }
//     // });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQuery = MediaQuery.of(context);
//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Container(
//           padding:
//               EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               buildHeader(mediaQuery, context),
//               // SizedBox(height: mediaQuery.size.height * 0.01),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: mediaQuery.size.width * 0.02),
//                     child: Form(
//                       key: contactFormKey,
//                       child: Center(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: mediaQuery.size.width * 0.04,
//                               vertical: 4),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(height: mediaQuery.size.height * 0.01),
//                               // createUploadPicture(mediaQuery),
//                               // SizedBox(height: mediaQuery.size.height * 0.03),
//                               Text(
//                                 'Save Contact',
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                     fontSize: 30, color: Colors.red),
//                               ),
//                               SizedBox(height: mediaQuery.size.height * 0.03),
//                               TextFormField(
//                                 controller: nameController,
//                                 decoration: InputDecoration(
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                     borderSide:
//                                         const BorderSide(color: Colors.red),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                     borderSide:
//                                         const BorderSide(color: Colors.red),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                     borderSide:
//                                         const BorderSide(color: Colors.red),
//                                   ),
//                                   hintText: "name",
//                                   hintStyle: const TextStyle(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 keyboardType: TextInputType.emailAddress,
//                                 validator: (value) {
//                                   if (value!.isEmpty) {
//                                     return ("enter_your_name");
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: mediaQuery.size.height * 0.02),
//                               TextFormField(
//                                 controller: phoneController,
//                                 decoration: InputDecoration(
//                                   prefixIcon: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: const [
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Icon(
//                                         Icons.mobile_friendly,
//                                         size: 24,
//                                         color: Colors.red,
//                                       ),
//                                       Text("+92"),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                     ],
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                     borderSide:
//                                         const BorderSide(color: Colors.red),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                     borderSide:
//                                         const BorderSide(color: Colors.red),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                     borderSide:
//                                         const BorderSide(color: Colors.red),
//                                   ),
//                                   hintText: ('phone_no'),
//                                   hintStyle: const TextStyle(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 keyboardType: TextInputType.phone,
//                                 validator: (value) {
//                                   if (value!.isEmpty) {
//                                     return ("enter_phone_number");
//                                   } else if (value.length < 6) {
//                                     return ("phone_number_6_digit");
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: mediaQuery.size.height * 0.04),
//                               GestureDetector(
//                                 onTap: isSaving ? null : () {},
//                                 child: Container(
//                                   width: isSaving
//                                       ? mediaQuery.size.width * 0.12
//                                       : mediaQuery.size.width,
//                                   height: isSaving
//                                       ? mediaQuery.size.width * 0.12
//                                       : null,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(
//                                         isSaving ? 500 : 15),
//                                     gradient: const LinearGradient(
//                                       colors: [Colors.red, Colors.white],
//                                     ),
//                                   ),
//                                   padding: isSaving
//                                       ? const EdgeInsets.all(8.0)
//                                       : const EdgeInsets.symmetric(
//                                           vertical: 22.0, horizontal: 13.0),
//                                   child: isSaving
//                                       ? const Center(
//                                           child: CircularProgressIndicator(
//                                             color: Colors.white,
//                                           ),
//                                         )
//                                       : const Text(
//                                           ("send-friend-request"),
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 13.0,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                 ),
//                               ),

//                               SizedBox(height: mediaQuery.size.height * 0.06),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget buildHeader(MediaQueryData mediaQuery, BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       IconButton(
//         onPressed: () => showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             backgroundColor: Colors.white,
//             contentPadding: EdgeInsets.symmetric(
//                 horizontal: mediaQuery.size.width * 0.08,
//                 vertical: mediaQuery.size.height * 0.02),
//             actionsAlignment: MainAxisAlignment.spaceBetween,
//             actionsPadding: EdgeInsets.only(
//               top: mediaQuery.size.width * 0.02,
//               left: mediaQuery.size.width * 0.05,
//               right: mediaQuery.size.width * 0.05,
//               bottom: mediaQuery.size.width * 0.06,
//             ),
//             title: const Text(
//               ("discard-friend-request"),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.0,
//               ),
//             ),
//             content: const Text(
//               ("discard-friend-request-subtitle"),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12.0,
//               ),
//             ),
//             actions: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context, rootNavigator: true).pop('dialog');
//                 },
//                 child: const Text(
//                   'discard',
//                   style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w700),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context, rootNavigator: true).pop('dialog');
//                 },
//                 child: const Text(
//                   'cancel',
//                   style: TextStyle(color: Colors.black, fontSize: 12.0),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         icon: const Icon(
//           Icons.navigate_before,
//           size: 20,
//         ),
//         color: Colors.blue,
//       ),
//       IconButton(
//         onPressed: () {},
//         icon: const Icon(
//           Icons.contacts_rounded,
//           color: Colors.blueAccent,
//         ),
//       ),

//       // Text(
//       //   AppLocalizations.of(context).translate('add_contact'),
//       //   style: const TextStyle(
//       //     color: Palette.textColor,
//       //     fontSize: 18.0,
//       //     fontWeight: FontWeight.bold,
//       //   ),
//       // ),
//     ],
//   );
// }
