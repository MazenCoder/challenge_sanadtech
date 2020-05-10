import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:challengesanadtech/core/model/point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

part 'mobx_point.g.dart';

class MobxPoint = MobxPointBase with _$MobxPoint;

abstract class MobxPointBase with Store {

  @observable
  ObservableList<PointModel> pointModel = ObservableList<PointModel>();

  @observable
  ObservableList entitys = ObservableList<EntityPoint>();

  @observable
  ObservableList<Marker> markers = ObservableList<Marker>();

  @observable
  ObservableList<LatLng> latLngs = ObservableList<LatLng>();

  @observable
  ObservableList<Polyline> polyline = ObservableList<Polyline>();

  @observable
  ObservableList<Polygon> polygon = ObservableList<Polygon>();

  @observable
  bool refresh = false;

  @observable
  bool isSelected = false;

  @observable
  bool isConnected = false;

  @observable
  double latitude = 35.586805;

  @observable
  double longitude = -5.361377;

  @observable
  String id_secteur = '';

  //! config
  @observable
  bool configPolyline = true;

  @observable
  bool configPolygon = false;

  @observable
  bool configMarkers = false;

  @observable
  double configZoom = 14;

  @action
  void setPosition(LatLng position) {
   this.latitude = position.latitude;
   this.longitude = position.longitude;
  }

  @action
  void addPoint(var location, String id, var icon, int index) {
    this.markers.add(Marker(
      markerId: MarkerId(id),
      infoWindow: InfoWindow(title: 'DOMICILE'),
      onTap: () {
        this.markers.removeAt(index);
      },
      position: LatLng(location.latitude, location.longitude),
      //icon: BitmapDescriptor.fromBytes(icon),
    ));
  }

  @action
  void onSelect(bool selected) => this.isSelected = selected;

  @action
  void onSelectPolyline(bool selected) => this.configPolyline = selected;

  @action
  void onSelectRefresh(bool selected) => this.refresh = selected;

  @action
  void onSelectPolygon(bool selected) => this.configPolygon = selected;

  void removePoint(String _idMarker) {
    markers.removeWhere((item) => item.markerId.value == _idMarker);
    pointModel.removeWhere((item) => item.id == _idMarker);
  }

  @action
  void config(EntityConfig config) {
    if (config != null) {
      this.configPolyline = config.polyline;
      this.configPolygon = config.polygon;
      this.configMarkers = config.markers;
      this.configZoom = config.zoom;
    }
  }
}