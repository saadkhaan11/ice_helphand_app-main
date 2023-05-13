import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ice_helphand/provider/auth_provider.dart';

import '../models/added_contacts.dart';

class ContactsProvider with ChangeNotifier {
  List<AddedContacts> addedContacts = [];
  List<AddedContacts> get getaddedContacts {
    return [...addedContacts];
  }

  // String? uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // void inputData() {
  //   final User? user = _auth.currentUser;
  //    uid = user!.uid;
  //   // here you write the codes to input the data into firestore
  // }

  final CollectionReference createMyUser =
      FirebaseFirestore.instance.collection('users');

  void addContact(String? name, List<Item>? phNo) {
    final User? user = _auth.currentUser;
    final uid = user!.uid;

    if (phNo != null) {
      String phone = phNo.first.value != null
          ? phNo.first.value!.trim().replaceAll(RegExp('[^A-Za-z0-9+]'), '')
          : "";
      if (phone.startsWith("0")) {
        phone = phone.replaceRange(0, 1, '+92');
        print("If${phone}");
      } else {
        phone.split(" ").join("");
        print("else${phone}");
      }
      // print('contact added${phNo.first.value}');
      createMyUser.doc(uid).collection('conatctList').doc(phone).set({
        'name': name,
        'phno': phone,
      });

      addedContacts.add(AddedContacts(name: name, phNo: phNo));
      notifyListeners();
      // print('pressed');
    }
  }

  void fetchContacts() async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    List<AddedContacts> tempContacts = [];

    createMyUser.doc(uid).collection('conatctList').get().then((snapshot) {
      if (snapshot != null) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          List<Item> phno = [];
          var data = snapshot.docs[i].data();
          phno.add(Item(label: data['name'], value: data['phno']));
          tempContacts.add(AddedContacts(name: data['name'], phNo: phno));
        }
        addedContacts = tempContacts;
      }
    });
  }

  void removeContact(String? phone) {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    // addedContacts.removeAt(index);
    createMyUser
        .doc(uid)
        .collection('conatctList')
        .doc(phone)
        .delete()
        .then((value) {
      print('deteted');
      print(phone);
    });
    notifyListeners();
  }
}
