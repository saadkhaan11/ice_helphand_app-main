import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String uid;
  DatabaseService(this.uid);

  final CollectionReference createMyUser =
      FirebaseFirestore.instance.collection('users');
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
