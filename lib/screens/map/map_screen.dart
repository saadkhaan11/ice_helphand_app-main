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
  //  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Marker> markers = {};
  String? destinationAdress;
  String? currentAdress;

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

  void initMarker(data, id) async {
    // print('initmarker');
    MarkerId markerId = MarkerId(id);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(data['location'].latitude, data['location'].longitude),
        onTap: () {
          selectedLatitude = data['location'].latitude;
          selectedLongitude = data['location'].longitude;
          getDirections();
          print('pressed${data['location'].latitude}');
          getAddressFromLatLong(
              data['location'].latitude, data['location'].longitude);
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
    Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
        firebaseFirestore.collection("usersLocation").get();
    querySnapshot.then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          inRange(snapshot.docs[i].data()['location'].latitude,
              snapshot.docs[i].data()['location'].longitude);

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

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    destinationAdress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    print(destinationAdress);
  }

  Future<void> getCurrentAddressFromLatLong(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    currentAdress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    print(currentAdress);
  }

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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    // print('object');

    if (!hasPermission) return;

    await Geolocator.getPositionStream().listen((Position position) {
      print("current position${_currentPosition}");
      _currentPosition = position;
      print("CP:${_currentPosition}");
      print("Curent Positin${_currentPosition}");

      updateLocation(position.latitude, position.longitude);
      // locationData();
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

  void inRange(double latitude, double longitude) {
    double distance = distanceBetween(
        LatLng(_currentPosition!.latitude, _currentPosition!.latitude),
        LatLng(latitude, longitude));
    print("distace${distance}");
    // if (distance < 50) {
    firebaseFirestore.collection("users").doc(user!.uid).update({
      "inRange": true,
    });
    // }
    // distanceBetween(latitude: 10, longitude: 20);
    // GeoPoint location = GeoPoint(latitude, longitude);
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
    // markers.add(Marker(
    //   //add start location marker
    //   markerId: MarkerId(startLocation.toString()),
    //   position: startLocation, //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Starting Point ',
    //     snippet: 'Start Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));

    // markers.add(Marker(
    //   //add distination location marker
    //   markerId: MarkerId(endLocation.toString()),
    //   position: endLocation, //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Destination Point ',
    //     snippet: 'Destination Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));

    // getDirections();

    _getCurrentPosition().then((_) {
      // print('then');
      locationData();
      addCustomIcon();
      setState(() {
        isLoading = false;
      });
    });

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
          ? const Center(
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
                    markers: markers,
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

  void _goToTheLake() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);

    // getCurrentAddressFromLatLong(
    //     _currentPosition!.latitude, _currentPosition!.longitude);
    // LocationServices()
    //     .getDirections(LatLng(_currentPosition!.latitude, _currentPosition!.longitude), const LatLng(50,50));
  }
}
