import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:challengesanadtech/ui/responsive_safe_area.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../core/injection/injection_container.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../core/mobx/mobx_point.dart';
import '../core/util/app_utils.dart';
import 'dart:typed_data';
import 'dart:async';


class MapOffline extends StatelessWidget {

  final Uint8List uint8list;
  MapOffline(this.uint8list);

  static String kGoogleApiKey = "AIzaSyA2v62ZDMh39bY5Wg1FYxOLE4LNeDJCOHU";
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  AppDatabase database;
  GoogleMapController _mapController;
  final Mode _mode = Mode.overlay;
  MobxPoint _mobx = MobxPoint();
  double _zoom = 14.0;

  CameraPosition _initialCamera([EntityPoint entityPoint]) => CameraPosition(
    target: LatLng(
      entityPoint != null ? entityPoint.latitude : 35.586805,
      entityPoint != null ? entityPoint.longitude : -5.361377,
    ), zoom: entityPoint != null ? 13 : _zoom,
  );

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  _deleteDialog(BuildContext context, EntityPoint point) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Are you sure you want to delete this point?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            try {
              sl<AppUtils>().deletePoint(point);
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
    database = Provider.of<AppDatabase>(context);
    return ResponsiveSafeArea(
      builder: (context) => Scaffold(
        key: scaffoldState,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<DataConnectionStatus>(
                stream: DataConnectionChecker().onStatusChange,
                builder: (context, snapshotConn) {
                  switch(snapshotConn.data) {
                    case DataConnectionStatus.connected:
                      print('Data connection is available.');
                      return Container();
                    case DataConnectionStatus.disconnected:
                      print('You are disconnected from the internet.');
                      return Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: Colors.red,
                        child: Text('Offline mode',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                        ),),
                      );
                    default:
                      return Container();
                  }
                }
            ),
            StreamBuilder<List<EntityPoint>>(
              stream: database.entityPointsDao.watchAllEntityPoint(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting: return Center(
                    child: CircularProgressIndicator(),
                  );
                  default:
                    if (snapshot.data.isNotEmpty) {
                      addAllMarker(context, snapshot.data);
                      addAllPolygon(context, snapshot.data);
                    }
                    return Expanded(
                      child: Stack(
                        children: <Widget>[
                          Observer(
                            builder: (_) => GoogleMap(
                              initialCameraPosition: _initialCamera(
                                snapshot.data.isNotEmpty ?
                                snapshot.data.first : null,
                              ),
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
                                final entity = EntityPoint(
                                  id: sl<AppUtils>().CreateCryptoRandomString(),
                                  info: 'DOMICILE',
                                  latitude: location.latitude,
                                  longitude: location.longitude,
                                );
                                await sl<AppUtils>().insertPoint(entity);

                                _mobx.setPosition(location);

                                ///_mobx.latLngs.add(location);

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
                                  onPressed: () async {
                                    await sl<AppUtils>().deleteAllPoint();
                                    _mobx.entitys.clear();
                                    _mobx.markers.clear();
                                    _mobx.polygon.clear();
                                  }
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: FloatingActionButton(
                                elevation: 2,
                                backgroundColor: Colors.pink,
                                child: Icon(MdiIcons.fromString('map-marker-path')),
                                heroTag: null,
                                onPressed: () {
                                  String id = sl<AppUtils>().CreateCryptoRandomString();
                                  _mobx.polyline.addAll(getPolyline(id));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                }
              },
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

  getPolyline(String id) {
    _mobx.polygon.clear();
    try {
      List<LatLng> points = <LatLng>[];
      for (EntityPoint point in _mobx.entitys) {
        points.add(LatLng(point.latitude, point.longitude));
      }
      _mobx.polygon.add(Polygon(
        polygonId: PolygonId(id),
        strokeColor: Colors.pink[100],
        fillColor: Colors.pink[100],
        onTap: () {
          print(id);
        },
        points: points,
      ));
    } catch(e) {
      print("error, $e");
      showSnackBar(e.toString());
    }
  }

  void addAllMarker(BuildContext context, List<EntityPoint> entitys) {
    _mobx.markers.clear();
    for (EntityPoint point in entitys) {
      final marker = Marker(
        markerId: MarkerId(point.id),
        infoWindow: InfoWindow(title: point.info),
        onTap: () async {
          await _deleteDialog(context, point);
        },
        position: LatLng(point.latitude, point.longitude),
        //icon: BitmapDescriptor.fromBytes(icon),
      );
      _mobx.markers.add(marker);
    }
  }

  void addAllPolygon(BuildContext context, List<EntityPoint> entitys) {
    _mobx.polygon.clear();
    try {
      List<LatLng> points = <LatLng>[];
      for (EntityPoint point in entitys) {
        points.add(LatLng(point.latitude, point.longitude));
      }
      _mobx.polygon.add(Polygon(
        polygonId: PolygonId(entitys.first.id),
        strokeColor: Colors.pink[100],
        fillColor: Colors.pink[100],
        onTap: () {
          print(entitys.first.id);
        },
        points: points,
      ));
    } catch(e) {
      print("error, $e");
      showSnackBar(e.toString());
    }
  }
}
