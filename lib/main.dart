import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:challengesanadtech/core/injection/injection_container.dart';
import 'package:challengesanadtech/pages/map_overlapping.dart';
import 'package:challengesanadtech/pages/map_offline.dart';
import 'package:challengesanadtech/pages/map_draw.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/database/app_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'core/util/image_helper.dart';
import 'core/util/app_utils.dart';
import 'dart:typed_data';

void main() async {
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

class HomePage extends StatelessWidget {

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
                ],
              );
          }
        },
      )
    );
  }
}

