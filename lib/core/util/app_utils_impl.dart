import 'package:challengesanadtech/core/injection/injection_container.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:challengesanadtech/core/network/network_info.dart';
import 'package:challengesanadtech/core/model/point_model.dart';
import 'package:challengesanadtech/pages/locationpath.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';
import 'package:poly/poly.dart';
import 'dart:typed_data';
import 'app_utils.dart';
import 'dart:convert';
import 'dart:math';


class AppUtilsImpl extends AppUtils {

  final String apiKey = "AIzaSyDolo1Le0868irzhrgQ6B4xqW7IzaV3x08";
  PolylinePoints polylinePoints = PolylinePoints();
  Locationpath _locationPath = Locationpath();
  final Random _random = Random.secure();
  Geolocator geolocator = Geolocator();
  final NetworkInfo networkInfo;
  SharedPreferences preferences;
  final Client client;
  AppDatabase database;
  var logger = Logger();

  AppUtilsImpl({this.preferences, this.client, this.networkInfo, this.database}) {
    Future.delayed(Duration(seconds: 3)).then((_) => sl.signalReady(this));
  }


  @override
  Future<Uint8List> imgToBytes(String img) async {
    ByteData bytes = await rootBundle.load(img);
    return bytes.buffer.asUint8List();
  }

  @override
  String CreateCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  @override
  Future<void> deleteDialog(BuildContext context, int id) async {
    return await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Are you sure you want delete this point?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            try {

            } catch(e) {
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
  bool checkPoint(var location) {
    List<Point<num>> l = [
      Point(35.59229568751948, -5.36549661308527),
      Point(35.5935751745398, -5.358715653419495),
      Point(35.586362559179236, -5.354996100068092),
      Point(35.58305840051349, -5.365753434598446),
      Point(35.58678109075662, -5.368871837854385),
    ];

    /// List of Points can be passed as parameter to constructor Polygon()
    Polygon testPolygon = Polygon(l);
    Point in1 = Point(location.latitude, location.longitude);
    return testPolygon.isPointInside(in1);
  }

  @override
  Future<void> insertPoint(EntityPoint entity) async {
    return await database.entityPointsDao.insertEntityPoint(entity);
  }

  @override
  Future<void> deletePoint(EntityPoint entity) async {
    return await database.entityPointsDao.deleteEntityPoint(entity);
  }

  @override
  Future<void> deleteAllPoint() async {
    return await database.deleteAllEntityPoints();
  }

  @override
  bool checkLinePolygon(var point, List<PointModel> points) {
    List<Point<num>> numpoint = [];

    for (PointModel model in points) {
      print(model.latitude);
      print(model.longitude);
      numpoint.add(Point(model.latitude, model.longitude));
    }

    Polygon polygon = Polygon(numpoint);

    if (polygon.contains(point.latitude, point.longitude)) {
      numpoint.clear();
      return true;
    } else {
      numpoint.clear();
      return false;
    }
  }

  @override
  Future<String> getPlacemark(var  point) async {
    try {
      List placemark = await geolocator.placemarkFromCoordinates(point.latitude, point.longitude);
      return placemark[0].name;
    } catch(e) {
      return 'point';
    }
  }

  /*
  @override
  Future<bool> checkLine(var location, List<PointModel> points) async {
    if (points.length < 3) {
      return true;
    } else {

      List<PointLatLng> result = [];
      List<Point<num>> numpoint = [];

      //final lastPoint = map.LatLng(points[points.length-1].latitude, points[points.length-1].longitude);
      final currentPosition = map.LatLng(location.latitude, location.longitude);

      List<PointLatLng> currentResult = await polylinePoints.getRouteBetweenCoordinates(
          apiKey, location.latitude, location.longitude,
          currentPosition.latitude, currentPosition.longitude);

      print('..................................................................');
      for (PointLatLng p in currentResult) {
        print('${p.latitude},${p.longitude}');
      }
      print('..................................................................');

      for (int i = 0; i < points.length -1; i++) {
        print("........ $i/${i+1} ........");
        final lat1 = map.LatLng(points[i].latitude, points[i].longitude);
        final lat2 = map.LatLng(points[i+1].latitude, points[i+1].longitude);
        List<PointLatLng> result1 = await polylinePoints.getRouteBetweenCoordinates(apiKey,
            lat1.latitude, lat1.longitude, lat2.latitude, lat2.longitude);
        result.addAll(result1);
        result1.clear();
      }

      logger.i(result.length, result);

      for (PointLatLng model in result) {
        numpoint.add(Point(model.latitude, model.longitude));
        //print('${model.latitude},${model.longitude}');
      }

      Polygon locationPolygon = Polygon(numpoint);
      for (PointLatLng point in currentResult) {
        print('${point.latitude},${point.longitude}');
        Point in1 = Point(point.latitude, point.longitude);
//        if (locationPolygon.contains(point.latitude, point.longitude)) return false;
        if (locationPolygon.isPointInside(in1)) return false;
      }

      return true;
    }
  }

   */

  List<map.LatLng> _convertToLatLng(List points) {
    List<map.LatLng> result = [];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(map.LatLng(points[i - 1], points[i]));
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


  Future<bool> checkLine(var location, List<PointModel> points) async {
    if (points.length < 3) {
      return true;
    } else {


      print(" location ---> ${location.latitude}, ${location.longitude}");
      print("${points[0].latitude}, ${points[0].longitude}");
      print("${points[1].latitude}, ${points[1].longitude}");
      print('.............');

      return !inLine(Point(points[0].latitude, points[0].longitude),
          Point(points[1].latitude, points[1].longitude),
          Point(location.latitude, location.longitude));

    }
  }

  test(var a, var b, var c) {


    //if (distance(A, C) + distance(B, C) == distance(A, B))
      return true; // C is on the line.
    return false;    // C is not on the line.
  }

  bool inLine(Point A, Point B, Point C) {
    // if AC is vertical
    if (A.x == C.x) return B.x == C.x;
    // if AC is horizontal
    if (A.y == C.y) return B.y == C.y;
    // match the gradients
    return (A.x - C.x)*(A.y - C.y) == (C.x - B.x)*(C.y - B.y);
  }

  @override
  bool checkPointOverlapping(var location, var list) {
    List<Point<num>> l = [];

    for (var val in list) {
      if (!val.inside) {
        l.add(Point(val.latitude, val.longitude));
      }
    }
    /// List of Points can be passed as parameter to constructor Polygon()
    Polygon testPolygon = Polygon(l);
    Point in1 = Point(location.latitude, location.longitude);
    return testPolygon.isPointInside(in1);

  }

  @override
  bool checkPolyline(List<EntityPoint> points, bool config) {
    if (points.length > 1 && config)
      return true;
    return false;
  }

  @override
  bool checkPolygon(List<EntityPoint> points, bool config) {
    if (points.length > 1 && config)
      return true;
    return false;
  }

//  @override
//  Future<bool> updateZoom(double zoom) async {
//    await database.entityConfigsDao.insertEntityConfig(EntityConfig(zoom: zoom));
//  }

  @override
  Future<void> insertConfig(EntityConfig config) async {
    await database.entityConfigsDao.insertEntityConfig(config);
  }

  @override
  Future<void> updateConfig(EntityConfig config) async {
    await database.entityConfigsDao.updateEntityConfig(config);
  }

  @override
  map.LatLng getlatLng(currentPosition, EntityConfig config) {
    if (config != null) {
      return map.LatLng(config.latitude, config.longitude) ;
    } else if (currentPosition != null) {
      return map.LatLng(currentPosition.latitude, currentPosition.longitude);
    } else return map.LatLng(35.586805, -5.361377);
  }

  @override
  Future<void> deleteConfig() async {
    await database.deleteAllEntityConfig();
  }

  @override
  Future<void> deleteEntityPoint(String id) async {
    return await database.deleteEntityPoints(id);
  }

  @override
  Future<void> insertPointInside(EntityPoint entity) async {
    return await database.entityPointsDao.insertEntityPoint(entity);
  }

  @override
  Future<void> updatePoint(bool val, String id) async {
    return await database.updatePoint(val, id);
  }

  @override
  Future<void> updatePolyline(EntityPoint entityPoint) async {
    return await database.entityPointsDao.updateEntityPoint(entityPoint);
  }

}