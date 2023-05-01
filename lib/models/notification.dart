import 'notification_body.dart';
class MyNotification {
  String? to;
  NotificationBody? notification;

  MyNotification({this.to, this.notification});

  MyNotification.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    notification = json['notification'] != null
        ? NotificationBody.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['to'] = to;
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    return data;
  }
}
