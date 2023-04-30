import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/models/myuser.dart';
import 'package:ice_helphand/provider/auth_provider.dart';
import 'package:ice_helphand/provider/contacts_provider.dart';
import 'package:ice_helphand/routes.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: StreamProvider<MyUser?>.value(
      value: Auth().user,
      initialData: null,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => ContactsProvider())),
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
