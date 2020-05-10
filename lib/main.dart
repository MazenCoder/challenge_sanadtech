import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:challengesanadtech/core/injection/injection_container.dart';
import 'package:challengesanadtech/core/notifier/app_notifier.dart';
import 'package:challengesanadtech/core/notifier/app_state.dart';
import 'package:challengesanadtech/pages/map_drawing_route.dart';
import 'package:challengesanadtech/pages/map_overlapping.dart';
import 'package:challengesanadtech/pages/draw_polygons.dart';
import 'package:challengesanadtech/pages/map_offline.dart';
import 'package:challengesanadtech/pages/map_draw.dart';
import 'core/injection/injection_container.dart' as di;
//import 'package:geolocator/geolocator.dart';
import 'core/database/app_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'core/util/image_helper.dart';
import 'core/util/app_utils.dart';
import 'dart:typed_data';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setup();
    runApp(
      MultiProvider(providers: [
        //ChangeNotifierProvider.value(value: AppState()),
        ChangeNotifierProvider.value(value: AppNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MapDrawingRoute(null),
    );
  }
}


void main2() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var db = AppDatabase.instance;
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => db,
      dispose: (context, value) => value.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Challenge SanadTech',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white,)),
          primaryIconTheme: const IconThemeData.fallback().copyWith(
            color: Colors.white,
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

//  Location location = new Location();
//
//  bool _serviceEnabled;
//  PermissionStatus _permissionGranted;
//  LocationData _locationData;

  @override
  void initState() {
    super.initState();
//    _init();
  }

//  _init() async {
//    await Future.delayed(Duration(seconds: 3)).then((value) => getPermissionStatus());
//  }

//  void getPermissionStatus() async {
//    try {
//      _serviceEnabled = await location.serviceEnabled();
//      if (!_serviceEnabled) {
//        _serviceEnabled = await location.requestService();
//        if (!_serviceEnabled) {
//          return;
//        }
//      }
//
//      _permissionGranted = await location.hasPermission();
//      if (_permissionGranted == PermissionStatus.denied) {
//        _permissionGranted = await location.requestPermission();
//        if (_permissionGranted != PermissionStatus.granted) {
//          return;
//        }
//      }
//
//      _locationData = await location.getLocation();
//    } catch (e) {}
//  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Challenge SandTech'),
      ),
      body: FutureBuilder<Uint8List>(
        future: sl<AppUtils>().imgToBytes(ImageHelper.HOME),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.waiting: return Center(
              child: CircularProgressIndicator(),
            );
            default:
              return ListView(
                padding: const EdgeInsets.all(6),
                children: <Widget>[
                  /*
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MapDraw(snapshot.data)
                        )),
                        title: Text("Draw Polygons"),
                        leading: Icon(MdiIcons.fromString('map-marker-path')),
                        subtitle: Text('you can creating (CRUD) one or many polylines and place/remove geo markers on the same Map\nSelect point to remove'),
                      ),
                    ),
                  ),

                   */
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => DrawPolygons(snapshot.data, null)
                        )),
                        title: Text("Draw Polygons"),
                        leading: Icon(MdiIcons.fromString('map-marker-path')),
                        subtitle: Text('you can creating (CRUD) one or many polylines and place/remove geo markers on the same Map\n - Select point to remove or update\n - online/offline'),
                      ),
                    ),
                  ),
                  /*
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MapOverlapping(snapshot.data)
                        )),
                        title: Text("Marker Outside"),
                        leading: Icon(MdiIcons.fromString('map-marker-remove')),
                        subtitle: Text('if you trying to add a marker outside the defined polygons you will get alert dialog '),
                      ),
                    ),
                  ),


                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MapOffline(snapshot.data)
                        )),
                        title: Text("Offline mode"),
                        leading: Icon(MdiIcons.fromString('wifi-strength-off')),
                        subtitle: Text('first create your polylines in online mode then close app and switch your phone to offline mode'),
                      ),
                    ),
                  ),

                   */
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MapDrawingRoute(snapshot.data)
                        )),
                        title: Text("Draw route"),
                        leading: Icon(MdiIcons.directions),
                        subtitle: Text('you can draw route on google map between two locations\n - Select point to remove or update'),
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}


