import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PointModel extends Equatable {

  final String id;
  final String info;
  final double latitude;
  final double longitude;


  PointModel({
    @required this.id,
    @required this.info,
    @required this.latitude,
    @required this.longitude
  });

  @override
  // TODO: implement props
  List<Object> get props => [id, info, latitude, longitude];

}