import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:challengesanadtech/ui/responsive_safe_area.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../core/injection/injection_container.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import '../core/model/point_model.dart';
import '../core/mobx/mobx_point.dart';
import '../core/util/app_utils.dart';
import 'dart:typed_data';
import 'dart:async';


class MapOverlapping extends StatelessWidget {

  final Uint8List uint8list;
  MapOverlapping(this.uint8list);

  static String kGoogleApiKey = "AIzaSyA2v62ZDMh39bY5Wg1FYxOLE4LNeDJCOHU";
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;
  final Mode _mode = Mode.overlay;
  MobxPoint _mobx = MobxPoint();
  double _zoom = 14.0;

  CameraPosition _initialCamera() => CameraPosition(
    target: LatLng(35.58072,-5.35538), zoom: _zoom,
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
      LatLng(35.581197, -5.369731), LatLng(35.59007, -5.374169), LatLng(35.595885, -5.366698), LatLng(35.58846, -5.35703)
    ];
    List<LatLng> points2 = [
      LatLng(35.5829,-5.35481
      ),
      LatLng(35.58299,-5.3547
      ),
      LatLng(35.58325,-5.35449
      ),
      LatLng(35.58357,-5.35404
      ),
      LatLng(35.58359,-5.35401
      ),
      LatLng(35.58364,-5.35395
      ),
      LatLng(35.58372,-5.35382
      ),
      LatLng(35.58392,-5.35354
      ),
      LatLng(35.58412,-5.35324
      ),
      LatLng(35.58417,-5.35318
      ),
      LatLng(35.58495,-5.35407
      ),
      LatLng(35.58569,-5.35502
      ),
      LatLng(35.58612,-5.35567
      ),
      LatLng(35.58638,-5.35624
      ),
      LatLng(35.58646,-5.35646
      ),
      LatLng(35.58702,-5.35635
      ),
      LatLng(35.58713,-5.35632
      ),
      LatLng(35.58726,-5.35626
      ),
      LatLng(35.58741,-5.35613
      ),
      LatLng(35.58791,-5.3556
      ),
      LatLng(35.58794,-5.35558
      ),
      LatLng(35.58798,-5.35556
      ),
      LatLng(35.58805,-5.35552
      ),
      LatLng(35.58812,-5.35547
      ),
      LatLng(35.58827,-5.35539
      ),
      LatLng(35.58857,-5.35522
      ),
      LatLng(35.5892,-5.35486
      ),
      LatLng(35.58977,-5.35453
      ),
      LatLng(35.59006,-5.35437
      ),
      LatLng(35.59061,-5.35403
      ),
      LatLng(35.59082,-5.3539
      ),
      LatLng(35.59091,-5.35388
      ),
      LatLng(35.59126,-5.35375
      ),
      LatLng(35.59134,-5.35369
      ),
      LatLng(35.5915,-5.35345
      ),
      LatLng(35.59185,-5.35287
      ),
      LatLng(35.59222,-5.35216
      ),
      LatLng(35.59273,-5.3512
      ),
      LatLng(35.59327,-5.35016
      ),
      LatLng(35.59359,-5.34955
      ),
      LatLng(35.59389,-5.34913
      ),
      LatLng(35.5945,-5.34937
      ),
      LatLng(35.59457,-5.34936
      ),
      LatLng(35.59461,-5.34935
      ),
      LatLng(35.59471,-5.34926
      ),
      LatLng(35.59476,-5.34918
      ),
      LatLng(35.59487,-5.34907
      ),
      LatLng(35.59492,-5.34904
      ),
      LatLng(35.59497,-5.34904
      ),
      LatLng(35.59497,-5.34904
      ),
      LatLng(35.59517,-5.34905
      ),
      LatLng(35.59524,-5.34909
      ),
      LatLng(35.59544,-5.34929
      ),
      LatLng(35.5955,-5.34936
      ),
      LatLng(35.59584,-5.34973
      ),
      LatLng(35.59606,-5.34944
      ),
      LatLng(35.59615,-5.34932
      ),
      LatLng(35.59627,-5.34913
      ),
      LatLng(35.59644,-5.34878
      ),
      LatLng(35.59655,-5.3485
      ),
      LatLng(35.59665,-5.34812
      ),
      LatLng(35.59667,-5.34799
      ),
      LatLng(35.59666,-5.34798
      ),
      LatLng(35.59663,-5.34795
      ),
      LatLng(35.59662,-5.34792
      ),
      LatLng(35.59662,-5.34785
      ),
      LatLng(35.59666,-5.34779
      ),
      LatLng(35.59671,-5.34777
      ),
      LatLng(35.59677,-5.3478
      ),
      LatLng(35.5968,-5.34786
      ),
      LatLng(35.59693,-5.34785
      ),
      LatLng(35.59726,-5.3478
      ),
      LatLng(35.59777,-5.34766
      ),
      LatLng(35.59814,-5.34756
      ),
      LatLng(35.59841,-5.34747
      ),
      LatLng(35.59854,-5.34745
      ),
      LatLng(35.59867,-5.34745
      ),
      LatLng(35.59892,-5.34752
      ),
      LatLng(35.59916,-5.34765
      ),
      LatLng(35.59941,-5.34775
      ),
      LatLng(35.59964,-5.3478
      ),
      LatLng(35.60008,-5.34791
      ),
      LatLng(35.60029,-5.34798
      ),
      LatLng(35.60044,-5.34806
      ),
      LatLng(35.6006,-5.34818
      ),
      LatLng(35.60097,-5.34853
      ),
      LatLng(35.60147,-5.34897
      ),
      LatLng(35.60178,-5.34923
      ),
      LatLng(35.60201,-5.34934
      ),
      LatLng(35.60225,-5.34942
      ),
      LatLng(35.60239,-5.34949
      ),
      LatLng(35.60268,-5.34955
      ),
      LatLng(35.60297,-5.34978
      ),
      LatLng(35.60317,-5.34994
      ),
      LatLng(35.60332,-5.35002
      ),
      LatLng(35.60356,-5.35001
      ),
      LatLng(35.6039,-5.34994
      ),
      LatLng(35.60407,-5.35
      ),
      LatLng(35.60414,-5.35
      ),
      LatLng(35.60438,-5.35006
      ),
      LatLng(35.60461,-5.35013
      ),
      LatLng(35.60487,-5.35025
      ),
      LatLng(35.6052,-5.35057
      ),
      LatLng(35.60544,-5.3507
      ),
      LatLng(35.60564,-5.35087
      ),
      LatLng(35.60605,-5.35116
      ),
      LatLng(35.6061,-5.35121
      ),
      LatLng(35.60626,-5.35155
      ),
      LatLng(35.60632,-5.35165
      ),
      LatLng(35.60642,-5.35172
      ),
      LatLng(35.60666,-5.35184
      ),
      LatLng(35.60679,-5.35194
      ),
      LatLng(35.60687,-5.35197
      ),
      LatLng(35.60696,-5.35196
      ),
      LatLng(35.60707,-5.35193
      ),
      LatLng(35.60723,-5.35195
      ),
      LatLng(35.60739,-5.35195
      ),
      LatLng(35.60752,-5.35203
      ),
      LatLng(35.60771,-5.35219
      ),
      LatLng(35.60781,-5.35223
      ),
      LatLng(35.60794,-5.35231
      ),
      LatLng(35.60836,-5.35246
      ),
      LatLng(35.6085,-5.35259
      ),
      LatLng(35.60864,-5.35268
      ),
      LatLng(35.60901,-5.35299
      ),
      LatLng(35.60905,-5.35309
      ),
      LatLng(35.60921,-5.35396
      ),
      LatLng(35.60932,-5.35431
      ),
      LatLng(35.60949,-5.35465
      ),
      LatLng(35.60945,-5.35482
      ),
      LatLng(35.60943,-5.35534
      ),
      LatLng(35.60943,-5.35538
      ),
      LatLng(35.60921,-5.35574
      ),
      LatLng(35.6091,-5.35584
      ),
      LatLng(35.6088,-5.35585
      ),
      LatLng(35.60859,-5.35599
      ),
      LatLng(35.60831,-5.35612
      ),
      LatLng(35.60807,-5.35657
      ),
      LatLng(35.60774,-5.35688
      ),
      LatLng(35.60763,-5.35698
      ),
      LatLng(35.60757,-5.35707
      ),
      LatLng(35.60752,-5.3572
      ),
      LatLng(35.60743,-5.35746
      ),
      LatLng(35.6073,-5.35775
      ),
      LatLng(35.60719,-5.35789
      ),
      LatLng(35.607,-5.35796
      ),
      LatLng(35.60682,-5.358
      ),
      LatLng(35.60664,-5.35805
      ),
      LatLng(35.60653,-5.35804
      ),
      LatLng(35.60639,-5.35801
      ),
      LatLng(35.60598,-5.35786
      ),
      LatLng(35.60582,-5.3578
      ),
      LatLng(35.60569,-5.35782
      ),
      LatLng(35.60551,-5.35797
      ),
      LatLng(35.60542,-5.35809
      ),
      LatLng(35.60529,-5.35831
      ),
      LatLng(35.60519,-5.35852
      ),
      LatLng(35.60501,-5.35867
      ),
      LatLng(35.60486,-5.35884
      ),
      LatLng(35.60454,-5.35914
      ),
      LatLng(35.60433,-5.35937
      ),
      LatLng(35.60395,-5.35981
      ),
      LatLng(35.60386,-5.35997
      ),
      LatLng(35.60374,-5.36032
      ),
      LatLng(35.60364,-5.36055
      ),
      LatLng(35.60346,-5.36066
      ),
      LatLng(35.6034,-5.3607
      ),
      LatLng(35.60319,-5.36076
      ),
      LatLng(35.603,-5.36077
      ),
      LatLng(35.60285,-5.3608
      ),
      LatLng(35.60278,-5.36082
      ),
      LatLng(35.60273,-5.3608
      ),
      LatLng(35.60267,-5.36075
      ),
      LatLng(35.60256,-5.3606
      ),
      LatLng(35.60246,-5.36048
      ),
      LatLng(35.60289,-5.36043
      ),
      LatLng(35.60295,-5.36038
      ),
      LatLng(35.60302,-5.36029
      ),
      LatLng(35.60304,-5.36019
      ),
      LatLng(35.603,-5.35994
      ),
      LatLng(35.603,-5.35967),

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
                    //_mobx.markers.clear();
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


  void _addMarker(BuildContext context, PointModel pointModel, var icon) {
    final marker = Marker(
      markerId: MarkerId(pointModel.id),
      infoWindow: InfoWindow(title: pointModel.info),
      onTap: () async {
        await _deleteDialog(context, pointModel.id, pointModel.id);
      },
      position: LatLng(pointModel.latitude, pointModel.longitude),
      //icon: BitmapDescriptor.fromBytes(icon),
    );
    _mobx.markers.add(marker);
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
}