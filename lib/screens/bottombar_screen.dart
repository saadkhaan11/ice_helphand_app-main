import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ice_helphand/screens/contact/contacts_screen.dart';
import 'package:ice_helphand/screens/home/home_screen.dart';
import 'package:ice_helphand/screens/map/map_screen.dart';
import 'package:ice_helphand/screens/profile/edit_profile_screen.dart';
import 'package:ice_helphand/screens/profile/settings_page.dart';
import '../models/userin_rande.dart';
import '../size_config.dart';
import '../static_variables.dart';
import 'chatScreen/chat_screen.dart';
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
  List<UserInRange> totalUsersList = [];
  List<UserInRange> usersInRange=[];
  StreamSubscription<DocumentSnapshot>? _streamSubscription;
    bool needHelp = false;
    bool isHelping = false;

    final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  // List<UserInRange> inRangeUsers =[];
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  String? seekersUid;
  String? fName;
  String? lName;
  String? image;
  String? helperName;
  String? helperImage;
  String? helperUid;
  Position? currentPosition;



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
  
  
  bool val = false ;
  String? seekerName;
  String? helpSeekerImage;
  String? emergencySituation;
  // print('build');
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      // print(selectedIndex);
    });
    if(needHelp){
      showSnackBar('snackasda');
    }
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
    // Position? currentPosition = MyStaticVariables.getCurrentPosition();
    print('locartiondata');
    firebaseFirestore.collection("usersLocation").get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          double distance = distanceBetween(
        LatLng(MyStaticVariables.getCurrentPosition()!.latitude, MyStaticVariables.getCurrentPosition()!.longitude),
        LatLng(snapshot.docs[i].data()['location'].latitude, snapshot.docs[i].data()['location'].longitude));
          totalUsersList.add(UserInRange(uid: snapshot.docs[i].id,distance: distance));
          totalUsersList.forEach((element) {
            print(element.distance);
            print(element.uid);
            if(element.uid!=user!.uid&& element.distance!<9000){
              usersInRange.add(element);
            }
           });
          //  Future<void> storeInRangeUsers() async {
  // final CollectionReference usersCollection =
  //     FirebaseFirestore.instance.collection('users');

  for (UserInRange userinrange in usersInRange) {
    print('usersinrange');
     usersCollection.doc(user!.uid).collection('inRangeUsers').doc(userinrange.uid).set(userinrange.toMap(),SetOptions(merge: true));
    //  print("storinf${userinrange.uid}");
  }
// }
          //  List usersData = usersInRange.map((user) => user.toMap()).toList();
          //  print("userdata${usersData}");
          // usersInRange = totalUsersList.where((element) => element.uid!=user!.uid&& element.distance!<5000);
    //       firebaseFirestore.collection("users").doc(user!.uid).set({
    //   "usersInRange": usersInRange,
    //   // ""
    // },SetOptions(merge: true));
          
          // print('location Data ${snapshot.docs[i].id}');
          // snapshot.docs[i].id
          // inRange(snapshot.docs[i].data()['location'].latitude,
          //     snapshot.docs[i].data()['location'].longitude,snapshot.docs[i].id);
          // addCustomIcon();
          // print('usersinRadius${usersInRange[i].}');
          // initMarker(snapshot.docs[i].data(), snapshot.docs[i].id,
          //     snapshot.docs[i].data()['username']);
        }
        // print("current user${user!.uid}");
        // (usersInRange.forEach((element) {
        //     print("userin radius${element.uid}");
        //   }));
        // print('usersinRadius${usersInRange}');
        // getMarkersInRadius(
        //     LatLng(_currentPosition!.latitude, _currentPosition!.longitude), 3);
      }
      // print('usersinRadius${usersInRange.first.distance}');
      // print("TotalUsers${totalUsersList}");
    });
    setState(() {
      isLoading = false;
    });
  }

  // void inRange(double latitude, double longitude,String uid) {
  //        double distance = distanceBetween(
  //       LatLng(MyStaticVariables.getCurrentPosition()!.latitude, MyStaticVariables.getCurrentPosition()!.latitude),
  //       LatLng(latitude, longitude));
  //   print("distace${distance}");
  //   if (distance < 50) {

  //     //new
  //     firebaseFirestore.collection("users").doc(user!.uid).set({
  //     "userUid": uid,
  //     // ""
  //   },SetOptions(merge: true));
  //   //old
  //   // firebaseFirestore.collection("users").doc(user!.uid).set({
  //   //   "inRange": true,
  //   // },SetOptions(merge: true));
 
  //   // print(_currentPosition);

  //   }
  //   // distanceBetween(latitude: 10, longitude: 20);
  //   // GeoPoint location = GeoPoint(latitude, longitude);
  // }
  // void getUrl(){
  //   // currentPosition =  MyStaticVariables.getCurrentPosition();
  //  String url = 'https://www.google.com/maps/search/?api=1&query=${33.7376117,},${72.7980267}';
   
  //  print(url);
  // }

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
  void getCurrentUserData(){
    usersCollection.doc(user!.uid).get().then((value) {
     seekerName = value.get('seekerName');
     helpSeekerImage = value.get('helpSeekerImage');
     emergencySituation = value.get('emergencySituation');
     seekersUid= value.get('seekersUid');
     fName = value.get('firstName');
     lName = value.get('lastName');
     image = value.get('image');  
     
     print('seekeruid${seekersUid}');
     print('cuuser${user!.uid}') ;  
  });
  }

  // void getHelperData(){
  //   usersCollection.doc(user!.uid).get().then((value) {
  //    helperName = value.get('helperName');
  //    helperImage = value.get('helperImage');
     
  //    print('seekeruid${helperName}');
  //    print('seekeruid${helperImage}');
  //   //  print('cuuser${user!.uid}') ;  
  // });
  // }

  
void listenToNeedHelpStream() {
  getCurrentUserData();
  print('stream');
    final DocumentReference documentRef =
        firebaseFirestore.collection('users').doc(user!.uid);
    _streamSubscription = documentRef.snapshots().listen((snapshot) {
      setState(() {
        needHelp = snapshot.get('needHelp') ?? false;
        isHelping = snapshot.get('isHelping')??false;
      });

      if (needHelp) {
        // showSnackBar('Helping is true');
        Timer(Duration(seconds: 10), () {
        // var heigh = 0.394;
        // var containerHeight = 0.109;
        showDialog(
            barrierColor: Colors.black45,
            barrierDismissible: false,
            context: context,
            builder: (ctx) => StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    content: Builder(builder: (context) {
                      // Get available height and width of the build area of this widget. Make a choice depending on the size
                      return SizedBox(
                        height: getProportionateScreenHeight(200),
                        width: getProportionateScreenWidth(60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the roundness
                                color: Color(0xffE74140), // Set the desired background color of the container
                                                          ),
                              padding: EdgeInsets.all(
                                  getProportionateScreenHeight(4)),
                              height:
                                  getProportionateScreenHeight(50),
                              // color: Color(0xffE74140),
                              child: Center(
                                child: Text(
                                  emergencySituation.toString(),
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              width: double.infinity,
                            ),
                            Text(
                            seekerName.toString(),
                             style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize:16),
                                ),
                                GestureDetector(
                             child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                               child: Image.network(
                                 helpSeekerImage.toString(),
                                 height: getProportionateScreenHeight(60),
                                 width: getProportionateScreenWidth(60),
                               ),
                             ),
                                ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(onPressed: (){
                                  print(user!.uid);
                                  usersCollection.doc(user!.uid).update({
                              'needHelp': false,
                            });
                                  Navigator.pop(context);
                                }, child: Text('Cancel',style: TextStyle(color: Color(0xffE74140)),)),
                            TextButton(onPressed: (){
                              usersCollection.doc(user!.uid).update({
                                  'needHelp': false,
                                }).then((value) {
                                  usersCollection.doc(seekersUid).update({
                                    'isHelping':true,
                                    'helperName':'$fName $lName',
                                    'helperImage':'$image',
                                    'helperUid':'${user!.uid}'
                                  });
                                }).then((value) {
                                  // getHelperData();
                                  
                                  Navigator.pop(context);
                                });
                            }, child: Text('Help Him',style: TextStyle(color: Colors.green))),
                              ],
                            ),
                            // Container(
                            //    height:getProportionateScreenHeight(40),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Text('Help Him',style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),),
                            // ),
                            //  Row(
                            //   children: [
                            //     Container(
                            //    height:getProportionateScreenHeight(10),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Text('Cancel',style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),),
                            // ),
                            // Container(
                            //    height:getProportionateScreenHeight(10),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Text('Help Him',style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),),
                            // ),
                            
                            //   ],
                            // )
                            // Container(
                            //   height:getProportionateScreenHeight(40),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           Center(
                            //             child: Text(
                            //               'Finished?',
                            //               style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),
                            //             ),
                            //           ),
                            //           // Transform.scale(
                            //           //   scale: getProportionateScreenWidth(40),
                            //           //   child: Checkbox(
                            //           //       fillColor: MaterialStateProperty
                            //           //           .resolveWith<Color>(
                            //           //               (Set<MaterialState>
                            //           //                   states) {
                            //           //         if (states.contains(
                            //           //             MaterialState.disabled)) {
                            //           //           return Colors.white
                            //           //               .withOpacity(.32);
                            //           //         }
                            //           //         return Colors.white;
                            //           //       }),
                            //           //       checkColor: Colors.green,
                            //           //       value: val,
                            //           //       onChanged: (value) {
                            //           //         setState(() {
                            //           //           // heigh = 0.494;
                            //           //           if (val == false) {
                            //           //             val = true;
                            //           //           }

                            //           //           // containerHeight = 0.209;
                            //           //         });
                            //           //       }),
                            //           // ),
                            //         ],
                            //       ),
                            //       // val
                            //       //     ? Column(
                            //       //         children: [
                            //       //           Divider(
                            //       //             color: Colors.black,
                            //       //             height: 5,
                            //       //           ),
                            //       //           Text(
                            //       //             'Was The support useful?',
                            //       //             style: GoogleFonts.aBeeZee(
                            //       //                 fontSize: horzintal
                            //       //                     ? height * 0.030
                            //       //                     : width * 0.030,
                            //       //                 fontWeight: FontWeight.bold,
                            //       //                 color: Colors.white),
                            //       //           ),
                            //       //           SizedBox(
                            //       //             height: 10,
                            //       //           ),
                            //       //           Row(
                            //       //             mainAxisAlignment:
                            //       //                 MainAxisAlignment.center,
                            //       //             children: [
                            //       //               GestureDetector(
                            //       //                 onTap: () {
                            //       //                   final DocumentSnapshot
                            //       //                       index1 = widget.data!
                            //       //                           .data!.docs[0];
                            //       //                   var helpList =
                            //       //                       index1['help overview'];
                            //       //                   var helperList =
                            //       //                       currentUser[
                            //       //                           'helper List'];
                            //       //                   helperList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'good',
                            //       //                   });

                            //       //                   helpList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'good',
                            //       //                   });

                            //       //                   Navigator.pop(context);
                            //       //                   usersCollection
                            //       //                       .doc(currentUser[
                            //       //                           'help id'])
                            //       //                       .update(
                            //       //                     {
                            //       //                       'suck': true,
                            //       //                       'help overview':
                            //       //                           helperList,
                            //       //                     },
                            //       //                   ).then((value) =>
                            //       //                           usersCollection
                            //       //                               .doc('000')
                            //       //                               .update({
                            //       //                             'help overview':
                            //       //                                 helpList
                            //       //                           }));
                            //       //                 },
                            //       //                 child: Image.asset(
                            //       //                   'assets/icons/good.png',
                            //       //                   height: horzintal
                            //       //                       ? width * 0.05
                            //       //                       : height * 0.05,
                            //       //                   width: horzintal
                            //       //                       ? height * 0.1
                            //       //                       : width * 0.1,
                            //       //                   // width: MediaQuery.of(
                            //       //                   //             context)
                            //       //                   //         .size
                            //       //                   //         .height *
                            //       //                   //     0.031,
                            //       //                 ),
                            //       //               ),
                            //       //               GestureDetector(
                            //       //                 onTap: () {
                            //       //                   final DocumentSnapshot
                            //       //                       index1 = widget.data!
                            //       //                           .data!.docs[0];
                            //       //                   var helpList =
                            //       //                       index1['help overview'];
                            //       //                   var helperList =
                            //       //                       currentUser[
                            //       //                           'helper List'];
                            //       //                   helperList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'middle',
                            //       //                   });

                            //       //                   helpList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'middle',
                            //       //                   });

                            //       //                   Navigator.pop(context);
                            //       //                   usersCollection
                            //       //                       .doc(currentUser[
                            //       //                           'help id'])
                            //       //                       .update(
                            //       //                     {
                            //       //                       'suck': true,
                            //       //                       'help overview':
                            //       //                           helperList,
                            //       //                     },
                            //       //                   ).then((value) =>
                            //       //                           usersCollection
                            //       //                               .doc('000')
                            //       //                               .update({
                            //       //                             'help overview':
                            //       //                                 helpList
                            //       //                           }));
                            //       //                 },
                            //       //                 child: Image.asset(
                            //       //                   'assets/icons/middle.png',
                            //       //                   height: horzintal
                            //       //                       ? width * 0.05
                            //       //                       : height * 0.05,
                            //       //                   width: horzintal
                            //       //                       ? height * 0.1
                            //       //                       : width * 0.1,
                            //       //                   // width: MediaQuery.of(
                            //       //                   //             context)
                            //       //                   //         .size
                            //       //                   //         .height *
                            //       //                   //     0.031,
                            //       //                 ),
                            //       //               ),
                            //       //               GestureDetector(
                            //       //                 onTap: () {
                            //       //                   final DocumentSnapshot
                            //       //                       index1 = widget.data!
                            //       //                           .data!.docs[0];
                            //       //                   var helpList =
                            //       //                       index1['help overview'];
                            //       //                   var helperList =
                            //       //                       currentUser[
                            //       //                           'helper List'];
                            //       //                   helperList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'bad',
                            //       //                   });

                            //       //                   helpList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'bad',
                            //       //                   });

                            //       //                   Navigator.pop(context);
                            //       //                   usersCollection
                            //       //                       .doc(currentUser[
                            //       //                           'help id'])
                            //       //                       .update(
                            //       //                     {
                            //       //                       'suck': true,
                            //       //                       'help overview':
                            //       //                           helperList,
                            //       //                     },
                            //       //                   ).then((value) =>
                            //       //                           usersCollection
                            //       //                               .doc('000')
                            //       //                               .update({
                            //       //                             'help overview':
                            //       //                                 helpList
                            //       //                           }));
                            //       //                 },
                            //       //                 child: Image.asset(
                            //       //                   'assets/icons/bad.png',
                            //       //                   height: horzintal
                            //       //                       ? width * 0.05
                            //       //                       : height * 0.05,
                            //       //                   width: horzintal
                            //       //                       ? height * 0.1
                            //       //                       : width * 0.1,
                            //       //                   // width: MediaQuery.of(
                            //       //                   //             context)
                            //       //                   //         .size
                            //       //                   //         .height *
                            //       //                   //     0.031,
                            //       //                 ),
                            //       //               ),
                            //       //             ],
                            //       //           )
                            //       //         ],
                            //       //       )
                            //       //     : SizedBox()
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }
                    ),),),);
        }
        
      
      );
      }
      //second second
      if (isHelping) {
        usersCollection.doc(user!.uid).get().then((value) {
     helperName = value.get('helperName');
     helperImage = value.get('helperImage');  
     helperUid = value.get('helperUid');

     
     print('seekeruid${seekersUid}');
     print('cuuser${user!.uid}') ;  
  });
        // showSnackBar('Helping is true');
        Timer(Duration(seconds: 10), () {
        // var heigh = 0.394;
        // var containerHeight = 0.109;
        showDialog(
            barrierColor: Colors.black45,
            barrierDismissible: false,
            context: context,
            builder: (ctx) => StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    content: Builder(builder: (context) {
                      // Get available height and width of the build area of this widget. Make a choice depending on the size
                      return SizedBox(
                        height: getProportionateScreenHeight(200),
                        width: getProportionateScreenWidth(60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the roundness
                                color: Color(0xffE74140), // Set the desired background color of the container
                                                          ),
                              padding: EdgeInsets.all(
                                  getProportionateScreenHeight(4)),
                              height:
                                  getProportionateScreenHeight(50),
                              // color: Color(0xffE74140),
                              child: Center(
                                child: Text(
                                  'Coming For Help',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              width: double.infinity,
                            ),
                            Text(
                            helperName.toString(),
                             style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize:16),
                                ),
                                GestureDetector(
                             child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                               child: Image.network(
                                 helperImage.toString(),
                                 height: getProportionateScreenHeight(60),
                                 width: getProportionateScreenWidth(60),
                               ),
                             ),
                                ),
                            TextButton(onPressed: (){

                            usersCollection.doc(user!.uid).update({
                                    'isHelping':false,
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return ChatScreen(
                                        currentUser: user!.uid,
                                        friendId: helperUid.toString(),
                                        friendName: helperName.toString(),
                                        friendImage: helperImage.toString());
                                  })));
                                  });
                              
                            }, child: Text('Okay',style: TextStyle(color: Colors.green))),
                            // Container(
                            //    height:getProportionateScreenHeight(40),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Text('Help Him',style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),),
                            // ),
                            //  Row(
                            //   children: [
                            //     Container(
                            //    height:getProportionateScreenHeight(10),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Text('Cancel',style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),),
                            // ),
                            // Container(
                            //    height:getProportionateScreenHeight(10),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Text('Help Him',style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),),
                            // ),
                            
                            //   ],
                            // )
                            // Container(
                            //   height:getProportionateScreenHeight(40),
                            //   color: Color.fromRGBO(80, 119, 118, 1),
                            //   width: double.infinity,
                            //   child: Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           Center(
                            //             child: Text(
                            //               'Finished?',
                            //               style: GoogleFonts.aBeeZee(
                            //                   fontSize:18,
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.white),
                            //             ),
                            //           ),
                            //           // Transform.scale(
                            //           //   scale: getProportionateScreenWidth(40),
                            //           //   child: Checkbox(
                            //           //       fillColor: MaterialStateProperty
                            //           //           .resolveWith<Color>(
                            //           //               (Set<MaterialState>
                            //           //                   states) {
                            //           //         if (states.contains(
                            //           //             MaterialState.disabled)) {
                            //           //           return Colors.white
                            //           //               .withOpacity(.32);
                            //           //         }
                            //           //         return Colors.white;
                            //           //       }),
                            //           //       checkColor: Colors.green,
                            //           //       value: val,
                            //           //       onChanged: (value) {
                            //           //         setState(() {
                            //           //           // heigh = 0.494;
                            //           //           if (val == false) {
                            //           //             val = true;
                            //           //           }

                            //           //           // containerHeight = 0.209;
                            //           //         });
                            //           //       }),
                            //           // ),
                            //         ],
                            //       ),
                            //       // val
                            //       //     ? Column(
                            //       //         children: [
                            //       //           Divider(
                            //       //             color: Colors.black,
                            //       //             height: 5,
                            //       //           ),
                            //       //           Text(
                            //       //             'Was The support useful?',
                            //       //             style: GoogleFonts.aBeeZee(
                            //       //                 fontSize: horzintal
                            //       //                     ? height * 0.030
                            //       //                     : width * 0.030,
                            //       //                 fontWeight: FontWeight.bold,
                            //       //                 color: Colors.white),
                            //       //           ),
                            //       //           SizedBox(
                            //       //             height: 10,
                            //       //           ),
                            //       //           Row(
                            //       //             mainAxisAlignment:
                            //       //                 MainAxisAlignment.center,
                            //       //             children: [
                            //       //               GestureDetector(
                            //       //                 onTap: () {
                            //       //                   final DocumentSnapshot
                            //       //                       index1 = widget.data!
                            //       //                           .data!.docs[0];
                            //       //                   var helpList =
                            //       //                       index1['help overview'];
                            //       //                   var helperList =
                            //       //                       currentUser[
                            //       //                           'helper List'];
                            //       //                   helperList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'good',
                            //       //                   });

                            //       //                   helpList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'good',
                            //       //                   });

                            //       //                   Navigator.pop(context);
                            //       //                   usersCollection
                            //       //                       .doc(currentUser[
                            //       //                           'help id'])
                            //       //                       .update(
                            //       //                     {
                            //       //                       'suck': true,
                            //       //                       'help overview':
                            //       //                           helperList,
                            //       //                     },
                            //       //                   ).then((value) =>
                            //       //                           usersCollection
                            //       //                               .doc('000')
                            //       //                               .update({
                            //       //                             'help overview':
                            //       //                                 helpList
                            //       //                           }));
                            //       //                 },
                            //       //                 child: Image.asset(
                            //       //                   'assets/icons/good.png',
                            //       //                   height: horzintal
                            //       //                       ? width * 0.05
                            //       //                       : height * 0.05,
                            //       //                   width: horzintal
                            //       //                       ? height * 0.1
                            //       //                       : width * 0.1,
                            //       //                   // width: MediaQuery.of(
                            //       //                   //             context)
                            //       //                   //         .size
                            //       //                   //         .height *
                            //       //                   //     0.031,
                            //       //                 ),
                            //       //               ),
                            //       //               GestureDetector(
                            //       //                 onTap: () {
                            //       //                   final DocumentSnapshot
                            //       //                       index1 = widget.data!
                            //       //                           .data!.docs[0];
                            //       //                   var helpList =
                            //       //                       index1['help overview'];
                            //       //                   var helperList =
                            //       //                       currentUser[
                            //       //                           'helper List'];
                            //       //                   helperList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'middle',
                            //       //                   });

                            //       //                   helpList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'middle',
                            //       //                   });

                            //       //                   Navigator.pop(context);
                            //       //                   usersCollection
                            //       //                       .doc(currentUser[
                            //       //                           'help id'])
                            //       //                       .update(
                            //       //                     {
                            //       //                       'suck': true,
                            //       //                       'help overview':
                            //       //                           helperList,
                            //       //                     },
                            //       //                   ).then((value) =>
                            //       //                           usersCollection
                            //       //                               .doc('000')
                            //       //                               .update({
                            //       //                             'help overview':
                            //       //                                 helpList
                            //       //                           }));
                            //       //                 },
                            //       //                 child: Image.asset(
                            //       //                   'assets/icons/middle.png',
                            //       //                   height: horzintal
                            //       //                       ? width * 0.05
                            //       //                       : height * 0.05,
                            //       //                   width: horzintal
                            //       //                       ? height * 0.1
                            //       //                       : width * 0.1,
                            //       //                   // width: MediaQuery.of(
                            //       //                   //             context)
                            //       //                   //         .size
                            //       //                   //         .height *
                            //       //                   //     0.031,
                            //       //                 ),
                            //       //               ),
                            //       //               GestureDetector(
                            //       //                 onTap: () {
                            //       //                   final DocumentSnapshot
                            //       //                       index1 = widget.data!
                            //       //                           .data!.docs[0];
                            //       //                   var helpList =
                            //       //                       index1['help overview'];
                            //       //                   var helperList =
                            //       //                       currentUser[
                            //       //                           'helper List'];
                            //       //                   helperList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'bad',
                            //       //                   });

                            //       //                   helpList.add({
                            //       //                     'id': currentUser[
                            //       //                         'help id'],
                            //       //                     'helper': currentUser[
                            //       //                         'help Name'],
                            //       //                     'time': DateTime.now(),
                            //       //                     'whoom': currentUser[
                            //       //                         'First Name'],
                            //       //                     'feedback': 'bad',
                            //       //                   });

                            //       //                   Navigator.pop(context);
                            //       //                   usersCollection
                            //       //                       .doc(currentUser[
                            //       //                           'help id'])
                            //       //                       .update(
                            //       //                     {
                            //       //                       'suck': true,
                            //       //                       'help overview':
                            //       //                           helperList,
                            //       //                     },
                            //       //                   ).then((value) =>
                            //       //                           usersCollection
                            //       //                               .doc('000')
                            //       //                               .update({
                            //       //                             'help overview':
                            //       //                                 helpList
                            //       //                           }));
                            //       //                 },
                            //       //                 child: Image.asset(
                            //       //                   'assets/icons/bad.png',
                            //       //                   height: horzintal
                            //       //                       ? width * 0.05
                            //       //                       : height * 0.05,
                            //       //                   width: horzintal
                            //       //                       ? height * 0.1
                            //       //                       : width * 0.1,
                            //       //                   // width: MediaQuery.of(
                            //       //                   //             context)
                            //       //                   //         .size
                            //       //                   //         .height *
                            //       //                   //     0.031,
                            //       //                 ),
                            //       //               ),
                            //       //             ],
                            //       //           )
                            //       //         ],
                            //       //       )
                            //       //     : SizedBox()
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }
                    ),),),);
        }
        
      
      );
      }
    });
  }
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Snackbar')));
    // _scaffoldKey.currentState!.showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //   ),
    // );
  }

  void dispose() {
  print('disposing');
  _positionStreamSubscription!.cancel();
  _streamSubscription?.cancel();
  super.dispose();
}
  

  @override
  void initState() {
    // getCurrentUserData();
    
    listenToNeedHelpStream();
    setPermission().then((value){
      _getCurrentPosition()
      .then((value) {
      locationData();
      setUserName();
      // currentPosition =  MyStaticVariables.getCurrentPosition();
      // getUrl();
      

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
      key: _scaffoldKey,
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
