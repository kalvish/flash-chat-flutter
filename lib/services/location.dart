import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Location();

  Future<Location> geoLocation() async {
    Location locationToSend = new Location();
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//      print(position);
      locationToSend.latitude = position.latitude;
      locationToSend.longitude = position.longitude;
    } on Exception catch (e) {
      print(e);
    }
    return locationToSend;
  }
}
