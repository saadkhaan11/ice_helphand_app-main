import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationServices {
  Future<void> getDirections(String? origin, String? destination) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=AIzaSyDob_RnPNMFGROE0PhzuT3oVGCi8WhW8gw";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    print(json);
    print("response${response}");
  }
}
