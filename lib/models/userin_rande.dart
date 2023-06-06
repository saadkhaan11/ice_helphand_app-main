class UserInRange{
  String? uid;
  double? distance;
  UserInRange({this.uid,this.distance});

  factory UserInRange.fromMap(Map<String, dynamic> map) {
    return UserInRange(
      uid: map['uid'],
      distance: map['distance'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'distance': distance,
    };
  }
}