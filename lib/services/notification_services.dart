import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ice_helphand/models/notification.dart';

class NotificationService {
  Future<bool> createNotification(MyNotification notification) async {
    try {
      // print(order.billing!.firstName);
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      // var fbody = notification.toJson();
      // print(fbody);
      final body = jsonEncode(notification.toJson());
      // print(body);
      final response = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key =AAAADjAHKFQ:APA91bFm3gV7Gxph3VOYUu5NYy1TFqII7IRbdZluKTew6JBFzRJpokfKH4uTcnuFU8L5RvyEB_MN03-j4eX522z0vGRSa_c238zXAWtCq0Tpq_Z3UZPm_e78TnIvpxVmk0XLuvEdgPq-"
      });

      if (response.statusCode == 201) {
        print('done');
        return true;
      }
      print(response.body);
    } catch (e) {
      print(e);
    }
    return false;
  }
}
