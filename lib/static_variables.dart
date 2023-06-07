import 'package:geolocator/geolocator.dart';

class MyStaticVariables {

  static Position? position;
  static Position? _currentPosition;
  static bool? _hasPermission;

  static Position? getCurrentPosition() {
    print('currentPosition yay ha${_currentPosition}');
    return _currentPosition;
  }

  static void setCurrentPosition(Position? value) {
    _currentPosition = value;
    // print('currentpositioncalled${_currentPosition}');
  }
  static bool? getHasPermission() {
    return _hasPermission;
  }

  static void setHasPermission(bool? value) {
    _hasPermission = value;
  }
}
