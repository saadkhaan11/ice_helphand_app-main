import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice_helphand/screens/contact/add_contact_screen.dart';

import '../../../models/added_contacts.dart';

class ContactsAppBar extends StatelessWidget {
  bool isavatar;
  bool isaddButton;
  List<AddedContacts>? contactsList;
  Function(String name, List<Item>? phNo)? addContact;

  ContactsAppBar({
    super.key,
    required this.isavatar,
    required this.isaddButton,
    this.contactsList,
    this.addContact,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isavatar
              ? SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/user.png',
                      fit: BoxFit.cover,
                      // width: 50,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.navigate_before),
                ),
          Text(
            'Contacts',
            style:
                GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          isaddButton
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AddContactScreen.routeName,
                        arguments: {
                          'contactsList': contactsList,
                          'addContactFunction': addContact
                        });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Add',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/plus.svg',
                        fit: BoxFit.cover,
                        // width: 50,
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
