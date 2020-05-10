import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:moor/moor.dart';

part 'entity_points.g.dart';

class EntityPoints extends Table {

  //IntColumn get idEntityPoint => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get info => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get inside => boolean().withDefault(const Constant(false)).nullable()();
  BoolColumn get updatePoint => boolean().withDefault(const Constant(false)).nullable()();

  @override
  Set<Column> get primaryKey => {id};

}

@UseDao(tables: [EntityPoints])
class EntityPointsDao extends DatabaseAccessor<AppDatabase>
    with _$EntityPointsDaoMixin {

  final AppDatabase db;
  EntityPointsDao(this.db) : super(db);

  Stream<List<EntityPoint>> watchAllEntityPoint() => select(entityPoints).watch();
  Future<List<EntityPoint>> getAllEntityPoint() => select(entityPoints).get();
  Future insertEntityPoint(Insertable<EntityPoint> details) => into(entityPoints).insert(details);
  Future updateEntityPoint(Insertable<EntityPoint> details) => update(entityPoints).replace(details);
  Future deleteEntityPoint(Insertable<EntityPoint> details) => delete(entityPoints).delete(details);


//  Future<List<Adresse>> getAsyncAdresses(bool async) {
//    return (select(adresses)
//      ..orderBy(
//        ([
//            // Primary sorting by due date
//            (t) => OrderingTerm(expression: t.id_adresse, mode: OrderingMode.desc),
//        ]),
//      )
//      ..where((t) => t.async.equals(async)))
//        .get();
//  }
//
//  Stream<List<Adresse>> watchAsyncAdresses() {
//    return (select(adresses)
//      ..orderBy(
//        ([
//           (t) => OrderingTerm(expression: t.principal, mode: OrderingMode.desc),
//        ]),
//      )).watch();
//  }
}
