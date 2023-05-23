import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/screens/profile/edit_profile_screen.dart';
import '../../color_pallet.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "/settingsPage";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool emergencyAlarm = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userData = {};
  // UserModel? currentUser;
  // late String imageUrl = "http://cdn.onlinewebfonts.com/svg/img_401900.png";
  void getUserData() async {
    final User? user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      // userData.addAll(value.data());
      userData = value.data();
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getUserData();

    // currentUser = BlocProvider.of<AuthBloc>(context).state.user;

    // AuthProvider().imageUrl().then((value) {
    //   print(value);
    //   imageUrl = value!;
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return SafeArea(
      bottom: false,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Palette.white,
              padding: EdgeInsets.only(
                top: mediaQuery.size.width * 0.04,
                left: mediaQuery.size.width * 0.04,
                right: mediaQuery.size.width * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Palette.textColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  const Text(
                    "Account",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Palette.textColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  createAccountRow(mediaQuery),
                  SizedBox(height: mediaQuery.size.height * 0.04),
                  const Text(
                    "Settings",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Palette.textColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  // BlocConsumer<SettingsBloc, SettingsState>(
                  //     listener: (context, state) {
                  //   if (state is SettingStateNotificationUpdated) {
                  //     setState(() {});
                  //   }
                  // }, builder: (context, state) {
                  //   return
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // createInformationTile(
                          //   mediaQuery: mediaQuery,
                          //   color: Palette.frenchBlue,
                          //   tileText: "Notification",
                          //   icon: Icons.notifications_none,
                          //   onTap: () {},
                          // ),
                          // createInformationTile(
                          //   mediaQuery: mediaQuery,
                          //   color: Palette.language,
                          //   tileText: AppLocalizations.of(context)
                          //       .translate('emergency_list_messages'),
                          //   icon: Icons.emergency,
                          //   onTap: () {
                          //     RouteGenerator.navigatorKey.currentState!
                          //         .pushNamed(emergencyListRoute);
                          //   },
                          // ),
                          // createInformationTile(
                          //   mediaQuery: mediaQuery,
                          //   color: Palette.privacyPolicy,
                          //   tileText: AppLocalizations.of(context)
                          //       .translate('payment_details'),
                          //   icon: Icons.payment,
                          //   onTap: () {
                          //     RouteGenerator.navigatorKey.currentState!
                          //         .pushNamed(paymentDetailsRoute);
                          //   },
                          // ),
                          createSettingTile(
                            mediaQuery: mediaQuery,
                            color: Palette.location,
                            tileText: "Chat Notification",
                            icon: Icons.location_on_outlined,
                            switchValue: true,
                            //  state.settings.chatNotifications,
                            switchOnChaged: (value) {
                              setState(() {
                                // BlocProvider.of<SettingsBloc>(context)
                                //     .add(const ChangeNotificationsEvent());
                              });
                            },
                          ),
                          createSettingTile(
                            mediaQuery: mediaQuery,
                            color: Palette.faceid,
                            tileText: "Disable Notifices Notifications",
                            icon: Icons.face_unlock_outlined,
                            switchValue: false,
                            switchOnChaged: (value) {
                              // setState(() {
                              //   BlocProvider.of<SettingsBloc>(context)
                              //       .add(const ChangeFaceIDEvent());
                              // });
                            },
                          ),
                          createInformationTile(
                            mediaQuery: mediaQuery,
                            color: Palette.help,
                            tileText: "Help",
                            icon: Icons.help,
                            onTap: () {
                              // RouteGenerator.navigatorKey.currentState!
                              //     .pushNamed(helpPageRoute);
                            },
                          ),
                          createInformationTile(
                            mediaQuery: mediaQuery,
                            color: Palette.blueInformation,
                            tileText: "About App",
                            icon: Icons.info,
                          ),
                          createInformationTile(
                            mediaQuery: mediaQuery,
                            color: Palette.logOut,
                            tileText: "Logout",
                            icon: Icons.logout,
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Palette.white,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: mediaQuery.size.width * 0.06,
                                    vertical: mediaQuery.size.height * 0.02),
                                title: const Text(
                                  "Log out",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Palette.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                content: const Text(
                                  "Are you sure you want to log out?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Palette.textColor,
                                    fontSize: 14.0,
                                  ),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // RouteGenerator.navigatorKey.currentState!
                                          //     .pop('dialog');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12.0),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Palette.textColor,
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // RouteGenerator.navigatorKey.currentState!
                                          //     .pop('dialog');
                                          // RouteGenerator.navigatorKey.currentState!
                                          //     .pushNamedAndRemoveUntil(
                                          //         logInRoute, (route) => false);
                                          // BlocProvider.of<AuthBloc>(context)
                                          //     .add(const AuthLogoutEvent());
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 16.0),
                                            decoration: BoxDecoration(
                                              color: Palette.red,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset:
                                                      const Offset(0.0, 0.0),
                                                  blurRadius: 16.0,
                                                  color: Palette.red
                                                      .withOpacity(0.25),
                                                ),
                                              ],
                                            ),
                                            child: const Text(
                                              "Logout",
                                              style: TextStyle(
                                                  color: Palette.white,
                                                  fontSize: 12.0),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // }
                  // ),
                ],
              ),
            ),
    );
  }

  Widget createNotificationTile(
      {required MediaQueryData mediaQuery,
      required Color color,
      required String tileText,
      required IconData icon,
      required bool switchValue,
      required void Function() switchOnChaged}) {
    return GestureDetector(
      onTap: switchOnChaged,
      child: Container(
        margin: EdgeInsets.only(bottom: mediaQuery.size.height * 0.01),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.01,
                  horizontal: mediaQuery.size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: color.withOpacity(0.25),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.04),
            Expanded(
              child: Text(
                tileText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Palette.textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              switchValue ? "On" : "Off",
              style: TextStyle(
                color: switchValue ? Palette.green : Palette.red,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.02),
          ],
        ),
      ),
    );
  }

  Widget createSettingTile(
      {required MediaQueryData mediaQuery,
      required Color color,
      required String tileText,
      required IconData icon,
      required bool switchValue,
      required void Function(bool) switchOnChaged}) {
    return Container(
      margin: EdgeInsets.only(bottom: mediaQuery.size.height * 0.01),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: mediaQuery.size.height * 0.01,
                horizontal: mediaQuery.size.width * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              color: color.withOpacity(0.25),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.04),
          Expanded(
            child: Text(
              tileText,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Palette.textColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: switchValue,
            onChanged: switchOnChaged,
            activeColor: Palette.frenchBlue,
            inactiveTrackColor: Palette.grey,
          ),
          SizedBox(width: mediaQuery.size.width * 0.02),
        ],
      ),
    );
  }

  Widget createInformationTile({
    required MediaQueryData mediaQuery,
    required Color color,
    required String tileText,
    required IconData icon,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: mediaQuery.size.height * 0.02),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.01,
                  horizontal: mediaQuery.size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: color.withOpacity(0.25),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.04),
            Expanded(
              child: Text(
                tileText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Palette.textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.01,
                  horizontal: mediaQuery.size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Palette.buttonBackground,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Palette.frenchBlue,
                size: mediaQuery.size.height * 0.02,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.02),
          ],
        ),
      ),
    );
  }

  Widget createAccountRow(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, EditProfilePage.routeName,
            arguments: {'userData': userData});
        // getUserData();
        // RouteGenerator.navigatorKey.currentState!.pushNamed(editProfileRoute);
        // BlocProvider.of<NavBarBloc>(context)
        //     .add(NavBarShowEditProfileEvent(4, editProfileRoute));
      },
      child: Row(
        children: [
          Container(
            height: mediaQuery.size.width * 0.16,
            width: mediaQuery.size.width * 0.16,
            decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(200.0),
                boxShadow: [
                  BoxShadow(
                      color: Palette.frenchBlue.withOpacity(0.25),
                      offset: const Offset(0.0, 4.0),
                      blurRadius: 16.0)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: CachedNetworkImage(
                imageUrl: userData!['image'],
                // BlocProvider.of<AuthBloc>(context)
                //     .state
                //     .user!
                //     .profilePicture,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.06),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData!['username'],
                  // BlocProvider.of<AuthBloc>(context).state.user!.firstName,
                  style: TextStyle(
                    color: Palette.textColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.01),
                const Text(
                  "Personal Info",
                  style: TextStyle(
                    color: Palette.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: mediaQuery.size.height * 0.01,
                horizontal: mediaQuery.size.width * 0.02),
            decoration: BoxDecoration(
              color: Palette.buttonBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Palette.frenchBlue,
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.04),
        ],
      ),
    );
  }
}
