import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String email;
  String username;
  String image;
  Timestamp date;
  String uid;
  UserModel(this.email, this.username, this.uid, this.image, this.date);

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(snapshot['email'], snapshot['username'], snapshot['uid'],
        snapshot['image'], snapshot['date']);
  }
}
