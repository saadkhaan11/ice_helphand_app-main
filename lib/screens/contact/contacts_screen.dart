import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/provider/contacts_provider.dart';
import 'package:ice_helphand/screens/contact/widgets/contact_card.dart';
import 'package:ice_helphand/screens/contact/widgets/contacts_appbar.dart';
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
  List<AddedContacts> addedContatcs = [];
  List<AddedContacts> listContacts = [];
  bool isLoading = true;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference createMyUser =
      FirebaseFirestore.instance.collection('users');
  String? phoneNo;
  void loadContacts() async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    List<AddedContacts> tempContacts = [];
    // isLoading = true;
    // print("x${addedContatcs}");
    // addedContatcs.clear();
    // print("xamir${addedContatcs}");

    createMyUser.doc(uid).collection('conatctList').get().then((snapshot) {
      if (snapshot != null) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          List<Item> phno = [];
          var data = snapshot.docs[i].data();
          print('data${data['phno']}');

          // phoneNo = data['phno'];
          // print(data['phno']);
          phno.add(Item(label: data['name'], value: data['phno']));
          // print(phno.length);
          // phno!.add(Item(label: data['name'], value: data['phno']));
          // print(phno[i].value);
          tempContacts.add(AddedContacts(name: data['name'], phNo: phno));
          print("tempcontats${tempContacts[i].phNo!.first.value}");
          // print("xxxx${addedContatcs.length}");
        }
        listContacts = tempContacts;

        setState(() {
          isLoading = false;
          print(isLoading);
        });
        // print("addedContacts${addedContatcs.length}");
      }
    });
    print("Contactsloaded");
  }

  @override
  void initState() {
    // contactsProvider = Provider.of<ContactsProvider>(context);
    loadContacts();
    // setState(() {
    //   isLoading = false;
    // });
    // if (listContacts.isEmpty) {
    //   print("added${addedContatcs.length}");
    //   loadContacts();
    // }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ContactsProvider contactsProvider = Provider.of<ContactsProvider>(context);
    // addedContatcs = contactsProvider.addedContacts;
    // print("addedContacts${addedContatcs}");
    // listContacts = addedContatcs;
    // print("listContacts${listContacts}");
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                child: Column(children: [
                  TextButton(
                      onPressed: () {
                        loadContacts();
                      },
                      child: Text('press')),
                  ContactsAppBar(
                    isaddButton: true,
                    isavatar: true,
                    contactsList: listContacts,
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
                          listContacts.length,
                      itemBuilder: (context, index) {
                        // final item = contactsProvider.addedContacts[index];

                        // if (isLoading) {
                        //   // print("if $isLoading");
                        //   return buildShimmer();
                        // } else {
                        // print(isLoading);
                        return Dismissible(
                          onDismissed: (direction) {
                            listContacts.removeAt(index);
                            contactsProvider.removeContact(
                                listContacts[index].phNo!.first.value);
                            // setState(() {

                            // });
                          },
                          key: UniqueKey(),
                          background: slideLeftBackground(),
                          child: ContactCard(
                            name: listContacts[index].name,
                            phNo: listContacts[index].phNo,
                            addIcon: false,
                            removeContactFunction: () {
                              contactsProvider.removeContact(
                                  listContacts[index].phNo!.first.value);
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
