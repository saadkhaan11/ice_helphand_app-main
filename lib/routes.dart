import 'package:flutter/widgets.dart';
import 'package:ice_helphand/screens/authenticaion/login/login_screen.dart';
import 'package:ice_helphand/screens/authenticaion/registeration/register_screen.dart';
import 'package:ice_helphand/screens/bottombar_screen.dart';
import 'package:ice_helphand/screens/chatScreen/chatusers_screen.dart';
import 'package:ice_helphand/screens/contact/add_contact_screen.dart';
import 'package:ice_helphand/screens/contact/edit_contact_screen.dart';
import 'package:ice_helphand/screens/map/map_screen.dart';
import 'package:ice_helphand/screens/verifyemail/verifyemail_screen.dart';
import 'package:ice_helphand/screens/wrapper.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: ((context) => const LoginScreen()),
  RegisterScreen.routeName: ((context) => const RegisterScreen()),
  BottomBarScreen.routeName: (context) => const BottomBarScreen(),
  ChatUsersScreen.routeName: ((context) => ChatUsersScreen()),
  AddContactScreen.routeName: ((context) => AddContactScreen()),
  VerifyEmailPage.routeName: ((context) => VerifyEmailPage()),
  Wrapper.routeName: ((context) => Wrapper()),
  MapScreen.routeName: ((context) => MapScreen()),
  // EditContactScreen.routeName: (context) => EditContactScreen(),
};
