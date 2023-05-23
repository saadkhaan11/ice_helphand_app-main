import 'package:geolocator/geolocator.dart';

class MyStaticVariables {
  static Position? _currentPosition;

  static Position? getMyStaticVariable() {
    return _currentPosition;
  }

  static void setMyStaticVariable(Position? value) {
    _currentPosition = value;
  }
}
