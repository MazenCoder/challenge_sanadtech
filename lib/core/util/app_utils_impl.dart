import 'package:challengesanadtech/core/injection/injection_container.dart';
import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:challengesanadtech/core/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final Random _random = Random.secure();

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
}