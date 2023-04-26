import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/markerdata.dart';
import 'dart:math' show cos, sqrt, asin;
// import 'package:geoflutterfire/geoflutterfire.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "/mapScreen";
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  // final geo = Geoflutterfire();
  //geolocator
  // String? _currentAddress;
  static Position? _currentPosition;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  bool isLoading = true;
  List<MarkerData> markerDataList = [];
  Set<Marker> markers = {};
  static GoogleMapController? _googleMapController;
  Set<Marker> markersInRadius = {};
  void initMarker(data, id) {
    // print('initmarker');
    MarkerId markerId = MarkerId(id);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(data['location'].latitude, data['location'].longitude));
    // setState(() {
    markers.clear();
    markers.add(marker);
    // getMarkersInRadius(
    //           LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    //           1.1);
    // getMarkersInRadius(LatLng(37.4219999, -122.0840575), 500);
    // });
    // print(markers.length);
    // markers[markerId] = marker;
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
          markersInRadius.clear();
          markersInRadius.add(marker);
        });
      }
    });
    // return markersInRadius;
  }

  void locationData() {
    Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
        firebaseFirestore.collection("usersLocation").get();
    querySnapshot.then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          print("geolocation=>${snapshot.docs[i].data()['location'].latitude}");
          print("geolocation=>${snapshot.docs[i].data()['location'].longitude}");
          initMarker(snapshot.docs[i].data(), snapshot.docs[i].id);
          // getMarkersInRadius(
          //     LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          //     1.1);
          // print("Doclist${snapshot.docs[i].data()['locaion']}");
        }
         getMarkersInRadius(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              5000);
      }
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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    // print('object');

    if (!hasPermission) return;
    await Geolocator.getPositionStream().listen((Position position) {
      _currentPosition = position;
       isLoading = false;
       updateLocation(position.latitude, position.longitude);
       locationData();
    });
    //     .then((Position position) {
    //   setState(() {
    //     _currentPosition = position;
    //     isLoading = false;
    //     print("Loading :$isLoading");
    //   });
    //   updateLocation(position.latitude, position.longitude);
    //   // print(position.latitude);
    //   // _getAddressFromLatLng(_currentPosition!);
    // }
    // ).catchError((e) {
    //   debugPrint(e);
    // });
  }

  void updateLocation(double latitude, double longitude) {
    GeoPoint location = GeoPoint(latitude, longitude);
    firebaseFirestore.collection("usersLocation").doc(user!.uid).set({
      "location": location,
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/mylocation.png")
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
    target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
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
    addCustomIcon();
    _getCurrentPosition();
    // locationData();
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position? position) {
    //   _getCurrentPosition();
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("usersLocation")
                  .snapshots(),
              builder: (context, snapshot) {
                // print('xamir');
                if (snapshot.hasData) {
//Extract the location from document
                  GeoPoint location = snapshot.data!.docs.first.get("location");
// Check if location is valid
                  if (location == null) {
                    return Text("There was no location data");
                  }
                  print('snapshot ${snapshot.data!.docs.first['location']}');
                  // Remove any existing markers
                  // markers.clear();
                  // final latLng = LatLng(location.latitude, location.longitude);
// Add new marker with markerId.
                  // markers.add(
                  //     Marker(markerId: MarkerId("location"), position: latLng));
// If google map is already created then update camera position with animation
                  // _googleMapController
                  //     ?.animateCamera(CameraUpdate.newCameraPosition(
                  //   CameraPosition(
                  //     target: latLng,
                  //     zoom: 15,
                  //   ),
                  // ));
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers:markersInRadius,
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
                return CircularProgressIndicator();
              }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  void _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    locationData();
    // print(_currentPosition?.latitude);
    // print(_currentPosition?.longitude);
  }
}
