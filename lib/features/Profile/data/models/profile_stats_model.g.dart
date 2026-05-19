// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_stats_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileStatsModelCollection on Isar {
  IsarCollection<ProfileStatsModel> get profileStatsModels => this.collection();
}

const ProfileStatsModelSchema = CollectionSchema(
  name: r'ProfileStatsModel',
  id: 140966647603109183,
  properties: {
    r'currentStreak': PropertySchema(
      id: 0,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'isSynced': PropertySchema(
      id: 1,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastOpenedAt': PropertySchema(
      id: 2,
      name: r'lastOpenedAt',
      type: IsarType.dateTime,
    ),
    r'lastOpenedDayKey': PropertySchema(
      id: 3,
      name: r'lastOpenedDayKey',
      type: IsarType.long,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 4,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'monthlyGoalDaysCompleted': PropertySchema(
      id: 5,
      name: r'monthlyGoalDaysCompleted',
      type: IsarType.long,
    ),
    r'monthlyGoalDaysInMonth': PropertySchema(
      id: 6,
      name: r'monthlyGoalDaysInMonth',
      type: IsarType.long,
    ),
    r'monthlyGoalPercent': PropertySchema(
      id: 7,
      name: r'monthlyGoalPercent',
      type: IsarType.double,
    ),
    r'timezoneOffsetMinutes': PropertySchema(
      id: 8,
      name: r'timezoneOffsetMinutes',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 10,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _profileStatsModelEstimateSize,
  serialize: _profileStatsModelSerialize,
  deserialize: _profileStatsModelDeserialize,
  deserializeProp: _profileStatsModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _profileStatsModelGetId,
  getLinks: _profileStatsModelGetLinks,
  attach: _profileStatsModelAttach,
  version: '3.1.0+1',
);

int _profileStatsModelEstimateSize(
  ProfileStatsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _profileStatsModelSerialize(
  ProfileStatsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentStreak);
  writer.writeBool(offsets[1], object.isSynced);
  writer.writeDateTime(offsets[2], object.lastOpenedAt);
  writer.writeLong(offsets[3], object.lastOpenedDayKey);
  writer.writeDateTime(offsets[4], object.lastSyncedAt);
  writer.writeLong(offsets[5], object.monthlyGoalDaysCompleted);
  writer.writeLong(offsets[6], object.monthlyGoalDaysInMonth);
  writer.writeDouble(offsets[7], object.monthlyGoalPercent);
  writer.writeLong(offsets[8], object.timezoneOffsetMinutes);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeString(offsets[10], object.userId);
}

ProfileStatsModel _profileStatsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProfileStatsModel();
  object.currentStreak = reader.readLong(offsets[0]);
  object.isSynced = reader.readBool(offsets[1]);
  object.isarId = id;
  object.lastOpenedAt = reader.readDateTime(offsets[2]);
  object.lastOpenedDayKey = reader.readLong(offsets[3]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[4]);
  object.monthlyGoalDaysCompleted = reader.readLong(offsets[5]);
  object.monthlyGoalDaysInMonth = reader.readLong(offsets[6]);
  object.monthlyGoalPercent = reader.readDouble(offsets[7]);
  object.timezoneOffsetMinutes = reader.readLong(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.userId = reader.readString(offsets[10]);
  return object;
}

P _profileStatsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileStatsModelGetId(ProfileStatsModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _profileStatsModelGetLinks(
    ProfileStatsModel object) {
  return [];
}

void _profileStatsModelAttach(
    IsarCollection<dynamic> col, Id id, ProfileStatsModel object) {
  object.isarId = id;
}

extension ProfileStatsModelByIndex on IsarCollection<ProfileStatsModel> {
  Future<ProfileStatsModel?> getByUserId(String userId) {
    return getByIndex(r'userId', [userId]);
  }

  ProfileStatsModel? getByUserIdSync(String userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(String userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(String userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<ProfileStatsModel?>> getAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<ProfileStatsModel?> getAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'userId', values);
  }

  Future<int> deleteAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'userId', values);
  }

  int deleteAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'userId', values);
  }

  Future<Id> putByUserId(ProfileStatsModel object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(ProfileStatsModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<ProfileStatsModel> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<ProfileStatsModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension ProfileStatsModelQueryWhereSort
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QWhere> {
  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileStatsModelQueryWhere
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QWhereClause> {
  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhereClause>
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhereClause>
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterWhereClause>
      userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ProfileStatsModelQueryFilter
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QFilterCondition> {
  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      isarIdLessThan(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastOpenedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedDayKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOpenedDayKey',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedDayKeyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastOpenedDayKey',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedDayKeyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastOpenedDayKey',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastOpenedDayKeyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastOpenedDayKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyGoalDaysCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyGoalDaysCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyGoalDaysCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyGoalDaysCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysInMonthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyGoalDaysInMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysInMonthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyGoalDaysInMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysInMonthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyGoalDaysInMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalDaysInMonthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyGoalDaysInMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyGoalPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyGoalPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyGoalPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      monthlyGoalPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyGoalPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      timezoneOffsetMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timezoneOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      timezoneOffsetMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timezoneOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      timezoneOffsetMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timezoneOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      timezoneOffsetMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timezoneOffsetMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      updatedAtBetween(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdEqualTo(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdGreaterThan(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdLessThan(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdBetween(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdStartsWith(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdEndsWith(
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

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension ProfileStatsModelQueryObject
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QFilterCondition> {}

extension ProfileStatsModelQueryLinks
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QFilterCondition> {}

extension ProfileStatsModelQuerySortBy
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QSortBy> {
  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByLastOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByLastOpenedDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedDayKey', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByLastOpenedDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedDayKey', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByMonthlyGoalDaysCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysCompleted', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByMonthlyGoalDaysCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysCompleted', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByMonthlyGoalDaysInMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysInMonth', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByMonthlyGoalDaysInMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysInMonth', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByMonthlyGoalPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalPercent', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByMonthlyGoalPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalPercent', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByTimezoneOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezoneOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByTimezoneOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezoneOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ProfileStatsModelQuerySortThenBy
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QSortThenBy> {
  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByLastOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByLastOpenedDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedDayKey', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByLastOpenedDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedDayKey', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByMonthlyGoalDaysCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysCompleted', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByMonthlyGoalDaysCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysCompleted', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByMonthlyGoalDaysInMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysInMonth', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByMonthlyGoalDaysInMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalDaysInMonth', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByMonthlyGoalPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalPercent', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByMonthlyGoalPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyGoalPercent', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByTimezoneOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezoneOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByTimezoneOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezoneOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ProfileStatsModelQueryWhereDistinct
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct> {
  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastOpenedAt');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByLastOpenedDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastOpenedDayKey');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByMonthlyGoalDaysCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyGoalDaysCompleted');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByMonthlyGoalDaysInMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyGoalDaysInMonth');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByMonthlyGoalPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyGoalPercent');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByTimezoneOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timezoneOffsetMinutes');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ProfileStatsModel, ProfileStatsModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension ProfileStatsModelQueryProperty
    on QueryBuilder<ProfileStatsModel, ProfileStatsModel, QQueryProperty> {
  QueryBuilder<ProfileStatsModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ProfileStatsModel, int, QQueryOperations>
      currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<ProfileStatsModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ProfileStatsModel, DateTime, QQueryOperations>
      lastOpenedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastOpenedAt');
    });
  }

  QueryBuilder<ProfileStatsModel, int, QQueryOperations>
      lastOpenedDayKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastOpenedDayKey');
    });
  }

  QueryBuilder<ProfileStatsModel, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<ProfileStatsModel, int, QQueryOperations>
      monthlyGoalDaysCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyGoalDaysCompleted');
    });
  }

  QueryBuilder<ProfileStatsModel, int, QQueryOperations>
      monthlyGoalDaysInMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyGoalDaysInMonth');
    });
  }

  QueryBuilder<ProfileStatsModel, double, QQueryOperations>
      monthlyGoalPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyGoalPercent');
    });
  }

  QueryBuilder<ProfileStatsModel, int, QQueryOperations>
      timezoneOffsetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timezoneOffsetMinutes');
    });
  }

  QueryBuilder<ProfileStatsModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ProfileStatsModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
