class NotificationBody {
  String? body;
  String? title;

  NotificationBody({this.body, this.title});

  NotificationBody.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['body'] = body;
    data['title'] = title;
    return data;
  }
}