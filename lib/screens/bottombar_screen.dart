import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ice_helphand/screens/contact/contacts_screen.dart';
import 'package:ice_helphand/screens/home/home_screen.dart';
import 'package:ice_helphand/screens/map/map_screen.dart';
import 'package:ice_helphand/screens/profile/edit_profile_screen.dart';
import 'package:ice_helphand/screens/profile/settings_page.dart';
import '../size_config.dart';
import '../static_variables.dart';
import 'chatScreen/chatusers_screen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = "/BottomBarScreen";
  final String? isNotification;
  BottomBarScreen({this.isNotification});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  int? selectedIndex;
  // Position? _currentPosition = MyStaticVariables.getCurrentPosition();
  bool isLoading = true;
  bool? hasPermission;
  StreamSubscription<Position> ?_positionStreamSubscription;

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
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> setPermission() async {
     hasPermission = await _handleLocationPermission();
    // print('permission main wali ${hasPermission}');
    // MyStaticVariables.setHasPermission(hasPermission);
    // print('has permission${hasPermission}');
    // print('object');

    // if (!hasPermission) return;

    // Geolocator.getPositionStream().listen((Position position) {
    //   print('position donesad');
    //   MyStaticVariables.setMyStaticVariable(position);
    //   updateLocation(position.latitude, position.longitude);
    // });
  }

  Future<void> _getCurrentPosition() async {
    print('ok');
    // bool? hasPermission = MyStaticVariables.getHasPermission();
    print(hasPermission);
    if (!(hasPermission!)){
      print('ddd');
      return;
    } 

Geolocator.getPositionStream().listen((Position position) {
      print('getstreampostion${position.latitude}');
      MyStaticVariables.position=position;
      MyStaticVariables.setCurrentPosition(position);
      // _currentPosition = position;
      // print('current positionxyz${_currentPosition}');
      // newLoading=false;
      updateLocation(position.latitude, position.longitude);

    });
  }

    Future updateLocation(
  double latitude,double longitude
) {
  GeoPoint location = GeoPoint(latitude, longitude);
    return firebaseFirestore.collection('usersLocation').doc(user!.uid).update({
      
      'location':location
    }).catchError((e) => {
      firebaseFirestore.collection('usersLocation').doc(user!.uid).set({
      'location':location
    },SetOptions(merge: true)),
    });
}

void setUserName() {
    firebaseFirestore.collection("users").doc(user!.uid).get().then((value) {
      print('userscollection${value.data()!['username']}');
      firebaseFirestore.collection("usersLocation").doc(user!.uid).set({
        "username": value.data()!['username'],
      },SetOptions(merge: true));

      // print(name);
    });
  }

  void locationData() async {
    firebaseFirestore.collection("usersLocation").get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          print('location Data ${snapshot.docs[i].data()['location']}');
          inRange(snapshot.docs[i].data()['location'].latitude,
              snapshot.docs[i].data()['location'].longitude);
          // addCustomIcon();

          // initMarker(snapshot.docs[i].data(), snapshot.docs[i].id,
          //     snapshot.docs[i].data()['username']);
        }
        // getMarkersInRadius(
        //     LatLng(_currentPosition!.latitude, _currentPosition!.longitude), 3);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void inRange(double latitude, double longitude) {

  
    
         double distance = distanceBetween(
        LatLng(MyStaticVariables.getCurrentPosition()!.latitude, MyStaticVariables.getCurrentPosition()!.latitude),
        LatLng(latitude, longitude));
    // print("distace${distance}");
    // if (distance < 50) {
    firebaseFirestore.collection("users").doc(user!.uid).set({
      "inRange": true,
    },SetOptions(merge: true));
 
    // print(_currentPosition);

    // }
    // distanceBetween(latitude: 10, longitude: 20);
    // GeoPoint location = GeoPoint(latitude, longitude);
  }

  double distanceBetween(LatLng point1, LatLng point2) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((point2.latitude - point1.latitude) * p) / 2 +
        c(point1.latitude * p) *
            c(point2.latitude * p) *
            (1 - c((point2.longitude - point1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
  void dispose() {
  print('disposing');
  _positionStreamSubscription!.cancel();
  super.dispose();
}

  @override
  void initState() {
    setPermission().then((value){
      _getCurrentPosition().then((value) {
      locationData();
    },);
    });
    
    // if (widget.isNotification == '1') {
    //   print(widget.isNotification);
    //   setState(() {
    //     selectedIndex = 1;
    //   });
    // } else {
      setState(() {
        selectedIndex = 0;
      });
    // }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
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
