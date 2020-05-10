import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:challengesanadtech/core/injection/injection_container.dart';
import 'package:challengesanadtech/core/ui/responsive_safe_area.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:challengesanadtech/core/mobx/mobx_point.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:challengesanadtech/core/util/app_utils.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';


//!.......... TODO MAZEN SHALAN THIS IS IMPORTANT ..........


class DrawPolygons extends StatelessWidget {

  final Uint8List uint8list;
  final currentPosition;
  DrawPolygons(this.uint8list, this.currentPosition);

  static String googleAPIKey = 'AIzaSyDolo1Le0868irzhrgQ6B4xqW7IzaV3x08';
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);
  TextEditingController sourceController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;
  MobxPoint _mobx = MobxPoint();
  String _idUpdateMarker;
  bool _isUpdate = false;
  double _zoom = 14.0;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
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
            Expanded(
              child: FutureBuilder<EntityConfig>(
                future: db.entityConfigsDao.getEntityConfig(),
                builder: (context, snapConfig) {
                  switch(snapConfig.connectionState) {
                    case ConnectionState.waiting: return Center(
                      child: CircularProgressIndicator(),
                    );
                    default:
                      _mobx.config(snapConfig.data);
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: StreamBuilder<List<EntityPoint>>(
                          stream: db.entityPointsDao.watchAllEntityPoint(),
                          builder: (context, snapshot) {
                            switch(snapshot.connectionState) {
                              case ConnectionState.waiting: return Center(
                                child: CircularProgressIndicator(),
                              );
                              default:
                                if (snapshot.data.isNotEmpty) {
                                  addAllMarker(context, snapshot.data);
                                  addAllPolygon(context, snapshot.data);
                                  addAllPolyline(context, snapshot.data);
                                }
                                return Stack(
                                  children: <Widget>[
                                    Observer(
                                      builder: (_) => GoogleMap(
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
                                        onTap: (LatLng location) async {
                                          var text = await sl<AppUtils>().getPlacemark(location);

                                          if (_mobx.configPolyline) {
                                            await sl<AppUtils>().insertConfig(
                                              EntityConfig(
                                                idEntityConfig: 0003,
                                                zoom: _zoom,
                                                latitude: location.latitude,
                                                longitude: location.longitude,
                                                polyline: true,
                                              ),
                                            );
                                            /// DRAW POLY

                                            if (_isUpdate) {
                                              print('......1.......');
                                              _isUpdate= false;
                                              final entity = EntityPoint(
                                                id: _idUpdateMarker,
                                                info: '$text',
                                                inside: false,
                                                updatePoint: false,
                                                latitude: location.latitude,
                                                longitude: location.longitude,
                                              );

                                              await db.entityPointsDao.updateEntityPoint(entity);

                                            } else {
                                              final entity = EntityPoint(
                                                id: sl<AppUtils>().CreateCryptoRandomString(),
                                                info: '$text',
                                                inside: false,
                                                latitude: location.latitude,
                                                longitude: location.longitude,
                                              );

                                              await sl<AppUtils>().insertPoint(entity);
                                            }
                                          } else { ///! point inside
                                            if (sl<AppUtils>().checkPointOverlapping(location, snapshot.data)) {
                                              await sl<AppUtils>().insertConfig(
                                                EntityConfig(
                                                  idEntityConfig: 0003,
                                                  zoom: _zoom,
                                                  latitude: location.latitude,
                                                  longitude: location.longitude,
                                                  polyline: false,
                                                ),
                                              );

                                              if (_isUpdate) {
                                                _isUpdate = false;
                                                /// DRAW POLY
                                                final entity = EntityPoint(
                                                  id: _idUpdateMarker,
                                                  info: '$text',
                                                  inside: true,
                                                  latitude: location.latitude,
                                                  longitude: location.longitude,
                                                  updatePoint: false,
                                                );

                                                await db.entityPointsDao.updateEntityPoint(entity);
                                              } else {
                                                /// DRAW POLY
                                                final entity = EntityPoint(
                                                  id: sl<AppUtils>().CreateCryptoRandomString(),
                                                  info: '$text',
                                                  inside: true,
                                                  updatePoint: false,
                                                  latitude: location.latitude,
                                                  longitude: location.longitude,
                                                );

                                                await sl<AppUtils>().insertPoint(entity);
                                              }
                                            } else {
                                              _warningDialog(context);
                                            }
                                          }

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
                                        polylines: _mobx.polyline != null ? _mobx.polyline.toSet() : null,
                                        polygons: _mobx.polygon != null ? _mobx.polygon.toSet() : null,
                                        initialCameraPosition: CameraPosition(
                                          target: sl<AppUtils>().getlatLng(currentPosition, snapConfig.data),
                                          zoom: snapConfig.data != null ? snapConfig.data.zoom : _zoom,
                                        ),
                                        mapType: MapType.normal,
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
                                              _mobx.onSelectPolyline(true);
                                              _mobx.onSelectPolygon(false);
                                              await sl<AppUtils>().deleteAllPoint();
                                              await sl<AppUtils>().deleteConfig();
                                              _mobx.entitys.clear();
                                              _mobx.markers.clear();
                                              _mobx.polygon.clear();
                                              _mobx.polyline.clear();
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
                                            backgroundColor: _mobx.configPolyline ? Colors.pink : Colors.grey,
                                            child: _mobx.configPolyline ?
                                            Icon(MdiIcons.fromString('map-marker-distance')) :
                                            Icon(Icons.linear_scale),
                                            heroTag: null,
                                            onPressed: _mobx.configPolyline ? () async {
                                              if (snapshot.data.length > 2) {
                                                _mobx.onSelectPolygon(true);
                                                await db.updateConfigPolyline(false);
                                                await db.updateConfigPolygon(true);

                                                final first = snapshot.data.first;
                                                await sl<AppUtils>().insertConfig(
                                                  EntityConfig(
                                                    idEntityConfig: 0003,
                                                    zoom: _zoom,
                                                    latitude: _mobx.latitude,
                                                    longitude: _mobx.longitude,
                                                    polyline: false,
                                                    polygon: true,
                                                  ),
                                                );

                                                var text = await sl<AppUtils>().getPlacemark(LatLng(first.latitude,first.longitude));
                                                final entity = EntityPoint(
                                                  id: sl<AppUtils>().CreateCryptoRandomString(),
                                                  info: '$text',
                                                  latitude: first.latitude,
                                                  longitude: first.longitude,
                                                );

                                                await sl<AppUtils>().insertPoint(entity);
                                                addAllPolygon(context, snapshot.data);
                                                refreshPolygon(context, snapshot.data);
                                              } else {
                                                showSnackBar('Markers should be more than two', 2200);
                                              }
                                            } : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                            }
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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

  void showSnackBar(String content, [int duration = 1500]) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: duration),
    ));
  }

  _optionDialog(BuildContext context, String markerId, String text) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Address is: $text'),
      actions: <Widget>[
        FlatButton(
          child: Text('Delete this point'),
          onPressed: () async {
            try {
              await sl<AppUtils>().deleteEntityPoint(markerId);
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
    ));
  }

  void addAllMarker(BuildContext context, List<EntityPoint> entitys) {
    _mobx.markers.clear();
    if (_mobx.configPolyline) {
      for (EntityPoint point in entitys) {

        final marker = Marker(
          markerId: MarkerId(point.id),
          infoWindow: InfoWindow(title: point.info),
          onTap: () async {
            await _optionDialog(context, point.id, point.info);
          },
          position: LatLng(point.latitude, point.longitude),
          icon: point.updatePoint ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet) : null,
        );
        _mobx.markers.add(marker);
      }
    } else {
      for (EntityPoint point in entitys) {
        if (point.inside) {
          final marker = Marker(
            markerId: MarkerId(point.id),
            infoWindow: InfoWindow(title: point.info),
            onTap: () async {
              await _optionDialog(context, point.id, point.info);
            },
            position: LatLng(point.latitude, point.longitude),
            icon: point.updatePoint ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet) : null,
          );
          _mobx.markers.add(marker);
        }
      }
    }
  }

  void addAllPolygon(BuildContext context, List<EntityPoint> entitys) {
    if (_mobx.configPolyline) {
      if(sl<AppUtils>().checkPolygon(entitys, _mobx.configPolygon)) {
        _mobx.polyline.clear();
        _mobx.markers.clear();
        //! ADD POLYGON
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
            onTap: () {},
            points: points,
          ));
        } catch(e) {
          print("error, $e");
          showSnackBar(e.toString());
        }
      } else _mobx.polygon.clear();
    } else {
      _mobx.polygon.clear();
      List<LatLng> points = <LatLng>[];
      for (EntityPoint point in entitys) {
        if (!point.inside) {
          points.add(LatLng(point.latitude, point.longitude));
        }
      }
      _mobx.polygon.add(Polygon(
        polygonId: PolygonId(entitys.first.id),
        strokeColor: Colors.pink[100],
        fillColor: Colors.pink[100],
        onTap: () {},
        points: points,
      ));
    }
  }

  refreshPolygon(BuildContext context, List<EntityPoint> entitys) async {
    await Future.delayed(Duration(seconds: 1))
      .then((value) => addAllPolygon(context, entitys));
    _mobx.onSelectPolyline(false);
    addAllPolygon(context, entitys);
  }

  void addAllPolyline(BuildContext context, List<EntityPoint> data) {
    if(sl<AppUtils>().checkPolyline(data, _mobx.configPolyline)) {
      _mobx.polyline.clear();
      String id = sl<AppUtils>().CreateCryptoRandomString();
      try {
        List<LatLng> points = <LatLng>[];

        for (EntityPoint point in data) {
          points.add(LatLng(point.latitude, point.longitude));
        }

        _mobx.polyline.add(Polyline(
            polylineId: PolylineId(id),
            points: points,
            width: 5,
            color: Colors.pink[200]
        ));
      } catch(e) {
        print("error, $e");
      }
    }// else _mobx.polyline.clear();
  }

  void updateMarker(Marker marker) async {
    _idUpdateMarker = marker.markerId.value;
    await sl<AppUtils>().updatePoint(true, _idUpdateMarker);
    _isUpdate = true;
  }

}


