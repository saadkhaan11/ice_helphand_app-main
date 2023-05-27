import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/screens/contact/widgets/contact_card.dart';
// import 'package:ice_helphand/screens/contact/widgets/contact_search_field.dart';
import 'package:ice_helphand/screens/contact/widgets/contacts_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/added_contacts.dart';
import '../../size_config.dart';

class AddContactScreen extends StatefulWidget {
  static const routeName = "/addContactsScreen";
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  bool isLoading = false;
  List<Contact> contactsList = [];
  bool textFieldSelected = false;
  int charLength = 0;
  final List _allUsers = [];
  List<Contact> _foundUsers = [];
  // List<AddedContacts> addedContacts = [];

  void getPermission() async {
    // print('permissions');
    if (await Permission.contacts.isGranted) {
      getContacts();
    } else {
      print('not granted');
      await Permission.contacts.request();
    }
  }

  void getContacts() async {
    setState(() {
      isLoading = true;
    });
    // print(isLoading);
    // await Future.delayed(Duration(seconds: 2));
    contactsList = await ContactsService.getContacts();
    print('contacts list${contactsList}');
    setState(() {
      isLoading = false;
      // print('called $isLoading');
    });
    // print(isLoading);
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      charLength = enteredKeyword.length;
      print(charLength);
      if (charLength < 1) {
        textFieldSelected = false;
      } else {
        textFieldSelected = true;
      }
    });
    List<Contact> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = contactsList;
    } else {
      results = contactsList
          .where((contact) => contact.displayName!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myArgument = ModalRoute.of(context)!.settings.arguments as Map;
    List<AddedContacts> addedContacts = myArgument['contactsList'];
    Function function = myArgument['addContactFunction'];

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(children: [
        ContactsAppBar(
          isavatar: false,
          isaddButton: false,
        ),
        // TextButton(
        //     onPressed: () {
        //       print(addedContacts.length);
        //     },
        //     child: Text('Press')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            // focusNode: _focus,
            // style: TextStyle(fontSize: 1),
            onTap: () {
              textFieldSelected = true;
            },
            onChanged: (value) => _runFilter(value),
            // controller: searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              prefixIcon: const Icon(
                Icons.search,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.red),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //   borderSide: BorderSide(color: Colors.blue),
              // ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
              hintText: "Type in your text",
              fillColor: const Color(0x0d2F2F2F),
            ),
          ),
        ),
        SizedBox(
          height: 700,
          child: ListView.builder(
            itemCount: isLoading
                ? 10
                : textFieldSelected
                    ? _foundUsers.length
                    : contactsList.length,
            itemBuilder: (context, index) {
              if (isLoading) {
                // print("if $isLoading");
                return buildShimmer();
              } else {
                // print(isLoading);
                return ContactCard(
                  name: textFieldSelected
                      ? _foundUsers[index].displayName
                      : contactsList[index].displayName,
                  phNo: textFieldSelected
                      ? _foundUsers[index].phones
                      : contactsList[index].phones,
                  addIcon: true,
                  addedContacts: addedContacts,
                  addContactfunction: function,
                );
              }
            },
          ),
        ),
      ])),
    ));
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
