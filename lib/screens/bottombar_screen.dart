import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ice_helphand/screens/contact/contacts_screen.dart';
import 'package:ice_helphand/screens/home/home_screen.dart';
import 'package:ice_helphand/screens/map/map_screen.dart';
import 'package:ice_helphand/screens/profile/edit_profile_screen.dart';
import 'package:ice_helphand/screens/profile/settings_page.dart';
import '../size_config.dart';
import 'chatScreen/chatusers_screen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = "/BottomBarScreen";
  final String? isNotification;
  BottomBarScreen({this.isNotification});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int? selectedIndex;

  final List<Map<String, dynamic>> pages = [
    {
      'page': const HomeScreen(),
    },
    {
      'page': const MapScreen(),
    },
    {
      'page': const ContactsScreen(),
    },
    {
      'page': ChatUsersScreen(),
    },
    {
      'page': const SettingsPage(),
    },
  ];
  // print('build');
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      // print(selectedIndex);
    });
  }

  @override
  void initState() {
    if (widget.isNotification == '1') {
      print(widget.isNotification);
      setState(() {
        selectedIndex = 1;
      });
    } else {
      setState(() {
        selectedIndex = 0;
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final user = Provider.of<MyUser?>(context);

    return Scaffold(
      body: pages[selectedIndex!]['page'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home), label: "home"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.mapLocation), label: "map"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.phone), label: "phone"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.message), label: "chat"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.gear), label: "profile")
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xffE74140),
        currentIndex: selectedIndex!,
        onTap: onItemTapped,
      ),
    );
  }
}
