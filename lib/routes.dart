import 'package:flutter/widgets.dart';
import 'package:ice_helphand/screens/authenticaion/forgetPass/forget_pass.dart';
import 'package:ice_helphand/screens/authenticaion/login/login_screen.dart';
import 'package:ice_helphand/screens/authenticaion/registeration/register_screen.dart';
import 'package:ice_helphand/screens/bottombar_screen.dart';
import 'package:ice_helphand/screens/chatScreen/chatusers_screen.dart';
import 'package:ice_helphand/screens/contact/add_contact_screen.dart';
import 'package:ice_helphand/screens/map/map_screen.dart';
import 'package:ice_helphand/screens/profile/edit_profile_screen.dart';
import 'package:ice_helphand/screens/profile/settings_page.dart';
import 'package:ice_helphand/screens/verifyemail/verifyemail_screen.dart';
import 'package:ice_helphand/screens/wrapper.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: ((context) => const LoginScreen()),
  RegisterScreen.routeName: ((context) => const RegisterScreen()),
  BottomBarScreen.routeName: (context) => BottomBarScreen(),
  ChatUsersScreen.routeName: ((context) => ChatUsersScreen()),
  AddContactScreen.routeName: ((context) => const AddContactScreen()),
  VerifyEmailPage.routeName: ((context) => const VerifyEmailPage()),
  Wrapper.routeName: ((context) => const Wrapper()),
  MapScreen.routeName: ((context) => const MapScreen()),
  SettingsPage.routeName: ((context) => const SettingsPage()),
  EditProfilePage.routeName: ((context) => const EditProfilePage()),
  ForgetPasswordScreen.routeName:(context) => const ForgetPasswordScreen(),

  // EditContactScreen.routeName: (context) => EditContactScreen(),
};
