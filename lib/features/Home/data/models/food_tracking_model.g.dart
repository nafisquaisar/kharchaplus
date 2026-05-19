// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_tracking_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFoodTrackingHomeModelCollection on Isar {
  IsarCollection<FoodTrackingHomeModel> get foodTrackingHomeModels =>
      this.collection();
}

const FoodTrackingHomeModelSchema = CollectionSchema(
  name: r'FoodTrackingHomeModel',
  id: 387683760429152215,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'mealPrice': PropertySchema(
      id: 3,
      name: r'mealPrice',
      type: IsarType.double,
    ),
    r'monthlyAmount': PropertySchema(
      id: 4,
      name: r'monthlyAmount',
      type: IsarType.double,
    ),
    r'progress': PropertySchema(
      id: 5,
      name: r'progress',
      type: IsarType.double,
    ),
    r'progressPercent': PropertySchema(
      id: 6,
      name: r'progressPercent',
      type: IsarType.long,
    ),
    r'remainingTiffin': PropertySchema(
      id: 7,
      name: r'remainingTiffin',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    ),
    r'totalEaten': PropertySchema(
      id: 10,
      name: r'totalEaten',
      type: IsarType.long,
    ),
    r'totalTiffin': PropertySchema(
      id: 11,
      name: r'totalTiffin',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _foodTrackingHomeModelEstimateSize,
  serialize: _foodTrackingHomeModelSerialize,
  deserialize: _foodTrackingHomeModelDeserialize,
  deserializeProp: _foodTrackingHomeModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _foodTrackingHomeModelGetId,
  getLinks: _foodTrackingHomeModelGetLinks,
  attach: _foodTrackingHomeModelAttach,
  version: '3.1.0+1',
);

int _foodTrackingHomeModelEstimateSize(
  FoodTrackingHomeModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _foodTrackingHomeModelSerialize(
  FoodTrackingHomeModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeDouble(offsets[3], object.mealPrice);
  writer.writeDouble(offsets[4], object.monthlyAmount);
  writer.writeDouble(offsets[5], object.progress);
  writer.writeLong(offsets[6], object.progressPercent);
  writer.writeLong(offsets[7], object.remainingTiffin);
  writer.writeString(offsets[8], object.status);
  writer.writeString(offsets[9], object.title);
  writer.writeLong(offsets[10], object.totalEaten);
  writer.writeLong(offsets[11], object.totalTiffin);
  writer.writeDateTime(offsets[12], object.updatedAt);
}

FoodTrackingHomeModel _foodTrackingHomeModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FoodTrackingHomeModel(
    createdAt: reader.readDateTime(offsets[0]),
    id: reader.readString(offsets[1]),
    mealPrice: reader.readDouble(offsets[3]),
    monthlyAmount: reader.readDouble(offsets[4]),
    remainingTiffin: reader.readLong(offsets[7]),
    status: reader.readString(offsets[8]),
    title: reader.readString(offsets[9]),
    totalEaten: reader.readLong(offsets[10]),
    totalTiffin: reader.readLong(offsets[11]),
    updatedAt: reader.readDateTime(offsets[12]),
  );
  object.isarId = id;
  return object;
}

P _foodTrackingHomeModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _foodTrackingHomeModelGetId(FoodTrackingHomeModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _foodTrackingHomeModelGetLinks(
    FoodTrackingHomeModel object) {
  return [];
}

void _foodTrackingHomeModelAttach(
    IsarCollection<dynamic> col, Id id, FoodTrackingHomeModel object) {
  object.isarId = id;
}

extension FoodTrackingHomeModelQueryWhereSort
    on QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QWhere> {
  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FoodTrackingHomeModelQueryWhere on QueryBuilder<FoodTrackingHomeModel,
    FoodTrackingHomeModel, QWhereClause> {
  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterWhereClause>
      isarIdBetween(
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

extension FoodTrackingHomeModelQueryFilter on QueryBuilder<
    FoodTrackingHomeModel, FoodTrackingHomeModel, QFilterCondition> {
  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> mealPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> mealPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> mealPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> mealPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> monthlyAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> monthlyAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> monthlyAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> monthlyAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressPercentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progressPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressPercentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progressPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressPercentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progressPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> progressPercentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progressPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> remainingTiffinEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingTiffin',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> remainingTiffinGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingTiffin',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> remainingTiffinLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingTiffin',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> remainingTiffinBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingTiffin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalEatenEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalEaten',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalEatenGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalEaten',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalEatenLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalEaten',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalEatenBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalEaten',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalTiffinEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTiffin',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalTiffinGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTiffin',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalTiffinLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTiffin',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> totalTiffinBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTiffin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel,
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
}

extension FoodTrackingHomeModelQueryObject on QueryBuilder<
    FoodTrackingHomeModel, FoodTrackingHomeModel, QFilterCondition> {}

extension FoodTrackingHomeModelQueryLinks on QueryBuilder<FoodTrackingHomeModel,
    FoodTrackingHomeModel, QFilterCondition> {}

extension FoodTrackingHomeModelQuerySortBy
    on QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QSortBy> {
  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByMealPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPrice', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByMealPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPrice', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByMonthlyAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByRemainingTiffin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingTiffin', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByRemainingTiffinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingTiffin', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByTotalEaten() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEaten', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByTotalEatenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEaten', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByTotalTiffin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTiffin', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByTotalTiffinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTiffin', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FoodTrackingHomeModelQuerySortThenBy
    on QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QSortThenBy> {
  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByMealPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPrice', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByMealPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPrice', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByMonthlyAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByRemainingTiffin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingTiffin', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByRemainingTiffinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingTiffin', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByTotalEaten() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEaten', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByTotalEatenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEaten', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByTotalTiffin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTiffin', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByTotalTiffinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTiffin', Sort.desc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FoodTrackingHomeModelQueryWhereDistinct
    on QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct> {
  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByMealPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealPrice');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyAmount');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressPercent');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByRemainingTiffin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingTiffin');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByTotalEaten() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalEaten');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByTotalTiffin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTiffin');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, FoodTrackingHomeModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FoodTrackingHomeModelQueryProperty on QueryBuilder<
    FoodTrackingHomeModel, FoodTrackingHomeModel, QQueryProperty> {
  QueryBuilder<FoodTrackingHomeModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, double, QQueryOperations>
      mealPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealPrice');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, double, QQueryOperations>
      monthlyAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyAmount');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, double, QQueryOperations>
      progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, int, QQueryOperations>
      progressPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressPercent');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, int, QQueryOperations>
      remainingTiffinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingTiffin');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, int, QQueryOperations>
      totalEatenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalEaten');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, int, QQueryOperations>
      totalTiffinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTiffin');
    });
  }

  QueryBuilder<FoodTrackingHomeModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
