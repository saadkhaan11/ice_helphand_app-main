import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String uid;
  DatabaseService(this.uid);

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  //storing token of cloud messeging in firebase
  Future storeToken({
    required String? token,
  }) async {
    return await usersCollection.doc(uid).collection('token').doc(token).set({
      'token': token,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void deleteToken() async {
    String token = usersCollection.doc(uid).collection('token').doc().id;
    await usersCollection.doc(uid).collection('token').doc(token).delete();
  }

  //string user data in firebase
  Future createmyUser({
    required String email,
    required String username,
    required String image,
    required String fName,
    required String lName,
  }) async {
    return await usersCollection.doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
      'image': image,
      'date': DateTime.now(),
      'firstName': fName,
      'lastName': lName,
    });
  }

  void deleteMyUser() async {
    await usersCollection.doc(uid).delete();
    deleteToken();
  }
}
