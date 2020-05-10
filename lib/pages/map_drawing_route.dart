import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:challengesanadtech/core/ui/responsive_safe_area.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../core/notifier/app_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';



class MapDrawingRoute extends StatefulWidget {
  final Uint8List uint8list;
  MapDrawingRoute(this.uint8list);
  @override
  _MapDrawingRouteState createState() => _MapDrawingRouteState();
}

class _MapDrawingRouteState extends State<MapDrawingRoute> {

  static String googleAPIKey = 'AIzaSyDolo1Le0868irzhrgQ6B4xqW7IzaV3x08';
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);
  TextEditingController sourceController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;
  final Mode _mode = Mode.overlay;
  double _zoom = 14.0;


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppNotifier>(context);
    return ResponsiveSafeArea(
       builder: (context) => Scaffold(
        key: scaffoldState,
        body: appState.initialPosition == null ? Center(
          child: CircularProgressIndicator(),
        ) : Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                if(!_controller.isCompleted) {
                  _controller.complete(controller);
                  _mapController = controller;
                }
                showSnackBar(appState.address, 2000);
                appState.clearApp();
              },
              onCameraMove:(CameraPosition cameraPosition) {
                _zoom = cameraPosition.zoom;
              },
              onTap: (LatLng location) async {
                if (appState.isUpdate) {
                  await appState.addMarkers(context, location);
                } else if (appState.markers.length > 1) {
                  showSnackBar('Do you want to start?', 2200, appState, true);
                } else {
                  await appState.addMarkers(context, location);
                }
              },
              markers: appState.markers,
              polylines: appState.polyLines,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  appState.initialPosition.latitude,
                  appState.initialPosition.longitude,
                ),
                zoom: _zoom,
              ),
              mapType: MapType.normal,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                    elevation: 2,
                    child: Icon(Icons.clear),
                    heroTag: null,
                    onPressed: () => appState.clearApp(),
                ),
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
                  onPressed: () async {
                    if (appState.markers.length > 1) {
                      showSnackBar('Do you want to start?', 2200, appState, true);
                    } else {
                      await _handlePressButton(context, appState);
                    }
                  }
                ),
              ),
            ),
          ],
        ),
         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
         floatingActionButton: FloatingActionButton(
           child: Icon(MdiIcons.directions),
           onPressed: () async {
             await appState.sendRequest();
           },
         ),
      ),
    );
  }

  Future<void> _handlePressButton(BuildContext context, appNotifier) async {
    try {
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleAPIKey,
        onError: onError,
        mode: _mode,
        language: "ma",
        components: [Component(Component.country, "ma")],
      );

      if (p != null) {
        PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
        appNotifier.addMarkers(context, LatLng(detail.result.geometry.location.lat,
            detail.result.geometry.location.lng));
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(detail.result.geometry.location.lat,
              detail.result.geometry.location.lng,
            ),
            zoom: _zoom,
          ),
        ),).catchError((e) => debugPrint('error, Geolocator: $e'));
      }
    } catch(_) {}
  }

  void onError(PlacesAutocompleteResponse response) {
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  void showSnackBar(String content, [int duration = 1500, AppNotifier appState, bool action = false]) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: duration),
      action: action ? SnackBarAction(
        label: "Yes",
        onPressed: () async {
          await appState.sendRequest();
        },
      ) : null,
    ));
  }
}

