// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_tracking_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWaterTrackingHomeModelCollection on Isar {
  IsarCollection<WaterTrackingHomeModel> get waterTrackingHomeModels =>
      this.collection();
}

const WaterTrackingHomeModelSchema = CollectionSchema(
  name: r'WaterTrackingHomeModel',
  id: -7449006352477237377,
  properties: {
    r'dailyGoalMl': PropertySchema(
      id: 0,
      name: r'dailyGoalMl',
      type: IsarType.long,
    ),
    r'expensePercentChange': PropertySchema(
      id: 1,
      name: r'expensePercentChange',
      type: IsarType.double,
    ),
    r'expenseTrend': PropertySchema(
      id: 2,
      name: r'expenseTrend',
      type: IsarType.string,
    ),
    r'hasExpense': PropertySchema(
      id: 3,
      name: r'hasExpense',
      type: IsarType.bool,
    ),
    r'hasGoal': PropertySchema(
      id: 4,
      name: r'hasGoal',
      type: IsarType.bool,
    ),
    r'hasIntake': PropertySchema(
      id: 5,
      name: r'hasIntake',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 6,
      name: r'id',
      type: IsarType.string,
    ),
    r'intakePercent': PropertySchema(
      id: 7,
      name: r'intakePercent',
      type: IsarType.double,
    ),
    r'monthlyExpense': PropertySchema(
      id: 8,
      name: r'monthlyExpense',
      type: IsarType.double,
    ),
    r'previousMonthExpense': PropertySchema(
      id: 9,
      name: r'previousMonthExpense',
      type: IsarType.double,
    ),
    r'todayIntakeMl': PropertySchema(
      id: 10,
      name: r'todayIntakeMl',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _waterTrackingHomeModelEstimateSize,
  serialize: _waterTrackingHomeModelSerialize,
  deserialize: _waterTrackingHomeModelDeserialize,
  deserializeProp: _waterTrackingHomeModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _waterTrackingHomeModelGetId,
  getLinks: _waterTrackingHomeModelGetLinks,
  attach: _waterTrackingHomeModelAttach,
  version: '3.1.0+1',
);

int _waterTrackingHomeModelEstimateSize(
  WaterTrackingHomeModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.expenseTrend.length * 3;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _waterTrackingHomeModelSerialize(
  WaterTrackingHomeModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dailyGoalMl);
  writer.writeDouble(offsets[1], object.expensePercentChange);
  writer.writeString(offsets[2], object.expenseTrend);
  writer.writeBool(offsets[3], object.hasExpense);
  writer.writeBool(offsets[4], object.hasGoal);
  writer.writeBool(offsets[5], object.hasIntake);
  writer.writeString(offsets[6], object.id);
  writer.writeDouble(offsets[7], object.intakePercent);
  writer.writeDouble(offsets[8], object.monthlyExpense);
  writer.writeDouble(offsets[9], object.previousMonthExpense);
  writer.writeLong(offsets[10], object.todayIntakeMl);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

WaterTrackingHomeModel _waterTrackingHomeModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WaterTrackingHomeModel(
    dailyGoalMl: reader.readLong(offsets[0]),
    expensePercentChange: reader.readDouble(offsets[1]),
    expenseTrend: reader.readString(offsets[2]),
    id: reader.readString(offsets[6]),
    intakePercent: reader.readDouble(offsets[7]),
    monthlyExpense: reader.readDouble(offsets[8]),
    previousMonthExpense: reader.readDouble(offsets[9]),
    todayIntakeMl: reader.readLong(offsets[10]),
    updatedAt: reader.readDateTime(offsets[11]),
  );
  object.isarId = id;
  return object;
}

P _waterTrackingHomeModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _waterTrackingHomeModelGetId(WaterTrackingHomeModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _waterTrackingHomeModelGetLinks(
    WaterTrackingHomeModel object) {
  return [];
}

void _waterTrackingHomeModelAttach(
    IsarCollection<dynamic> col, Id id, WaterTrackingHomeModel object) {
  object.isarId = id;
}

extension WaterTrackingHomeModelQueryWhereSort
    on QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QWhere> {
  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WaterTrackingHomeModelQueryWhere on QueryBuilder<
    WaterTrackingHomeModel, WaterTrackingHomeModel, QWhereClause> {
  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

extension WaterTrackingHomeModelQueryFilter on QueryBuilder<
    WaterTrackingHomeModel, WaterTrackingHomeModel, QFilterCondition> {
  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> dailyGoalMlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyGoalMl',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> dailyGoalMlGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyGoalMl',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> dailyGoalMlLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyGoalMl',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> dailyGoalMlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyGoalMl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expensePercentChangeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expensePercentChange',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expensePercentChangeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expensePercentChange',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expensePercentChangeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expensePercentChange',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expensePercentChangeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expensePercentChange',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expenseTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expenseTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expenseTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expenseTrend',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expenseTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expenseTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
          QAfterFilterCondition>
      expenseTrendContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expenseTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
          QAfterFilterCondition>
      expenseTrendMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expenseTrend',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expenseTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> expenseTrendIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expenseTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> hasExpenseEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasExpense',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> hasGoalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> hasIntakeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasIntake',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> intakePercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intakePercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> intakePercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intakePercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> intakePercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intakePercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> intakePercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intakePercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> monthlyExpenseEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyExpense',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> monthlyExpenseGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyExpense',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> monthlyExpenseLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyExpense',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> monthlyExpenseBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyExpense',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> previousMonthExpenseEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousMonthExpense',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> previousMonthExpenseGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousMonthExpense',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> previousMonthExpenseLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousMonthExpense',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> previousMonthExpenseBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousMonthExpense',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> todayIntakeMlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'todayIntakeMl',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> todayIntakeMlGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'todayIntakeMl',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> todayIntakeMlLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'todayIntakeMl',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> todayIntakeMlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'todayIntakeMl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel,
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

extension WaterTrackingHomeModelQueryObject on QueryBuilder<
    WaterTrackingHomeModel, WaterTrackingHomeModel, QFilterCondition> {}

extension WaterTrackingHomeModelQueryLinks on QueryBuilder<
    WaterTrackingHomeModel, WaterTrackingHomeModel, QFilterCondition> {}

extension WaterTrackingHomeModelQuerySortBy
    on QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QSortBy> {
  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByDailyGoalMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMl', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByDailyGoalMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMl', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByExpensePercentChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensePercentChange', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByExpensePercentChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensePercentChange', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByExpenseTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseTrend', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByExpenseTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseTrend', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByHasExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExpense', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByHasExpenseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExpense', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByHasGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasGoal', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByHasGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasGoal', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByHasIntake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIntake', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByHasIntakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIntake', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByIntakePercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakePercent', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByIntakePercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakePercent', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByMonthlyExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyExpense', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByMonthlyExpenseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyExpense', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByPreviousMonthExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMonthExpense', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByPreviousMonthExpenseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMonthExpense', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByTodayIntakeMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayIntakeMl', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByTodayIntakeMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayIntakeMl', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WaterTrackingHomeModelQuerySortThenBy on QueryBuilder<
    WaterTrackingHomeModel, WaterTrackingHomeModel, QSortThenBy> {
  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByDailyGoalMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMl', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByDailyGoalMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMl', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByExpensePercentChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensePercentChange', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByExpensePercentChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensePercentChange', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByExpenseTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseTrend', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByExpenseTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseTrend', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByHasExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExpense', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByHasExpenseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExpense', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByHasGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasGoal', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByHasGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasGoal', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByHasIntake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIntake', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByHasIntakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIntake', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByIntakePercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakePercent', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByIntakePercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakePercent', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByMonthlyExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyExpense', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByMonthlyExpenseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyExpense', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByPreviousMonthExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMonthExpense', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByPreviousMonthExpenseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMonthExpense', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByTodayIntakeMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayIntakeMl', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByTodayIntakeMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayIntakeMl', Sort.desc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WaterTrackingHomeModelQueryWhereDistinct
    on QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct> {
  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByDailyGoalMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyGoalMl');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByExpensePercentChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expensePercentChange');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByExpenseTrend({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expenseTrend', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByHasExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasExpense');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByHasGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasGoal');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByHasIntake() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasIntake');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByIntakePercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intakePercent');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByMonthlyExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyExpense');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByPreviousMonthExpense() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previousMonthExpense');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByTodayIntakeMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todayIntakeMl');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, WaterTrackingHomeModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension WaterTrackingHomeModelQueryProperty on QueryBuilder<
    WaterTrackingHomeModel, WaterTrackingHomeModel, QQueryProperty> {
  QueryBuilder<WaterTrackingHomeModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, int, QQueryOperations>
      dailyGoalMlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyGoalMl');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, double, QQueryOperations>
      expensePercentChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expensePercentChange');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, String, QQueryOperations>
      expenseTrendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expenseTrend');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, bool, QQueryOperations>
      hasExpenseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasExpense');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, bool, QQueryOperations>
      hasGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasGoal');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, bool, QQueryOperations>
      hasIntakeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasIntake');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, double, QQueryOperations>
      intakePercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intakePercent');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, double, QQueryOperations>
      monthlyExpenseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyExpense');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, double, QQueryOperations>
      previousMonthExpenseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previousMonthExpense');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, int, QQueryOperations>
      todayIntakeMlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todayIntakeMl');
    });
  }

  QueryBuilder<WaterTrackingHomeModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
