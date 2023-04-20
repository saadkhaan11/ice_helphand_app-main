import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import '../models/added_contacts.dart';

class ContactsProvider with ChangeNotifier {
  List<AddedContacts> addedContacts = [];

  void addContact(String? name, List<Item>? phNo) {
    addedContacts.add(AddedContacts(name: name, phNo: phNo));
    notifyListeners();
    // print('pressed');
  }

  void removeContact(int index) {
    addedContacts.removeAt(index);
    notifyListeners();
  }
}
