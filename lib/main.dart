import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/models/myuser.dart';
import 'package:ice_helphand/provider/auth_provider.dart';
import 'package:ice_helphand/provider/contacts_provider.dart';
import 'package:ice_helphand/routes.dart';
import 'package:ice_helphand/screens/wrapper.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
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
