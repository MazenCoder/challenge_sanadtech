// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class EntityPoint extends DataClass implements Insertable<EntityPoint> {
  final int idEntityPoint;
  final String id;
  final String info;
  final double latitude;
  final double longitude;
  EntityPoint(
      {@required this.idEntityPoint,
      this.id,
      this.info,
      this.latitude,
      this.longitude});
  factory EntityPoint.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return EntityPoint(
      idEntityPoint: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}id_entity_point']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      info: stringType.mapFromDatabaseResponse(data['${effectivePrefix}info']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idEntityPoint != null) {
      map['id_entity_point'] = Variable<int>(idEntityPoint);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  factory EntityPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EntityPoint(
      idEntityPoint: serializer.fromJson<int>(json['idEntityPoint']),
      id: serializer.fromJson<String>(json['id']),
      info: serializer.fromJson<String>(json['info']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idEntityPoint': serializer.toJson<int>(idEntityPoint),
      'id': serializer.toJson<String>(id),
      'info': serializer.toJson<String>(info),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  EntityPoint copyWith(
          {int idEntityPoint,
          String id,
          String info,
          double latitude,
          double longitude}) =>
      EntityPoint(
        idEntityPoint: idEntityPoint ?? this.idEntityPoint,
        id: id ?? this.id,
        info: info ?? this.info,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
  @override
  String toString() {
    return (StringBuffer('EntityPoint(')
          ..write('idEntityPoint: $idEntityPoint, ')
          ..write('id: $id, ')
          ..write('info: $info, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idEntityPoint.hashCode,
      $mrjc(id.hashCode,
          $mrjc(info.hashCode, $mrjc(latitude.hashCode, longitude.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is EntityPoint &&
          other.idEntityPoint == this.idEntityPoint &&
          other.id == this.id &&
          other.info == this.info &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class EntityPointsCompanion extends UpdateCompanion<EntityPoint> {
  final Value<int> idEntityPoint;
  final Value<String> id;
  final Value<String> info;
  final Value<double> latitude;
  final Value<double> longitude;
  const EntityPointsCompanion({
    this.idEntityPoint = const Value.absent(),
    this.id = const Value.absent(),
    this.info = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  EntityPointsCompanion.insert({
    this.idEntityPoint = const Value.absent(),
    this.id = const Value.absent(),
    this.info = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  static Insertable<EntityPoint> custom({
    Expression<int> idEntityPoint,
    Expression<String> id,
    Expression<String> info,
    Expression<double> latitude,
    Expression<double> longitude,
  }) {
    return RawValuesInsertable({
      if (idEntityPoint != null) 'id_entity_point': idEntityPoint,
      if (id != null) 'id': id,
      if (info != null) 'info': info,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  EntityPointsCompanion copyWith(
      {Value<int> idEntityPoint,
      Value<String> id,
      Value<String> info,
      Value<double> latitude,
      Value<double> longitude}) {
    return EntityPointsCompanion(
      idEntityPoint: idEntityPoint ?? this.idEntityPoint,
      id: id ?? this.id,
      info: info ?? this.info,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idEntityPoint.present) {
      map['id_entity_point'] = Variable<int>(idEntityPoint.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }
}

class $EntityPointsTable extends EntityPoints
    with TableInfo<$EntityPointsTable, EntityPoint> {
  final GeneratedDatabase _db;
  final String _alias;
  $EntityPointsTable(this._db, [this._alias]);
  final VerificationMeta _idEntityPointMeta =
      const VerificationMeta('idEntityPoint');
  GeneratedIntColumn _idEntityPoint;
  @override
  GeneratedIntColumn get idEntityPoint =>
      _idEntityPoint ??= _constructIdEntityPoint();
  GeneratedIntColumn _constructIdEntityPoint() {
    return GeneratedIntColumn('id_entity_point', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _infoMeta = const VerificationMeta('info');
  GeneratedTextColumn _info;
  @override
  GeneratedTextColumn get info => _info ??= _constructInfo();
  GeneratedTextColumn _constructInfo() {
    return GeneratedTextColumn(
      'info',
      $tableName,
      true,
    );
  }

  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  GeneratedRealColumn _latitude;
  @override
  GeneratedRealColumn get latitude => _latitude ??= _constructLatitude();
  GeneratedRealColumn _constructLatitude() {
    return GeneratedRealColumn(
      'latitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  GeneratedRealColumn _longitude;
  @override
  GeneratedRealColumn get longitude => _longitude ??= _constructLongitude();
  GeneratedRealColumn _constructLongitude() {
    return GeneratedRealColumn(
      'longitude',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [idEntityPoint, id, info, latitude, longitude];
  @override
  $EntityPointsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'entity_points';
  @override
  final String actualTableName = 'entity_points';
  @override
  VerificationContext validateIntegrity(Insertable<EntityPoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_entity_point')) {
      context.handle(
          _idEntityPointMeta,
          idEntityPoint.isAcceptableOrUnknown(
              data['id_entity_point'], _idEntityPointMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info'], _infoMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude'], _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude'], _longitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idEntityPoint};
  @override
  EntityPoint map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return EntityPoint.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $EntityPointsTable createAlias(String alias) {
    return $EntityPointsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $EntityPointsTable _entityPoints;
  $EntityPointsTable get entityPoints =>
      _entityPoints ??= $EntityPointsTable(this);
  EntityPointsDao _entityPointsDao;
  EntityPointsDao get entityPointsDao =>
      _entityPointsDao ??= EntityPointsDao(this as AppDatabase);
  Future<int> deleteAllEntityPoints() {
    return customUpdate(
      'DELETE FROM entity_points;',
      variables: [],
      updates: {entityPoints},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [entityPoints];
}
