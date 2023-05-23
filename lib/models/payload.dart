class Payload {
  String? type;
  String? isNotification;

  Payload({this.type, this.isNotification});

  Payload.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    isNotification = json['isNotification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['isNotification'] = isNotification;
    return data;
  }
}
