import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:challengesanadtech/core/model/point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';


abstract class AppUtils extends ChangeNotifier {

  Future<Uint8List> imgToBytes(String img);
  String CreateCryptoRandomString([int length = 32]);
  Future<void> deleteDialog(BuildContext context, int id);
  bool checkPoint(var location);
  bool checkPointOverlapping(var location, var list);
  Future<bool> checkLine(var location, List<PointModel> list);
  Future<void> insertPoint(EntityPoint entity);
  Future<void> insertPointInside(EntityPoint entity);
  Future<void> deletePoint(EntityPoint entity);
  Future<void> deleteAllPoint();
  Future<void> deleteConfig();
  Future<void> updatePoint(bool val, String id);
  Future<void> updatePolyline(EntityPoint entityPoint);
  bool checkLinePolygon(var point, List<PointModel> points);
  Future<String> getPlacemark(var point);
  bool checkPolyline(List<EntityPoint> points, bool config);
  bool checkPolygon(List<EntityPoint> points, bool config);
  Future<void> insertConfig(EntityConfig config);
  Future<void> updateConfig(EntityConfig config);
  LatLng getlatLng(currentPosition, EntityConfig data);
  Future<void> deleteEntityPoint(String id);

}
