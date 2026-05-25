// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electricity_tracking_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetElectricityTrackingHomeModelCollection on Isar {
  IsarCollection<ElectricityTrackingHomeModel>
      get electricityTrackingHomeModels => this.collection();
}

const ElectricityTrackingHomeModelSchema = CollectionSchema(
  name: r'ElectricityTrackingHomeModel',
  id: 5456292394479829917,
  properties: {
    r'billAmount': PropertySchema(
      id: 0,
      name: r'billAmount',
      type: IsarType.double,
    ),
    r'consumedUnits': PropertySchema(
      id: 1,
      name: r'consumedUnits',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentUnit': PropertySchema(
      id: 3,
      name: r'currentUnit',
      type: IsarType.long,
    ),
    r'endDate': PropertySchema(
      id: 4,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 6,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isDeleted': PropertySchema(
      id: 7,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'prevUnit': PropertySchema(
      id: 8,
      name: r'prevUnit',
      type: IsarType.long,
    ),
    r'rate': PropertySchema(
      id: 9,
      name: r'rate',
      type: IsarType.double,
    ),
    r'startDate': PropertySchema(
      id: 10,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 11,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 13,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _electricityTrackingHomeModelEstimateSize,
  serialize: _electricityTrackingHomeModelSerialize,
  deserialize: _electricityTrackingHomeModelDeserialize,
  deserializeProp: _electricityTrackingHomeModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _electricityTrackingHomeModelGetId,
  getLinks: _electricityTrackingHomeModelGetLinks,
  attach: _electricityTrackingHomeModelAttach,
  version: '3.1.0+1',
);

int _electricityTrackingHomeModelEstimateSize(
  ElectricityTrackingHomeModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _electricityTrackingHomeModelSerialize(
  ElectricityTrackingHomeModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.billAmount);
  writer.writeLong(offsets[1], object.consumedUnits);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.currentUnit);
  writer.writeDateTime(offsets[4], object.endDate);
  writer.writeString(offsets[5], object.id);
  writer.writeBool(offsets[6], object.isActive);
  writer.writeBool(offsets[7], object.isDeleted);
  writer.writeLong(offsets[8], object.prevUnit);
  writer.writeDouble(offsets[9], object.rate);
  writer.writeDateTime(offsets[10], object.startDate);
  writer.writeString(offsets[11], object.title);
  writer.writeDateTime(offsets[12], object.updatedAt);
  writer.writeString(offsets[13], object.userId);
}

ElectricityTrackingHomeModel _electricityTrackingHomeModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ElectricityTrackingHomeModel(
    createdAt: reader.readDateTime(offsets[2]),
    currentUnit: reader.readLong(offsets[3]),
    endDate: reader.readDateTime(offsets[4]),
    id: reader.readString(offsets[5]),
    isActive: reader.readBool(offsets[6]),
    isDeleted: reader.readBool(offsets[7]),
    prevUnit: reader.readLong(offsets[8]),
    rate: reader.readDouble(offsets[9]),
    startDate: reader.readDateTime(offsets[10]),
    title: reader.readString(offsets[11]),
    updatedAt: reader.readDateTime(offsets[12]),
    userId: reader.readString(offsets[13]),
  );
  object.isarId = id;
  return object;
}

P _electricityTrackingHomeModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _electricityTrackingHomeModelGetId(ElectricityTrackingHomeModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _electricityTrackingHomeModelGetLinks(
    ElectricityTrackingHomeModel object) {
  return [];
}

void _electricityTrackingHomeModelAttach(
    IsarCollection<dynamic> col, Id id, ElectricityTrackingHomeModel object) {
  object.isarId = id;
}

extension ElectricityTrackingHomeModelQueryWhereSort on QueryBuilder<
    ElectricityTrackingHomeModel, ElectricityTrackingHomeModel, QWhere> {
  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ElectricityTrackingHomeModelQueryWhere on QueryBuilder<
    ElectricityTrackingHomeModel, ElectricityTrackingHomeModel, QWhereClause> {
  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ElectricityTrackingHomeModelQueryFilter on QueryBuilder<
    ElectricityTrackingHomeModel,
    ElectricityTrackingHomeModel,
    QFilterCondition> {
  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> billAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> billAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> billAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> billAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> consumedUnitsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consumedUnits',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> consumedUnitsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consumedUnits',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> consumedUnitsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consumedUnits',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> consumedUnitsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consumedUnits',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> currentUnitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> currentUnitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> currentUnitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> currentUnitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> endDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> endDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> endDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> endDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> prevUnitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prevUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> prevUnitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prevUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> prevUnitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prevUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> prevUnitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prevUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> rateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> rateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> rateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> rateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
          QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
          QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension ElectricityTrackingHomeModelQueryObject on QueryBuilder<
    ElectricityTrackingHomeModel,
    ElectricityTrackingHomeModel,
    QFilterCondition> {}

extension ElectricityTrackingHomeModelQueryLinks on QueryBuilder<
    ElectricityTrackingHomeModel,
    ElectricityTrackingHomeModel,
    QFilterCondition> {}

extension ElectricityTrackingHomeModelQuerySortBy on QueryBuilder<
    ElectricityTrackingHomeModel, ElectricityTrackingHomeModel, QSortBy> {
  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByBillAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmount', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByBillAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmount', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByConsumedUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedUnits', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByConsumedUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedUnits', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByCurrentUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUnit', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByCurrentUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUnit', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByPrevUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevUnit', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByPrevUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevUnit', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ElectricityTrackingHomeModelQuerySortThenBy on QueryBuilder<
    ElectricityTrackingHomeModel, ElectricityTrackingHomeModel, QSortThenBy> {
  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByBillAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmount', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByBillAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmount', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByConsumedUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedUnits', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByConsumedUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedUnits', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByCurrentUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUnit', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByCurrentUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUnit', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByPrevUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevUnit', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByPrevUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevUnit', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ElectricityTrackingHomeModelQueryWhereDistinct on QueryBuilder<
    ElectricityTrackingHomeModel, ElectricityTrackingHomeModel, QDistinct> {
  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByBillAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billAmount');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByConsumedUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consumedUnits');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByCurrentUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentUnit');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByPrevUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prevUnit');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rate');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, ElectricityTrackingHomeModel,
      QDistinct> distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension ElectricityTrackingHomeModelQueryProperty on QueryBuilder<
    ElectricityTrackingHomeModel,
    ElectricityTrackingHomeModel,
    QQueryProperty> {
  QueryBuilder<ElectricityTrackingHomeModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, double, QQueryOperations>
      billAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billAmount');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, int, QQueryOperations>
      consumedUnitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consumedUnits');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, int, QQueryOperations>
      currentUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentUnit');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, DateTime, QQueryOperations>
      endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, String, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, bool, QQueryOperations>
      isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, int, QQueryOperations>
      prevUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prevUnit');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, double, QQueryOperations>
      rateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rate');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, DateTime, QQueryOperations>
      startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ElectricityTrackingHomeModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
