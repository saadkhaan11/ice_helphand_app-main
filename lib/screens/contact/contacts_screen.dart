import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/provider/contacts_provider.dart';
import 'package:ice_helphand/screens/contact/widgets/contact_card.dart';
import 'package:ice_helphand/screens/contact/widgets/contact_search_field.dart';
import 'package:ice_helphand/screens/contact/widgets/contacts_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/added_contacts.dart';
import '../../size_config.dart';

class ContactsScreen extends StatefulWidget {
  static const routeName = "/ContactsScreen";
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    ContactsProvider contactsProvider = Provider.of<ContactsProvider>(context);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(children: [
        ContactsAppBar(
          isaddButton: true,
          isavatar: true,
          contactsList: contactsProvider.addedContacts,
          addContact: contactsProvider.addContact,
        ),
        // ContactsSearchField(
        //   runFilter: (String value) {},
        // ),
        // TextButton(
        //     onPressed: () {
        //       print(addedContacts.length);
        //     },
        //     child: Text('Press')),
        SizedBox(
          height: 700,
          child: ListView.builder(
            itemCount:
                // isLoading
                //     ? 10
                //     :
                contactsProvider.addedContacts.length,
            itemBuilder: (context, index) {
              final item = contactsProvider.addedContacts[index];

              // if (isLoading) {
              //   // print("if $isLoading");
              //   return buildShimmer();
              // } else {
              // print(isLoading);
              return Dismissible(
                onDismissed: (direction) {
                  contactsProvider.addedContacts.removeAt(index);
                  // setState(() {

                  // });
                },
                key: UniqueKey(),
                background: slideLeftBackground(),
                child: ContactCard(
                  name: contactsProvider.addedContacts[index].name,
                  phNo: contactsProvider.addedContacts[index].phNo,
                  addIcon: false,
                  removeContactFunction: () {
                    contactsProvider.removeContact(index);
                  },
                ),
              );
              // }
            },
          ),
        ),
        //
      ]),
    )));
  }
}

Widget buildShimmer() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(70),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: getProportionateScreenHeight(70),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(70)),
        ),
      ),
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    // color: Colors.red,
    decoration: BoxDecoration(
        color: Colors.red, borderRadius: BorderRadius.circular(70)),
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(
            width: getProportionateScreenWidth(30),
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
