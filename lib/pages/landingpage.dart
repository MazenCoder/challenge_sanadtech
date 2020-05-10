import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:challengesanadtech/core/mobx/mobx_point.dart';
import 'package:challengesanadtech/core/notifier/app_state.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class LandingPage extends StatefulWidget {
  @override
  State createState() =>LandingPageState();
}

class LandingPageState extends State {


  static String apiKey = "AIzaSyDolo1Le0868irzhrgQ6B4xqW7IzaV3x08";
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;
  final Mode _mode = Mode.overlay;
  MobxPoint _mobx = MobxPoint();
  double _zoom = 14.0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return SafeArea(
        child: Scaffold(
          body: appState.initialPosition==null?Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(target: appState.initialPosition,zoom: 11),
                onMapCreated: appState.onCreated,
                onCameraMove: appState.onCameraMove,
                markers: appState.markers,
                polylines: appState.polyLines,
              ),
              Positioned(
                top: 60.0,
                right: 15.0,
                left: 15.0,

                child: Material(
                  child: Center(
                    child: Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 3)
                          ]),
                      child: TextField(
                        textAlign: TextAlign.left,
                        controller: appState.sourceController,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        decoration:getInoutDecoration("pick up Location?",
                          Icon(Icons.location_on, color: Colors.pink,),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              (appState.isLoading)?Center(child: CircularProgressIndicator(),):Container(width: 0,height: 0,),

              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 16),
                  child: FloatingActionButton(
                    elevation: 2,
                    child: Icon(Icons.search),
                    heroTag: null,
                    onPressed: () => _handlePressButton(context, appState),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  Future<void> _handlePressButton(BuildContext context, AppState state) async {
    try {
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: apiKey,
        onError: onError,
        mode: _mode,
        language: "ma",
        components: [Component(Component.country, "ma")],
      );

      displayPrediction(p, searchScaffoldKey.currentState, state);
    } catch(_) {}
  }

  void onError(PlacesAutocompleteResponse response) {
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold, AppState state) async {
    try {
      if (p != null) {
        PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
        String address = detail.result.adrAddress
            .replaceAll('</span>, <span class="', ' ')
            .replaceAll('<span class="locality">', '')
            .replaceAll('country-name">', '')
            .replaceAll('</span>', '');
        double latitude = detail.result.geometry.location.lat;
        double longitude = detail.result.geometry.location.lng;
        state.sendRequest(latitude, longitude, address);
      }
    } catch(_) {}
  }

  getInoutDecoration(hint, icon) {
    return InputDecoration(
      icon: Container(
        margin: EdgeInsets.only(left: 20, top: 5),
        width: 10,
        height: 10,
        child:icon ,
      ),
      hintText: hint,
      border: InputBorder.none,
      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
    );
  }
}