import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/markerdata.dart';
import 'dart:math' show cos, sqrt, asin;

import '../../static_variables.dart';
import '../chatScreen/chat_screen.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "/mapScreen";
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  
  // var newLoading=true;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  // final geo = Geoflutterfire();
  //geolocator
  // String? _currentAddress;
  // static Position? _currentPosition;
  Position? _currentPosition = MyStaticVariables.getCurrentPosition();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  bool isLoading = true;
  List<MarkerData> markerDataList = [];
  //  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Marker> markers = {};
  String? destinationAdress;
  String? currentAdress;
  final List<Map> _allUsers = [];
  String? friedId;
  String? friendName;
  String? friendImage;
  // StreamSubscription<Position> ?_positionStreamSubscription;

  static GoogleMapController? _googleMapController;
  Set<Marker> markersInRadius = {};
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBP9e8Woff9_MOgBTKp5-paqePB2px5pns";
  Map<PolylineId, Polyline> polylines = {};
  LatLng startLocation = LatLng(27.6683619, 85.3101895);
  LatLng endLocation = LatLng(33.7260417, 72.8308683);
  double? selectedLatitude;
  double? selectedLongitude;
//
  List<LatLng> polylineCoordinates = [];
  // static Position? _currentPosition;
  // bool isLoading = true;

  void getUserData(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        // .where('username', isEqualTo: searchController.text)

        .then((value) {
      friedId = value.data()!['uid'];
      friendName = value.data()!['username'];
      friendImage = value.data()!['image'];
    });
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      PointLatLng(selectedLatitude!, selectedLongitude!),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 7,
    );

    setState(() {
      polylines[id] = polyline;
    });
  }
//
// void dispose() {
//   print('disposing');
//   _positionStreamSubscription!.cancel();
//   super.dispose();
// }
  void initMarker(data, id, name) async {
    print('xmarker${name}');
    MarkerId markerId = MarkerId(id);
    final Marker marker = Marker(
        infoWindow: InfoWindow(
            title: (user!.uid != id) ? name : 'You',
            snippet: (user!.uid != id) ? 'Tap to Chat' : '',
            onTap: () {
              // print(user!.uid);
              // print(id);
              // getUserData(id);
              // print(id);
              if (user!.uid != id) {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return ChatScreen(
                      currentUser: user!.uid,
                      friendId: friedId.toString(),
                      friendName: friendName.toString(),
                      friendImage: friendImage.toString());
                })));
              }
            }),
        markerId: markerId,
        icon: markerIcon,
        position: LatLng(data['location'].latitude, data['location'].longitude),
        onTap: () {
          // print(user!.uid);
          getUserData(id);
          selectedLatitude = data['location'].latitude;
          selectedLongitude = data['location'].longitude;
          getDirections();
          print('pressed${data['location'].latitude}');
          // getAddressFromLatLong(
          //     data['location'].latitude, data['location'].longitude);
        });
    // setState(() {
    // markers.clear();

    setState(() {
      // markers.clear();
      markers.add(marker);
    });
    print("markers length${markers.length}");
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

  void getMarkersInRadius(LatLng center, double radius) {
    markers.forEach((marker) {
      if (distanceBetween(center, marker.position) <= radius) {
        setState(() {
          // markersInRadius.clear();
          markersInRadius.add(marker);
          // print("markers in Radius ${markersInRadius.length}");
        });
      }
    });
    // return markersInRadius;
  }

  void locationData() async {
    firebaseFirestore.collection("usersLocation").get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          print('location Data ${snapshot.docs[i].data()['location']}');
          // inRange(snapshot.docs[i].data()['location'].latitude,
          //     snapshot.docs[i].data()['location'].longitude);
          addCustomIcon();
          initMarker(snapshot.docs[i].data(), snapshot.docs[i].id,
              snapshot.docs[i].data()['username']);
        }
        getMarkersInRadius(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude), 3);
      }
    });
    setState(() {
      isLoading = false;
    });
    
  }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  // Future<void> getAddressFromLatLong(double latitude, double longitude) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(latitude, longitude);
  //   // print(placemarks);
  //   Placemark place = placemarks[0];
  //   destinationAdress =
  //       '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

  //   // print(destinationAdress);
  // }

  // Future<void> getCurrentAddressFromLatLong(
  //     double latitude, double longitude) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(latitude, longitude);
  //   // print(placemarks);
  //   Placemark place = placemarks[0];
  //   currentAdress =
  //       '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

  //   // print(currentAdress);
  // }

  // Future<void> getCurrentAddressFromLatLong(
  //     double latitude, double longitude) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(latitude, latitude);
  //   // print(placemarks);
  //   Placemark place = placemarks[0];
  //   currentAdress =
  //       '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

  //   print("current${currentAdress}");
  // }

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();
  //   // print('object');

  //   if (!hasPermission) return;

  //   await Geolocator.getPositionStream().listen((Position position) {
  //     _currentPosition = position;
  //     updateLocation(position.latitude, position.longitude);
  //   });
  // }
//   Future<void> _getCurrentPosition() async {
//     print('ok');
//     bool? hasPermission = MyStaticVariables.getHasPermission();
//     if (!(hasPermission!)){
//       print('ddd');
//       return;
//     } 

// _positionStreamSubscription=Geolocator.getPositionStream().listen((Position position) {
//       print('getstreampostion${position.latitude}');
//       MyStaticVariables.position=position;
//       _currentPosition = position;
//       print('current positionxyz${_currentPosition}');
//       // newLoading=false;
//       updateLocation(position.latitude, position.longitude);

//     });
    
//   }

  // void inRange(double latitude, double longitude) {

  
    
  //        double distance = distanceBetween(
  //       LatLng(_currentPosition!.latitude, _currentPosition!.latitude),
  //       LatLng(latitude, longitude));
  //   // print("distace${distance}");
  //   // if (distance < 50) {
  //   firebaseFirestore.collection("users").doc(user!.uid).set({
  //     "inRange": true,
  //   },SetOptions(merge: true));
 
  //   // print(_currentPosition);

  //   // }
  //   // distanceBetween(latitude: 10, longitude: 20);
  //   // GeoPoint location = GeoPoint(latitude, longitude);
  // }

  // void setUserName() {
  //   firebaseFirestore.collection("users").doc(user!.uid).get().then((value) {
  //     print('userscollection${value.data()!['username']}');
  //     firebaseFirestore.collection("usersLocation").doc(user!.uid).set({
  //       "username": value.data()!['username'],
  //     },SetOptions(merge: true));

  //     // print(name);
  //   });
  // }

//   Future updateLocation(
//   double latitude,double longitude
// ) {
//   GeoPoint location = GeoPoint(latitude, longitude);
//     return firebaseFirestore.collection('usersLocation').doc(user!.uid).update({
      
//       'location':location
//     }).catchError((e) => {
//       firebaseFirestore.collection('usersLocation').doc(user!.uid).set({
//       'location':location
//     },SetOptions(merge: true)),
//     });
// }

  // void updateLocation(double latitude, double longitude) {
  //   GeoPoint location = GeoPoint(latitude, longitude);
  //   firebaseFirestore.collection("usersLocation").doc(user!.uid).set({
  //     "location": location,
  //   },SetOptions(merge: true));
  //   print('update location called ${location.latitude}');
  // }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/icons/userlocation.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  //
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(MyStaticVariables.getCurrentPosition()!.latitude,
       MyStaticVariables.getCurrentPosition()!.longitude),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  @override
  void initState() {
    print('dsd');  
    locationData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :
          StreamBuilder(
            // initialData: [],
              stream: FirebaseFirestore.instance
                  .collection("usersLocation")
                  .snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData&& snapshot.data!=null){
                  print('loaded');
                   return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: markersInRadius,
                    polylines: Set<Polyline>.of(polylines.values),
                    circles: {
                      Circle(
                          circleId: CircleId('1'),
                          center: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          radius: 500,
                          fillColor: Color.fromARGB(59, 33, 149, 243),
                          strokeWidth: 2,
                          strokeColor: Color.fromARGB(202, 255, 255, 255))
                    },
                  );
                }
              else if(snapshot.hasError){
                print('error');
              }
                
                 else {
                  print('still loading');
                  return const CircularProgressIndicator();
                 
                }
                return CircularProgressIndicator();
              }),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     _goToTheLake();
      //     //   LocationServices()
      //     // .getDirections(LatLng(_currentPosition!.latitude, _currentPosition!.longitude), const LatLng(50,50));
      //   },
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  // void _goToTheLake() async {
  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //   print(fcmToken);

  //   // getCurrentAddressFromLatLong(
  //   //     _currentPosition!.latitude, _currentPosition!.longitude);
  //   // LocationServices()
  //   //     .getDirections(LatLng(_currentPosition!.latitude, _currentPosition!.longitude), const LatLng(50,50));
  // }
}
