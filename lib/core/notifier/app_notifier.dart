import 'package:challengesanadtech/core/injection/injection_container.dart';
import 'package:challengesanadtech/core/model/point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:challengesanadtech/core/util/app_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import '../../pages/locationpath.dart';


class AppNotifier extends ChangeNotifier {

  GoogleMapController get mapController => _mapController;
  LatLng get initialPosition => _initialPosition;
  Locationpath _locationPath = Locationpath();
  LatLng get lastposition => _lastPosition;
  GoogleMapController _mapController;
  bool get isLoading => _isLoading;
  bool get isSelected => _isSelected;


  Set get polygon => _polygon;
  Set<Polygon> _polygon = {};

  Set get polyLines => _polyLines;
  Set<Polyline> _polyLines = {};

  List<PointModel> _pointModel = [];
  List<PointModel> get pointModel => _pointModel;

  //List<Polygon> _polygon = [];
  //List<Marker> _marker = [];

  //List<Marker> get marker => _marker;
  //List<Polygon> get polygon => _polygon;

  String get address => _address;
  bool get isUpdate => _isUpdate;

  bool get isRoute => _isRoute;
  static LatLng _initialPosition;

  LatLng get  pointPosition => _pointPosition;
  LatLng _pointPosition;
  static LatLng _lastPosition;

  Set get markers => _markers;
  Set<Marker> _markers = {};

  bool _isLoading = false;
  bool _isUpdate = false;
  bool _isSelected = false;
  bool _isRoute = false;
  String _idMarker = '';
  String _address = '';

  AppNotifier() {
    _getUserLocation();
  }

  _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);

    _address = '${placemark[0].name}';
    notifyListeners();
  }


  addMarkers(BuildContext context, var location) async {
    String text = await sl<AppUtils>().getPlacemark(location);
    String id = sl<AppUtils>().CreateCryptoRandomString();
    if (_isUpdate) {
      _isUpdate = false;
      _markers.add(Marker(
        markerId: MarkerId(id),
        infoWindow: InfoWindow(title: text),
        onTap: () async {

          await _optionDialog(context, id, text);
          //await _deleteDialog(context, id, text);
        },
        position: LatLng(location.latitude, location.longitude),
        icon: _markers.length == 0 ?
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : null,
        //icon: BitmapDescriptor.fromBytes(icon),
      ));

      if (_isRoute && _markers.length > 1) {
        sendRequest();
      } else {
        _isRoute = false;
      }
    } else {
      _markers.add(Marker(
        markerId: MarkerId(id),
        infoWindow: InfoWindow(title: text),
        onTap: () async {
          await _optionDialog(context, id, text);
          //await _deleteDialog(context, id, text);
        },
        position: LatLng(location.latitude, location.longitude),
        icon: _markers.length == 0 ?
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : null,
        //icon: BitmapDescriptor.fromBytes(icon),
      ));
    }

    notifyListeners();
  }

  _optionDialog(BuildContext context, String markerId, String text) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Address is: $text'),
      actions: <Widget>[
        FlatButton(
          child: Text('Delete this point'),
          onPressed: () {
            try {
              _markers.removeWhere((item) => item.markerId.value == markerId);
              _polyLines.removeWhere((item) => item.polylineId.value == _lastPosition.toString());
              Navigator.pop(context);
            } catch(e) {
              Navigator.pop(context);
              print('error, $e');
            }
          },
        ),

        FlatButton(
          child: Text('Updage this point'),
          onPressed: () {
            final marker = _markers.toList().firstWhere((item) => item.markerId.value == markerId);
            updateMarker(marker);
            Navigator.pop(context);
          }
        ),

        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    )).whenComplete(() {
      notifyListeners();
      _removeMarker();
    });
  }

  _deleteDialog(BuildContext context, String markerId, String text) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Are you sure you want to delete this point $text?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            try {
              _markers.removeWhere((item) => item.markerId.value == markerId);
              _polyLines.removeWhere((item) => item.polylineId.value == _lastPosition.toString());
              Navigator.pop(context);
            } catch(e) {
              Navigator.pop(context);
              print('error, $e');
            }
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    )).whenComplete(() {
      notifyListeners();
    });
  }

  Future<void> sendRequest() async {
    _isLoading = true;
    List<LatLng> list = [];
    for (var point in _markers) {
      list.add(LatLng(point.position.latitude, point.position.longitude));
    }

    if (list.length > 1) {
      String route = await _locationPath.getRouteCoordinates(list[0], list[1]);
      _isRoute = true;
      createRoute(route);
      notifyListeners();
    }
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

  void clearApp() {
    _markers.clear();
    _polyLines.clear();
    _pointModel.clear();
    _polygon.clear();
    notifyListeners();
  }


  updateMarker(var marker) {

    var position = marker.position;
    var infoWindow = marker.infoWindow;
    var markerId = marker.markerId;
    _idMarker = marker.markerId.value;

    _markers.removeWhere((item) => item.markerId.value == _idMarker);

    Marker _marker = Marker(
      markerId: markerId,
      onTap: () {
        print("tapped");
      },
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: infoWindow,
    );

    _markers.add(_marker);
    _isUpdate = true;

    notifyListeners();
  }

  _removeMarker() async {
    await Future.delayed(Duration(seconds: 1)).then((value) => {
    _markers.removeWhere((item) => item.markerId.value == _idMarker)
    });
  }

  addPointAndMarker(var location) async {
    String id = sl<AppUtils>().CreateCryptoRandomString();
    String text = await sl<AppUtils>().getPlacemark(location);
    final point = PointModel(
      id: id,
      info: '$text',
      latitude: location.latitude,
      longitude: location.longitude,
    );
    _pointModel.add(point);
    final marker = Marker(
      markerId: MarkerId(point.id),
      infoWindow: InfoWindow(title: point.info),
      onTap: () async {
        //await _optionDialog(context, point.id, point.id, point.info);
        //await _deleteDialog(context, pointModel.id, pointModel.id);
      },
      position: LatLng(point.latitude, point.longitude),
    );
    _markers.add(marker);
    notifyListeners();
  }

  setPosition(var position) {
    _pointPosition = position;
    notifyListeners();
  }

  void drawPolyline() {
    _polyLines.clear();
    String id = sl<AppUtils>().CreateCryptoRandomString();
    try {
      List<LatLng> points = <LatLng>[];
      for (PointModel point in _pointModel) {
        points.add(LatLng(point.latitude, point.longitude));
      }

      _polyLines.add(Polyline(
          onTap: () async {
            //  await _showDialog(id);
            print('...............');
          },
          polylineId: PolylineId(id),
          points: points,
          width: 5,
          color: Colors.pink[200]
      ));
    } catch(e) {
      print("error, $e");
    }
    notifyListeners();
    refresh();
  }

  void drawPolygon() {
    List<LatLng> points = [];

    for (PointModel point in _pointModel) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    String id = sl<AppUtils>().CreateCryptoRandomString();
    _polygon.add(Polygon(
      polygonId: PolygonId(id),
      strokeColor: Colors.pink[100],
      fillColor: Colors.pink[100],
      onTap: () {
        print(id);
      },
      points: points,
    ));
    notifyListeners();
    refresh();
  }

  refresh() async {
    await Future.delayed(Duration(seconds: 1)).then((value) => {
      drawPolyline(),
      notifyListeners(),
    });
  }

  onSelect(bool val) {
    _isSelected = val;
    notifyListeners();
  }

  addOnePoint() {
    final first = _pointModel.first;

    final point1 = PointModel(
      id: sl<AppUtils>().CreateCryptoRandomString(),
      info: 'DOMICILE',
      latitude: first.latitude,
      longitude: first.longitude,
    );
    _pointModel.add(point1);
    notifyListeners();
  }

  clean() {
    _markers.clear();
    _polyLines.clear();
    notifyListeners();
  }
}