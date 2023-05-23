import 'package:ice_helphand/models/payload.dart';

import 'notification_body.dart';

class MyNotification {
  String? to;
  NotificationBody? notification;
  Payload? payload;

  MyNotification({this.to, this.notification, this.payload});

  // MyNotification.fromJson(Map<String, dynamic> json) {
  //   to = json['to'];
  //   notification = json['notification'] != null
  //       ? NotificationBody.fromJson(json['notification'])
  //       : null;

  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['to'] = to;
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    return data;
  }
}
