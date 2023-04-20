import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ice_helphand/screens/contact/contacts_screen.dart';
import 'package:ice_helphand/screens/home/home_screen.dart';
import 'package:ice_helphand/screens/map/map_screen.dart';
import '../size_config.dart';
import 'chatScreen/chatusers_screen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = "/BottomBarScreen";
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;

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
  ];
  // print('build');
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      // print(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final user = Provider.of<MyUser?>(context);
    return Scaffold(
      body: pages[selectedIndex]['page'],
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
              icon: FaIcon(FontAwesomeIcons.message), label: "chat")
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xffE74140),
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
