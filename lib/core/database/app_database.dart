import 'package:challengesanadtech/core/model/entity_points.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor/moor.dart';

part 'app_database.g.dart';

@UseMoor(
    /// All Tables
    tables: [
      EntityPoints
    ],
    /// All Daos
    daos: [
      EntityPointsDao
    ],
    /// All Queries
    queries: {
      "deleteAllEntityPoints" : "DELETE FROM entity_points;",
    }
)
class AppDatabase extends _$AppDatabase {

  AppDatabase() : super((FlutterQueryExecutor.inDatabaseFolder(
    path: 'db.transport',
    logStatements: true,
  )));

  @override
  int get schemaVersion => 1;

  //! SINGLETON
  static final AppDatabase _singleton = new AppDatabase._internal();
  AppDatabase._internal() : super((FlutterQueryExecutor.inDatabaseFolder(
    path: 'db.sanadtech',
    logStatements: true,
  )));
  static AppDatabase get instance => _singleton;
}