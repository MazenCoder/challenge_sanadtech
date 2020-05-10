import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:challengesanadtech/ui/responsive_safe_area.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../core/injection/injection_container.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../core/model/point_model.dart';
import 'package:flutter/material.dart';
import '../core/mobx/mobx_point.dart';
import '../core/util/app_utils.dart';
import 'dart:typed_data';
import 'dart:async';


class MapDraw extends StatelessWidget {

  final Uint8List uint8list;
  MapDraw(this.uint8list);

  static String kGoogleApiKey = "AIzaSyA2v62ZDMh39bY5Wg1FYxOLE4LNeDJCOHU";
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;
  final Mode _mode = Mode.overlay;
  MobxPoint _mobx = MobxPoint();
  bool _isUpdate = false;
  String _idMarker = '';
  double _zoom = 14.0;


  CameraPosition _initialCamera() => CameraPosition(
    target: LatLng(35.586805, -5.361377), zoom: _zoom,
  );

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  _deleteDialog(BuildContext context, String markerId, String pointId) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Are you sure you want to delete this point?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            try {
              print('markerIndex: $markerId, pointIndex: $pointId');
              //_mobx.markers.removeAt(markerIndex);
              _mobx.markers.removeWhere((item) => item.markerId.value == markerId);
              //_mobx.pointModel.removeAt(pointIndex);
              _mobx.pointModel.removeWhere((item) => item.id == pointId);
              Navigator.pop(context);
            } catch(e) {
              Navigator.pop(context);
              showSnackBar(e.toString());
              print('error, $e');
            }
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (context) => Scaffold(
          key: scaffoldState,
          body: Stack(
            children: <Widget>[
              Observer(
                builder: (_) => GoogleMap(
                  initialCameraPosition: _initialCamera(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    if(!_controller.isCompleted) {
                      _controller.complete(controller);
                      _mapController = controller;
                    }
                  },
                  onCameraMove:(CameraPosition cameraPosition) {
                    _zoom = cameraPosition.zoom;
                  },
                  onTap: (location) async {
                    /// Draw polygons
                    /// await sl<AppUtils>().checkLine(location, _mobx.pointModel)
                    if (!_mobx.isSelected) {
                      final point = PointModel(
                        id: sl<AppUtils>().CreateCryptoRandomString(),
                        info: 'DOMICILE',
                        latitude: location.latitude,
                        longitude: location.longitude,
                      );
                      if (_mobx.pointModel.isEmpty || _mobx.pointModel.length < 3) {
                        _mobx.pointModel.add(point);
                        _addMarker(context, point, uint8list);
                        _mobx.setPosition(location);
                      } else {
                        _mobx.pointModel.add(point);
                        _addMarker(context, point, uint8list);
                        _mobx.setPosition(location);
                      }

                      if (_mobx.markers.length > 1) {
                        String id = sl<AppUtils>().CreateCryptoRandomString();
                        _mobx.polyline.addAll(getPolyline(id));
                      }
                      ///_mobx.latLngs.add(location);

                      _mapController.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(_mobx.latitude, _mobx.longitude),
                          zoom: _zoom,
                        ),
                      ),).catchError((e) => showSnackBar(e.toString()));

                    } else {
                      if (sl<AppUtils>().checkPointOverlapping(location, _mobx.pointModel)) {

                        final point = PointModel(
                          id: sl<AppUtils>().CreateCryptoRandomString(),
                          info: 'DOMICILE',
                          latitude: location.latitude,
                          longitude: location.longitude,
                        );
                        _mobx.pointModel.add(point);
                        _addMarker(context, point, uint8list);
                        _mobx.setPosition(location);
                      } else {
                        _warningDialog(context);
                      }
                    }
                  },
                  markers: _mobx.markers.toSet(),
                  polylines: _mobx.polyline != null ? _mobx.polyline.toSet() : null,
                  polygons: _mobx.polygon != null ? _mobx.polygon.toSet() : null,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 80),
                  child: FloatingActionButton(
                    elevation: 2,
                    child: Icon(Icons.search),
                    heroTag: null,
                    onPressed: () => _handlePressButton(context),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                      elevation: 2,
                      child: Icon(Icons.clear),
                      heroTag: null,
                      onPressed: () {
                        _mobx.polyline.clear();
                        _mobx.pointModel.clear();
                        _mobx.markers.clear();
                        _mobx.latLngs.clear();
                        _mobx.polygon.clear();
                      }
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Observer(
                    builder: (_) => FloatingActionButton(
                      elevation: 2,
                      backgroundColor: !_mobx.isSelected ? Colors.pink : Colors.grey,
                      child: !_mobx.isSelected ?
                      Icon(MdiIcons.fromString('map-marker-distance')) :
                      Icon(Icons.linear_scale),
                      heroTag: null,
                      onPressed: !_mobx.isSelected ? () {
                        _mobx.onSelect(true);
                        final first = _mobx.pointModel.first;

                        final point1 = PointModel(
                          id: sl<AppUtils>().CreateCryptoRandomString(),
                          info: 'DOMICILE',
                          latitude: first.latitude,
                          longitude: first.longitude,
                        );
                        _mobx.pointModel.add(point1);

                        String id = sl<AppUtils>().CreateCryptoRandomString();
                        _mobx.polyline.addAll(getPolyline(id));
                        _mobx.markers.clear();
                        drawPolygon();
                        _mobx.polyline.clear();
                        //_mobx.pointModel.clear();
                        _mobx.markers.clear();
                        _mobx.latLngs.clear();
                      } : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Future<void> _handlePressButton(BuildContext context) async {
    try {
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: "ma",
        components: [Component(Component.country, "ma")],
      );

      displayPrediction(p, searchScaffoldKey.currentState);
    } catch(_) {}
  }

  void onError(PlacesAutocompleteResponse response) {
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    try {
      if (p != null) {
        PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
        _mobx.latitude = detail.result.geometry.location.lat;
        _mobx.longitude = detail.result.geometry.location.lng;

        _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_mobx.latitude, _mobx.longitude),
            zoom: _zoom,
          ),
        ),).catchError((e) => debugPrint('error, Geolocator: $e'));
        print("description${p.description} - ${_mobx..latitude}/${_mobx.longitude}");
      }
    } catch(_) {}
  }


  void _addMarker(BuildContext context, PointModel pointModel, var icon) {
    final marker = Marker(
      markerId: MarkerId(pointModel.id),
      infoWindow: InfoWindow(title: pointModel.info),
      onTap: () async {
        await _optionDialog(context, pointModel.id, pointModel.id, pointModel.info);
        //await _deleteDialog(context, pointModel.id, pointModel.id);
      },
      position: LatLng(pointModel.latitude, pointModel.longitude),
      //icon: BitmapDescriptor.fromBytes(icon),
    );
    _mobx.markers.add(marker);
  }

  Set<Polyline> getPolyline(String id) {
    _mobx.polyline.clear();
    final Set<Polyline> _polyline = {};
    try {
      List<LatLng> points = <LatLng>[];

      for (PointModel point in _mobx.pointModel) {
        points.add(LatLng(point.latitude, point.longitude));
      }

      _polyline.add(Polyline(
          onTap: () async {
            //  await _showDialog(id);
            print('...............');
          },
          polylineId: PolylineId(id),
          points: points,
          width: 5,
          color: Colors.pink[300]
      ));
      return _polyline;
    } catch(e) {
      print("error, $e");
      return _polyline;
    }
  }

  void drawPolygon() {
    List<LatLng> points = [];

    for (PointModel point in _mobx.pointModel) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    String id = sl<AppUtils>().CreateCryptoRandomString();
    _mobx.polygon.add(Polygon(
      polygonId: PolygonId(id),
      strokeColor: Colors.pink[100],
      fillColor: Colors.pink[100],
      onTap: () {
        print(id);
      },
      points: points,
    ));
  }

  _optionDialog(BuildContext context, String markerId, String pointId, String text) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Address is: $text'),
      actions: <Widget>[
        FlatButton(
          child: Text('Delete this point'),
          onPressed: () {
            try {
              _mobx.markers.removeWhere((item) => item.markerId.value == markerId);
              _mobx.pointModel.removeWhere((item) => item.id == markerId);
              //_mobx.pointModel.removeAt(pointIndex);
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
              final marker = _mobx.markers.toList().firstWhere((item) => item.markerId.value == markerId);
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
      _removeMarker();
    });
  }

  _warningDialog(BuildContext context) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Oops! this point outside polygons'),
      actions: <Widget>[
        FlatButton(
          child: Text('Try again'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ));
  }

  updateMarker(var marker) {

    var position = marker.position;
    var infoWindow = marker.infoWindow;
    var markerId = marker.markerId;
    _idMarker = marker.markerId.value;

    _mobx.markers.removeWhere((item) => item.markerId.value == _idMarker);

    Marker _marker = Marker(
      markerId: markerId,
      onTap: () {
        print("tapped");
      },
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: infoWindow,
    );

    _mobx.markers.add(_marker);
    _isUpdate = true;
  }

  _removeMarker() async {
    await Future.delayed(Duration(seconds: 1)).then((value) => {
    _mobx.removePoint(_idMarker)
      //_mobx.markers.removeWhere((item) => item.markerId.value == _idMarker)
    });
  }
}

