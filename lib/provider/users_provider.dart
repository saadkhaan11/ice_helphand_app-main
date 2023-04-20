// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';

// class UserProvider with ChangeNotifier {
//   Future<void> getData() async {
//     final CollectionReference _collectionRef =
//         FirebaseFirestore.instance.collection('users');
//     // Get docs from collection reference
//     QuerySnapshot querySnapshot = await _collectionRef.get();

//     // Get data from docs and convert map to List
//     final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//     print(allData);
//   }
// }
