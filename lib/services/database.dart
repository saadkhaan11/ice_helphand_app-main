import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  String uid;
  DatabaseService(this.uid);

  final CollectionReference createMyUser =
      FirebaseFirestore.instance.collection('users');
   
  
  //storing token of cloud messeging in firebase
  Future storeToken(
      {required String? token,
     }) async {
    return await createMyUser.doc(uid).collection('token').doc(token).set({
      'token':token,
      'timestamp':FieldValue.serverTimestamp(),
    });
     }
  //string user data in firebase
  Future createmyUser(
      {required String email,
      required String username,
      required String image}) async {
    return await createMyUser.doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
      'image': image,
      'date': DateTime.now()
    });
  }
}
