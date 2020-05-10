// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobx_point.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MobxPoint on MobxPointBase, Store {
  final _$pointModelAtom = Atom(name: 'MobxPointBase.pointModel');

  @override
  ObservableList<PointModel> get pointModel {
    _$pointModelAtom.context.enforceReadPolicy(_$pointModelAtom);
    _$pointModelAtom.reportObserved();
    return super.pointModel;
  }

  @override
  set pointModel(ObservableList<PointModel> value) {
    _$pointModelAtom.context.conditionallyRunInAction(() {
      super.pointModel = value;
      _$pointModelAtom.reportChanged();
    }, _$pointModelAtom, name: '${_$pointModelAtom.name}_set');
  }

  final _$entitysAtom = Atom(name: 'MobxPointBase.entitys');

  @override
  ObservableList<dynamic> get entitys {
    _$entitysAtom.context.enforceReadPolicy(_$entitysAtom);
    _$entitysAtom.reportObserved();
    return super.entitys;
  }

  @override
  set entitys(ObservableList<dynamic> value) {
    _$entitysAtom.context.conditionallyRunInAction(() {
      super.entitys = value;
      _$entitysAtom.reportChanged();
    }, _$entitysAtom, name: '${_$entitysAtom.name}_set');
  }

  final _$markersAtom = Atom(name: 'MobxPointBase.markers');

  @override
  ObservableList<Marker> get markers {
    _$markersAtom.context.enforceReadPolicy(_$markersAtom);
    _$markersAtom.reportObserved();
    return super.markers;
  }

  @override
  set markers(ObservableList<Marker> value) {
    _$markersAtom.context.conditionallyRunInAction(() {
      super.markers = value;
      _$markersAtom.reportChanged();
    }, _$markersAtom, name: '${_$markersAtom.name}_set');
  }

  final _$latLngsAtom = Atom(name: 'MobxPointBase.latLngs');

  @override
  ObservableList<LatLng> get latLngs {
    _$latLngsAtom.context.enforceReadPolicy(_$latLngsAtom);
    _$latLngsAtom.reportObserved();
    return super.latLngs;
  }

  @override
  set latLngs(ObservableList<LatLng> value) {
    _$latLngsAtom.context.conditionallyRunInAction(() {
      super.latLngs = value;
      _$latLngsAtom.reportChanged();
    }, _$latLngsAtom, name: '${_$latLngsAtom.name}_set');
  }

  final _$polylineAtom = Atom(name: 'MobxPointBase.polyline');

  @override
  ObservableList<Polyline> get polyline {
    _$polylineAtom.context.enforceReadPolicy(_$polylineAtom);
    _$polylineAtom.reportObserved();
    return super.polyline;
  }

  @override
  set polyline(ObservableList<Polyline> value) {
    _$polylineAtom.context.conditionallyRunInAction(() {
      super.polyline = value;
      _$polylineAtom.reportChanged();
    }, _$polylineAtom, name: '${_$polylineAtom.name}_set');
  }

  final _$polygonAtom = Atom(name: 'MobxPointBase.polygon');

  @override
  ObservableList<Polygon> get polygon {
    _$polygonAtom.context.enforceReadPolicy(_$polygonAtom);
    _$polygonAtom.reportObserved();
    return super.polygon;
  }

  @override
  set polygon(ObservableList<Polygon> value) {
    _$polygonAtom.context.conditionallyRunInAction(() {
      super.polygon = value;
      _$polygonAtom.reportChanged();
    }, _$polygonAtom, name: '${_$polygonAtom.name}_set');
  }

  final _$refreshAtom = Atom(name: 'MobxPointBase.refresh');

  @override
  bool get refresh {
    _$refreshAtom.context.enforceReadPolicy(_$refreshAtom);
    _$refreshAtom.reportObserved();
    return super.refresh;
  }

  @override
  set refresh(bool value) {
    _$refreshAtom.context.conditionallyRunInAction(() {
      super.refresh = value;
      _$refreshAtom.reportChanged();
    }, _$refreshAtom, name: '${_$refreshAtom.name}_set');
  }

  final _$isSelectedAtom = Atom(name: 'MobxPointBase.isSelected');

  @override
  bool get isSelected {
    _$isSelectedAtom.context.enforceReadPolicy(_$isSelectedAtom);
    _$isSelectedAtom.reportObserved();
    return super.isSelected;
  }

  @override
  set isSelected(bool value) {
    _$isSelectedAtom.context.conditionallyRunInAction(() {
      super.isSelected = value;
      _$isSelectedAtom.reportChanged();
    }, _$isSelectedAtom, name: '${_$isSelectedAtom.name}_set');
  }

  final _$isConnectedAtom = Atom(name: 'MobxPointBase.isConnected');

  @override
  bool get isConnected {
    _$isConnectedAtom.context.enforceReadPolicy(_$isConnectedAtom);
    _$isConnectedAtom.reportObserved();
    return super.isConnected;
  }

  @override
  set isConnected(bool value) {
    _$isConnectedAtom.context.conditionallyRunInAction(() {
      super.isConnected = value;
      _$isConnectedAtom.reportChanged();
    }, _$isConnectedAtom, name: '${_$isConnectedAtom.name}_set');
  }

  final _$latitudeAtom = Atom(name: 'MobxPointBase.latitude');

  @override
  double get latitude {
    _$latitudeAtom.context.enforceReadPolicy(_$latitudeAtom);
    _$latitudeAtom.reportObserved();
    return super.latitude;
  }

  @override
  set latitude(double value) {
    _$latitudeAtom.context.conditionallyRunInAction(() {
      super.latitude = value;
      _$latitudeAtom.reportChanged();
    }, _$latitudeAtom, name: '${_$latitudeAtom.name}_set');
  }

  final _$longitudeAtom = Atom(name: 'MobxPointBase.longitude');

  @override
  double get longitude {
    _$longitudeAtom.context.enforceReadPolicy(_$longitudeAtom);
    _$longitudeAtom.reportObserved();
    return super.longitude;
  }

  @override
  set longitude(double value) {
    _$longitudeAtom.context.conditionallyRunInAction(() {
      super.longitude = value;
      _$longitudeAtom.reportChanged();
    }, _$longitudeAtom, name: '${_$longitudeAtom.name}_set');
  }

  final _$id_secteurAtom = Atom(name: 'MobxPointBase.id_secteur');

  @override
  String get id_secteur {
    _$id_secteurAtom.context.enforceReadPolicy(_$id_secteurAtom);
    _$id_secteurAtom.reportObserved();
    return super.id_secteur;
  }

  @override
  set id_secteur(String value) {
    _$id_secteurAtom.context.conditionallyRunInAction(() {
      super.id_secteur = value;
      _$id_secteurAtom.reportChanged();
    }, _$id_secteurAtom, name: '${_$id_secteurAtom.name}_set');
  }

  final _$configPolylineAtom = Atom(name: 'MobxPointBase.configPolyline');

  @override
  bool get configPolyline {
    _$configPolylineAtom.context.enforceReadPolicy(_$configPolylineAtom);
    _$configPolylineAtom.reportObserved();
    return super.configPolyline;
  }

  @override
  set configPolyline(bool value) {
    _$configPolylineAtom.context.conditionallyRunInAction(() {
      super.configPolyline = value;
      _$configPolylineAtom.reportChanged();
    }, _$configPolylineAtom, name: '${_$configPolylineAtom.name}_set');
  }

  final _$configPolygonAtom = Atom(name: 'MobxPointBase.configPolygon');

  @override
  bool get configPolygon {
    _$configPolygonAtom.context.enforceReadPolicy(_$configPolygonAtom);
    _$configPolygonAtom.reportObserved();
    return super.configPolygon;
  }

  @override
  set configPolygon(bool value) {
    _$configPolygonAtom.context.conditionallyRunInAction(() {
      super.configPolygon = value;
      _$configPolygonAtom.reportChanged();
    }, _$configPolygonAtom, name: '${_$configPolygonAtom.name}_set');
  }

  final _$configMarkersAtom = Atom(name: 'MobxPointBase.configMarkers');

  @override
  bool get configMarkers {
    _$configMarkersAtom.context.enforceReadPolicy(_$configMarkersAtom);
    _$configMarkersAtom.reportObserved();
    return super.configMarkers;
  }

  @override
  set configMarkers(bool value) {
    _$configMarkersAtom.context.conditionallyRunInAction(() {
      super.configMarkers = value;
      _$configMarkersAtom.reportChanged();
    }, _$configMarkersAtom, name: '${_$configMarkersAtom.name}_set');
  }

  final _$configZoomAtom = Atom(name: 'MobxPointBase.configZoom');

  @override
  double get configZoom {
    _$configZoomAtom.context.enforceReadPolicy(_$configZoomAtom);
    _$configZoomAtom.reportObserved();
    return super.configZoom;
  }

  @override
  set configZoom(double value) {
    _$configZoomAtom.context.conditionallyRunInAction(() {
      super.configZoom = value;
      _$configZoomAtom.reportChanged();
    }, _$configZoomAtom, name: '${_$configZoomAtom.name}_set');
  }

  final _$MobxPointBaseActionController =
      ActionController(name: 'MobxPointBase');

  @override
  void setPosition(LatLng position) {
    final _$actionInfo = _$MobxPointBaseActionController.startAction();
    try {
      return super.setPosition(position);
    } finally {
      _$MobxPointBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPoint(dynamic location, String id, dynamic icon, int index) {
    final _$actionInfo = _$MobxPointBaseActionController.startAction();
    try {
      return super.addPoint(location, id, icon, index);
    } finally {
      _$MobxPointBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSelect(bool selected) {
    final _$actionInfo = _$MobxPointBaseActionController.startAction();
    try {
      return super.onSelect(selected);
    } finally {
      _$MobxPointBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSelectPolyline(bool selected) {
    final _$actionInfo = _$MobxPointBaseActionController.startAction();
    try {
      return super.onSelectPolyline(selected);
    } finally {
      _$MobxPointBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSelectRefresh(bool selected) {
    final _$actionInfo = _$MobxPointBaseActionController.startAction();
    try {
      return super.onSelectRefresh(selected);
    } finally {
      _$MobxPointBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSelectPolygon(bool selected) {
    final _$actionInfo = _$MobxPointBaseActionController.startAction();
    try {
      return super.onSelectPolygon(selected);
    } finally {
      _$MobxPointBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void config(dynamic config) {
    final _$actionInfo = _$MobxPointBaseActionController.startAction();
    try {
      return super.config(config);
    } finally {
      _$MobxPointBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'pointModel: ${pointModel.toString()},entitys: ${entitys.toString()},markers: ${markers.toString()},latLngs: ${latLngs.toString()},polyline: ${polyline.toString()},polygon: ${polygon.toString()},refresh: ${refresh.toString()},isSelected: ${isSelected.toString()},isConnected: ${isConnected.toString()},latitude: ${latitude.toString()},longitude: ${longitude.toString()},id_secteur: ${id_secteur.toString()},configPolyline: ${configPolyline.toString()},configPolygon: ${configPolygon.toString()},configMarkers: ${configMarkers.toString()},configZoom: ${configZoom.toString()}';
    return '{$string}';
  }
}
