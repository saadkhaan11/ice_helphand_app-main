import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ice_helphand/models/added_contacts.dart';
import 'package:ice_helphand/provider/auth_provider.dart';
import 'package:ice_helphand/size_config.dart';
import 'package:provider/provider.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../models/notification.dart';
import '../../models/notification_body.dart';
import '../../provider/contacts_provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../services/notification_services.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TwilioFlutter? twilioFlutter;
  List<AddedContacts>? contactsList;
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid:
            'AC8f26982050b5cbfb2de055378c190dda', // replace *** with Account SID
        authToken:
            '944b9d8ba60ef499856a612cc2a00a98', // replace xxx with Auth Token
        twilioNumber: '+16206469607' // replace .... with Twilio Number
        );

    contactsList =
        Provider.of<ContactsProvider>(context, listen: false).addedContacts;

    print(contactsList!.length);
    // pno();
    print('twillo called');
    super.initState();
  }

  // List<String> clsit = ['+923115838578', '+923468544378', '+923468544378'];

  void sendSmsToAll() {
    for (var element in contactsList!) {
      twilioFlutter!.sendSMS(toNumber: '+923115838578', messageBody: 'Hi');
    }
  }

  Future<void> call() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('helloWorld');
    final results = await callable();
    print(results);
  }
  // final response = await functions.call();

  @override
  Widget build(BuildContext context) {
    final Auth authProvider = Auth();
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: getProportionateScreenWidth(200),
            child: const Text(
              'Emergency Help Needed?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
          InkWell(
              onTap: () {
                print('call');
                //
                notificationService.createNotification(MyNotification(
                    to:
                        "erY7HqsPTy2PaVtxZ4tpqG:APA91bEd6aFVObqJtlPKLxSS7pipYCE3wM_LHkb9SdV9QHngSQzQXFMtVoir_orrvtoS0ExYLGC3qP_RD_EBlet-ELoKNvMlKohhbE90swOvQ44F0ZGNWEAzSlZm4YT_Qs38iX4vHj-l",
                    notification: NotificationBody(
                        title: "Test", body: "Notification Testing")));

                // sendSmsToAll();

                // twilioFlutter!.sendSMS(
                //     toNumber: '+923115838578', messageBody: 'hello world');
              },
              child: Image.asset('assets/images/Alertbutton.png')),
          SizedBox(
            height: getProportionateScreenHeight(80),
          ),
          Text(
            'Choose the emergency Situation',
            style: TextStyle(fontSize: 12),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
          height: getProportionateScreenHeight(100),
          width: getProportionateScreenWidth(140),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          // color: Colors.amber,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: SizedBox(
                  width: getProportionateScreenWidth(80),
                  child: Text(
                    'I have an Accident',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/icons8-circled.png'),
                  Image.asset('assets/images/icons8-accident.png')
                ],
              ),

              // SvgPicture.asset(
              //   'assets/icons/circlearow.svg',
              // )
            ],
          )),
    );
  }
}
