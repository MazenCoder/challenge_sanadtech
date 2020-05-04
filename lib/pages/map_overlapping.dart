import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:challengesanadtech/ui/responsive_safe_area.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../core/injection/injection_container.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import '../core/model/point_model.dart';
import '../core/util/image_helper.dart';
import '../core/mobx/mobx_point.dart';
import '../core/util/app_utils.dart';
import 'dart:typed_data';
import 'dart:async';

class MapOverlapping extends StatelessWidget {

  final Uint8List uint8list;
  MapOverlapping(this.uint8list);

  static String kGoogleApiKey = "----------------------------------------";
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;
  final Mode _mode = Mode.overlay;
  MobxPoint _mobx = MobxPoint();
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

  @override
  Widget build(BuildContext context) {

    List<LatLng> points = [
      LatLng(35.59229568751948, -5.36549661308527),
      LatLng(35.5935751745398, -5.358715653419495),
      LatLng(35.586362559179236, -5.354996100068092),
      LatLng(35.58305840051349, -5.365753434598446),
      LatLng(35.58678109075662, -5.368871837854385),
    ];
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
                  onTap: (location) {
                    _mobx.markers.clear();
                    if (sl<AppUtils>().checkPoint(location)) {
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

                    _mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(_mobx.latitude, _mobx.longitude),
                        zoom: _zoom,
                      ),
                    ),).catchError((e) => showSnackBar(e.toString()));
                  },
                  markers: _mobx.markers.toSet(),
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
                      }
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
        //await _deleteDialog(context, pointModel.id, pointModel.id);
      },
      position: LatLng(pointModel.latitude, pointModel.longitude),
      icon: BitmapDescriptor.fromBytes(icon),
    );
    _mobx.markers.add(marker);
  }
}