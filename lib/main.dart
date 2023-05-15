import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/models/myuser.dart';
import 'package:ice_helphand/provider/auth_provider.dart';
import 'package:ice_helphand/provider/contacts_provider.dart';
import 'package:ice_helphand/routes.dart';
import 'package:ice_helphand/screens/map/map_screen.dart';
import 'package:ice_helphand/screens/wrapper.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  final messaging = FirebaseMessaging.instance;
// Request permission
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
//Register with FCM
  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }

//Foreground message handler
  final _messageStreamController = BehaviorSubject<RemoteMessage>();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });
//Background message handler for Android/iOS
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   // Set the callback for handling notification clicks when the app is already open
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle the click action here
    print('Notification clicked!');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
   },);

    // Example: Navigating to the 'details' route and calling a function
    Navigator.pushNamed(MyApp.appContext, MapScreen.routeName).then((_) {
      // Function to perform after navigating to the 'details' route
      // performSpecificFunction();
    });
  ;

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   static late BuildContext appContext; // Define a static variable to store the BuildContext
  const MyApp({super.key});
   // Store the BuildContext from the MaterialApp widget
    
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    appContext = context;
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
