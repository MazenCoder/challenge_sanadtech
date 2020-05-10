import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:moor/moor.dart';

part 'entity_configs.g.dart';

class EntityConfigs extends Table {

  IntColumn get idEntityConfig => integer()();
  TextColumn get info => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get zoom => real().nullable()();
  BoolColumn get polygon => boolean().withDefault(const Constant(false)).nullable()();
  BoolColumn get polyline => boolean().withDefault(const Constant(true)).nullable()();
  BoolColumn get markers => boolean().withDefault(const Constant(false)).nullable()();

  @override
  Set<Column> get primaryKey => {idEntityConfig};

}

@UseDao(tables: [EntityConfigs])
class EntityConfigsDao extends DatabaseAccessor<AppDatabase>
    with _$EntityConfigsDaoMixin {

  final AppDatabase db;
  EntityConfigsDao(this.db) : super(db);

  Stream<List<EntityConfig>> watchAllEntityConfig() => select(entityConfigs).watch();
  Stream<EntityConfig> watchEntityConfig() => select(entityConfigs).watchSingle();
  Future<List<EntityConfig>> getAllEntityConfig() => select(entityConfigs).get();
  Future<EntityConfig> getEntityConfig() => select(entityConfigs).getSingle();
  Future insertEntityConfig(Insertable<EntityConfig> details) => into(entityConfigs).insert(details, orReplace: true);
  Future updateEntityConfig(Insertable<EntityConfig> details) => update(entityConfigs).replace(details);
  Future deleteEntityConfig(Insertable<EntityConfig> details) => delete(entityConfigs).delete(details);
}
