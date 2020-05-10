import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:challengesanadtech/pages/locationpath.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';



class AppState extends ChangeNotifier {

  TextEditingController sourceController=TextEditingController();
  TextEditingController destController=TextEditingController();
  GoogleMapController get mapController => _mapController;
  LatLng get initialPosition => _initialPosition;
  LatLng get lastposition => _lastPosition;
  bool get isLoading => _isLoading;
  Set get polyLines => _polyLines;
  Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  static LatLng _initialPosition;
  static LatLng _lastPosition;
  Set<Marker> _markers = {};
  Set get markers => _markers;
  bool _isLoading=false;

  Locationpath _locationPath = Locationpath();
  AppState() {
    _getUserLocation();
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }


  void _getUserLocation() async {
    Position position = await Geolocator()
       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);

    sourceController.text = placemark[0].name;
    _markers.add(Marker(markerId: MarkerId(position.toString()),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),position: LatLng(position.latitude, position.longitude)));
    notifyListeners();
  }

  void sendRequest(double latitude, double longitude, String intendedLocation) async {
    _isLoading = true;
    //List placemark = await Geolocator().placemarkFromAddress(intendedLocation);
    //double latitude = placemark[0].position.latitude;
    //double longitude = placemark[0].position.longitude;

    _polyLines.clear();
    _markers.clear();

    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _locationPath.getRouteCoordinates(
      _initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Destination"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.pink));
    _isLoading = false;
    notifyListeners();
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = [];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    print(lList.toString());
    return lList;
  }
}
