import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ice_helphand/models/myuser.dart';
import 'package:ice_helphand/provider/auth_provider.dart';
import 'package:ice_helphand/provider/contacts_provider.dart';
import 'package:ice_helphand/routes.dart';
import 'package:ice_helphand/screens/wrapper.dart';
import 'package:ice_helphand/static_variables.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'services/pushnotification_service.dart';
import 'dart:async';
import 'firebase_options.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   if (kDebugMode) {
//     print("Handling a background message: ${message.messageId}");
//     print('Message data: ${message.data}');
//     print('Message notification: ${message.notification?.title}');
//     print('Message notification: ${message.notification?.body}');
//   }
// }
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    
);

  Provider.debugCheckInvalidValueType = null;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // final messaging = FirebaseMessaging.instance;
// Request permission
  // final settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
//Register with FCM
  // if (kDebugMode) {
  //   print('Permission granted: ${settings.authorizationStatus}');
  // }

  // String? token = await messaging.getToken();

  // if (kDebugMode) {
  //   print('Registration Token=$token');
  // }

//Foreground message handler
  // final _messageStreamController = BehaviorSubject<RemoteMessage>();
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   if (kDebugMode) {
  //     print('Handling a foreground message: ${message.messageId}');
  //     print('Message data: ${message.data}');
  //     print('Message notification: ${message.notification?.title}');
  //     print('Message notification: ${message.notification?.body}');
  //   }

  //   _messageStreamController.sink.add(message);
  // });
//Background message handler for Android/iOS
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   await FirebaseMessaging.instance.getToken();

// await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

// NotificationSettings settings = await messaging.requestPermission(
//   alert: true,
//   announcement: false,
//   badge: true,
//   carPlay: false,
//   criticalAlert: false,
//   provisional: false,
//   sound: true,
// );
// print('User granted permission: ${settings.authorizationStatus}');
//  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//     // TODO: handle the received notifications
//   } else {
//     print('User declined or has not accepted permission');
//   }
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('Got a message whilst in the foreground!');
//   print('Message data: ${message.data}');

//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//   }
// });
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  PushNotificationService notificationSerivce = PushNotificationService();
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

  // Future<void> setPermission() async {
  //   final hasPermission = await _handleLocationPermission();
  //   print('permission main wali ${hasPermission}');
  //   MyStaticVariables.setHasPermission(hasPermission);
  //   print('has permission${hasPermission}');
  //   // print('object');

  //   // if (!hasPermission) return;

  //   // Geolocator.getPositionStream().listen((Position position) {
  //   //   print('position donesad');
  //   //   MyStaticVariables.setMyStaticVariable(position);
  //   //   updateLocation(position.latitude, position.longitude);
  //   // });
  // }

  @override
  void initState() {
    
    // TODO: implement initState
  
    // setPermission();
    
    notificationSerivce.requestPermission();
    notificationSerivce.firebaseInit(context);
    notificationSerivce.setupInteractMessage(context);
    notificationSerivce.getToken().then((value) {
      print('token');
      print(value);
    });

    // _getCurrentPosition().then((_) {
    //   print('main current position done');
    //   // print('then');
    //   // setUserName();
    //   // locationData();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: StreamProvider<MyUser?>.value(
      value: AuthProvider().user,
      initialData: null,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => ContactsProvider())),
          ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const Wrapper(),
          // initialRoute: '/',
          initialRoute: Wrapper.routeName,
          routes: routes,
        ),
      ),
    ));
  }
}
