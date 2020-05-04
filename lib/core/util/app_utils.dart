import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';


abstract class AppUtils extends ChangeNotifier {

  //Future<Set<Polyline>> getPolyline();
  Future<Uint8List> imgToBytes(String img);
  String CreateCryptoRandomString([int length = 32]);
  Future<void> deleteDialog(BuildContext context, int id);
  bool checkPoint(var location);
  Future<void> insertPoint(EntityPoint entity);
  Future<void> deletePoint(EntityPoint entity);
  Future<void> deleteAllPoint();

}
