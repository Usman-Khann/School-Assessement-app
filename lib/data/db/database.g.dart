// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SchoolsTable extends Schools with TableInfo<$SchoolsTable, School> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tehsilMeta = const VerificationMeta('tehsil');
  @override
  late final GeneratedColumn<String> tehsil = GeneratedColumn<String>(
    'tehsil',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, district, tehsil, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schools';
  @override
  VerificationContext validateIntegrity(
    Insertable<School> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('tehsil')) {
      context.handle(
        _tehsilMeta,
        tehsil.isAcceptableOrUnknown(data['tehsil']!, _tehsilMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  School map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return School(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      )!,
      tehsil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tehsil'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SchoolsTable createAlias(String alias) {
    return $SchoolsTable(attachedDatabase, alias);
  }
}

class School extends DataClass implements Insertable<School> {
  final String id;
  final String name;
  final String district;
  final String tehsil;
  final DateTime updatedAt;
  const School({
    required this.id,
    required this.name,
    required this.district,
    required this.tehsil,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['district'] = Variable<String>(district);
    map['tehsil'] = Variable<String>(tehsil);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SchoolsCompanion toCompanion(bool nullToAbsent) {
    return SchoolsCompanion(
      id: Value(id),
      name: Value(name),
      district: Value(district),
      tehsil: Value(tehsil),
      updatedAt: Value(updatedAt),
    );
  }

  factory School.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return School(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      district: serializer.fromJson<String>(json['district']),
      tehsil: serializer.fromJson<String>(json['tehsil']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'district': serializer.toJson<String>(district),
      'tehsil': serializer.toJson<String>(tehsil),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  School copyWith({
    String? id,
    String? name,
    String? district,
    String? tehsil,
    DateTime? updatedAt,
  }) => School(
    id: id ?? this.id,
    name: name ?? this.name,
    district: district ?? this.district,
    tehsil: tehsil ?? this.tehsil,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  School copyWithCompanion(SchoolsCompanion data) {
    return School(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      district: data.district.present ? data.district.value : this.district,
      tehsil: data.tehsil.present ? data.tehsil.value : this.tehsil,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('School(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('district: $district, ')
          ..write('tehsil: $tehsil, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, district, tehsil, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is School &&
          other.id == this.id &&
          other.name == this.name &&
          other.district == this.district &&
          other.tehsil == this.tehsil &&
          other.updatedAt == this.updatedAt);
}

class SchoolsCompanion extends UpdateCompanion<School> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> district;
  final Value<String> tehsil;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SchoolsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.district = const Value.absent(),
    this.tehsil = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchoolsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.district = const Value.absent(),
    this.tehsil = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<School> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? district,
    Expression<String>? tehsil,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (district != null) 'district': district,
      if (tehsil != null) 'tehsil': tehsil,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchoolsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? district,
    Value<String>? tehsil,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SchoolsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      tehsil: tehsil ?? this.tehsil,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (tehsil.present) {
      map['tehsil'] = Variable<String>(tehsil.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('district: $district, ')
          ..write('tehsil: $tehsil, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeachersTable extends Teachers with TableInfo<$TeachersTable, Teacher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeachersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolIdMeta = const VerificationMeta(
    'schoolId',
  );
  @override
  late final GeneratedColumn<String> schoolId = GeneratedColumn<String>(
    'school_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, schoolId, name, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teachers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Teacher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('school_id')) {
      context.handle(
        _schoolIdMeta,
        schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Teacher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Teacher(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      schoolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TeachersTable createAlias(String alias) {
    return $TeachersTable(attachedDatabase, alias);
  }
}

class Teacher extends DataClass implements Insertable<Teacher> {
  final String id;
  final String schoolId;
  final String name;
  final DateTime updatedAt;
  const Teacher({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['school_id'] = Variable<String>(schoolId);
    map['name'] = Variable<String>(name);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TeachersCompanion toCompanion(bool nullToAbsent) {
    return TeachersCompanion(
      id: Value(id),
      schoolId: Value(schoolId),
      name: Value(name),
      updatedAt: Value(updatedAt),
    );
  }

  factory Teacher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Teacher(
      id: serializer.fromJson<String>(json['id']),
      schoolId: serializer.fromJson<String>(json['schoolId']),
      name: serializer.fromJson<String>(json['name']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'schoolId': serializer.toJson<String>(schoolId),
      'name': serializer.toJson<String>(name),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Teacher copyWith({
    String? id,
    String? schoolId,
    String? name,
    DateTime? updatedAt,
  }) => Teacher(
    id: id ?? this.id,
    schoolId: schoolId ?? this.schoolId,
    name: name ?? this.name,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Teacher copyWithCompanion(TeachersCompanion data) {
    return Teacher(
      id: data.id.present ? data.id.value : this.id,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
      name: data.name.present ? data.name.value : this.name,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Teacher(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('name: $name, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, schoolId, name, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Teacher &&
          other.id == this.id &&
          other.schoolId == this.schoolId &&
          other.name == this.name &&
          other.updatedAt == this.updatedAt);
}

class TeachersCompanion extends UpdateCompanion<Teacher> {
  final Value<String> id;
  final Value<String> schoolId;
  final Value<String> name;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TeachersCompanion({
    this.id = const Value.absent(),
    this.schoolId = const Value.absent(),
    this.name = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeachersCompanion.insert({
    required String id,
    required String schoolId,
    this.name = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       schoolId = Value(schoolId),
       updatedAt = Value(updatedAt);
  static Insertable<Teacher> custom({
    Expression<String>? id,
    Expression<String>? schoolId,
    Expression<String>? name,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schoolId != null) 'school_id': schoolId,
      if (name != null) 'name': name,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeachersCompanion copyWith({
    Value<String>? id,
    Value<String>? schoolId,
    Value<String>? name,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TeachersCompanion(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<String>(schoolId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeachersCompanion(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('name: $name, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolIdMeta = const VerificationMeta(
    'schoolId',
  );
  @override
  late final GeneratedColumn<String> schoolId = GeneratedColumn<String>(
    'school_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rollNoMeta = const VerificationMeta('rollNo');
  @override
  late final GeneratedColumn<String> rollNo = GeneratedColumn<String>(
    'roll_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionMeta = const VerificationMeta(
    'section',
  );
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _academicYearMeta = const VerificationMeta(
    'academicYear',
  );
  @override
  late final GeneratedColumn<String> academicYear = GeneratedColumn<String>(
    'academic_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    schoolId,
    code,
    name,
    rollNo,
    grade,
    section,
    academicYear,
    createdAt,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('school_id')) {
      context.handle(
        _schoolIdMeta,
        schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('roll_no')) {
      context.handle(
        _rollNoMeta,
        rollNo.isAcceptableOrUnknown(data['roll_no']!, _rollNoMeta),
      );
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('section')) {
      context.handle(
        _sectionMeta,
        section.isAcceptableOrUnknown(data['section']!, _sectionMeta),
      );
    }
    if (data.containsKey('academic_year')) {
      context.handle(
        _academicYearMeta,
        academicYear.isAcceptableOrUnknown(
          data['academic_year']!,
          _academicYearMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      schoolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      rollNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roll_no'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      )!,
      academicYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final String id;
  final String schoolId;

  /// Short human-readable internal ID, e.g. STU-4F9A2C.
  final String code;
  final String name;
  final String rollNo;
  final int grade;
  final String section;
  final String academicYear;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  const Student({
    required this.id,
    required this.schoolId,
    required this.code,
    required this.name,
    required this.rollNo,
    required this.grade,
    required this.section,
    required this.academicYear,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['school_id'] = Variable<String>(schoolId);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['roll_no'] = Variable<String>(rollNo);
    map['grade'] = Variable<int>(grade);
    map['section'] = Variable<String>(section);
    map['academic_year'] = Variable<String>(academicYear);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      schoolId: Value(schoolId),
      code: Value(code),
      name: Value(name),
      rollNo: Value(rollNo),
      grade: Value(grade),
      section: Value(section),
      academicYear: Value(academicYear),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<String>(json['id']),
      schoolId: serializer.fromJson<String>(json['schoolId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      rollNo: serializer.fromJson<String>(json['rollNo']),
      grade: serializer.fromJson<int>(json['grade']),
      section: serializer.fromJson<String>(json['section']),
      academicYear: serializer.fromJson<String>(json['academicYear']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'schoolId': serializer.toJson<String>(schoolId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'rollNo': serializer.toJson<String>(rollNo),
      'grade': serializer.toJson<int>(grade),
      'section': serializer.toJson<String>(section),
      'academicYear': serializer.toJson<String>(academicYear),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Student copyWith({
    String? id,
    String? schoolId,
    String? code,
    String? name,
    String? rollNo,
    int? grade,
    String? section,
    String? academicYear,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
  }) => Student(
    id: id ?? this.id,
    schoolId: schoolId ?? this.schoolId,
    code: code ?? this.code,
    name: name ?? this.name,
    rollNo: rollNo ?? this.rollNo,
    grade: grade ?? this.grade,
    section: section ?? this.section,
    academicYear: academicYear ?? this.academicYear,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      rollNo: data.rollNo.present ? data.rollNo.value : this.rollNo,
      grade: data.grade.present ? data.grade.value : this.grade,
      section: data.section.present ? data.section.value : this.section,
      academicYear: data.academicYear.present
          ? data.academicYear.value
          : this.academicYear,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('rollNo: $rollNo, ')
          ..write('grade: $grade, ')
          ..write('section: $section, ')
          ..write('academicYear: $academicYear, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    schoolId,
    code,
    name,
    rollNo,
    grade,
    section,
    academicYear,
    createdAt,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.schoolId == this.schoolId &&
          other.code == this.code &&
          other.name == this.name &&
          other.rollNo == this.rollNo &&
          other.grade == this.grade &&
          other.section == this.section &&
          other.academicYear == this.academicYear &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> id;
  final Value<String> schoolId;
  final Value<String> code;
  final Value<String> name;
  final Value<String> rollNo;
  final Value<int> grade;
  final Value<String> section;
  final Value<String> academicYear;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.schoolId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.rollNo = const Value.absent(),
    this.grade = const Value.absent(),
    this.section = const Value.absent(),
    this.academicYear = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String schoolId,
    required String code,
    this.name = const Value.absent(),
    this.rollNo = const Value.absent(),
    required int grade,
    this.section = const Value.absent(),
    this.academicYear = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       schoolId = Value(schoolId),
       code = Value(code),
       grade = Value(grade),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Student> custom({
    Expression<String>? id,
    Expression<String>? schoolId,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? rollNo,
    Expression<int>? grade,
    Expression<String>? section,
    Expression<String>? academicYear,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schoolId != null) 'school_id': schoolId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (rollNo != null) 'roll_no': rollNo,
      if (grade != null) 'grade': grade,
      if (section != null) 'section': section,
      if (academicYear != null) 'academic_year': academicYear,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? id,
    Value<String>? schoolId,
    Value<String>? code,
    Value<String>? name,
    Value<String>? rollNo,
    Value<int>? grade,
    Value<String>? section,
    Value<String>? academicYear,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      code: code ?? this.code,
      name: name ?? this.name,
      rollNo: rollNo ?? this.rollNo,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      academicYear: academicYear ?? this.academicYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<String>(schoolId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rollNo.present) {
      map['roll_no'] = Variable<String>(rollNo.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (academicYear.present) {
      map['academic_year'] = Variable<String>(academicYear.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('rollNo: $rollNo, ')
          ..write('grade: $grade, ')
          ..write('section: $section, ')
          ..write('academicYear: $academicYear, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TextbooksTable extends Textbooks
    with TableInfo<$TextbooksTable, Textbook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextbooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isApplicableMeta = const VerificationMeta(
    'isApplicable',
  );
  @override
  late final GeneratedColumn<bool> isApplicable = GeneratedColumn<bool>(
    'is_applicable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_applicable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _academicYearMeta = const VerificationMeta(
    'academicYear',
  );
  @override
  late final GeneratedColumn<String> academicYear = GeneratedColumn<String>(
    'academic_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _editionMeta = const VerificationMeta(
    'edition',
  );
  @override
  late final GeneratedColumn<String> edition = GeneratedColumn<String>(
    'edition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSha256Meta = const VerificationMeta(
    'fileSha256',
  );
  @override
  late final GeneratedColumn<String> fileSha256 = GeneratedColumn<String>(
    'file_sha256',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _remoteFileMeta = const VerificationMeta(
    'remoteFile',
  );
  @override
  late final GeneratedColumn<String> remoteFile = GeneratedColumn<String>(
    'remote_file',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteBytesMeta = const VerificationMeta(
    'remoteBytes',
  );
  @override
  late final GeneratedColumn<int> remoteBytes = GeneratedColumn<int>(
    'remote_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seriesId,
    version,
    isCurrent,
    isApplicable,
    grade,
    subject,
    title,
    academicYear,
    edition,
    publisher,
    language,
    sourceType,
    sourceUrl,
    filePath,
    fileSha256,
    fileSize,
    importedAt,
    notes,
    remoteFile,
    remoteBytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'textbooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Textbook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    }
    if (data.containsKey('is_applicable')) {
      context.handle(
        _isApplicableMeta,
        isApplicable.isAcceptableOrUnknown(
          data['is_applicable']!,
          _isApplicableMeta,
        ),
      );
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('academic_year')) {
      context.handle(
        _academicYearMeta,
        academicYear.isAcceptableOrUnknown(
          data['academic_year']!,
          _academicYearMeta,
        ),
      );
    }
    if (data.containsKey('edition')) {
      context.handle(
        _editionMeta,
        edition.isAcceptableOrUnknown(data['edition']!, _editionMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('file_sha256')) {
      context.handle(
        _fileSha256Meta,
        fileSha256.isAcceptableOrUnknown(data['file_sha256']!, _fileSha256Meta),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('remote_file')) {
      context.handle(
        _remoteFileMeta,
        remoteFile.isAcceptableOrUnknown(data['remote_file']!, _remoteFileMeta),
      );
    }
    if (data.containsKey('remote_bytes')) {
      context.handle(
        _remoteBytesMeta,
        remoteBytes.isAcceptableOrUnknown(
          data['remote_bytes']!,
          _remoteBytesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Textbook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Textbook(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
      isApplicable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_applicable'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      academicYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year'],
      )!,
      edition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition'],
      )!,
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      fileSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_sha256'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      remoteFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_file'],
      ),
      remoteBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_bytes'],
      ),
    );
  }

  @override
  $TextbooksTable createAlias(String alias) {
    return $TextbooksTable(attachedDatabase, alias);
  }
}

class Textbook extends DataClass implements Insertable<Textbook> {
  final String id;

  /// Groups successive versions/editions of the same book.
  final String seriesId;
  final int version;

  /// True for the most recently imported version in its series.
  final bool isCurrent;

  /// True when the teacher/admin has marked this version as the officially
  /// applicable syllabus book for [academicYear]. Independent of [isCurrent].
  final bool isApplicable;
  final int grade;
  final String subject;
  final String title;
  final String academicYear;
  final String edition;
  final String publisher;
  final String language;

  /// official_download | manual_upload | no_file | demo
  final String sourceType;
  final String sourceUrl;
  final String? filePath;
  final String? fileSha256;
  final int? fileSize;
  final DateTime importedAt;
  final String notes;

  /// For books from the online content catalog: path of the PDF inside the
  /// content repository (e.g. books/g9_math.pdf) and its size in bytes.
  /// The PDF itself is only downloaded when the teacher asks for it.
  final String? remoteFile;
  final int? remoteBytes;
  const Textbook({
    required this.id,
    required this.seriesId,
    required this.version,
    required this.isCurrent,
    required this.isApplicable,
    required this.grade,
    required this.subject,
    required this.title,
    required this.academicYear,
    required this.edition,
    required this.publisher,
    required this.language,
    required this.sourceType,
    required this.sourceUrl,
    this.filePath,
    this.fileSha256,
    this.fileSize,
    required this.importedAt,
    required this.notes,
    this.remoteFile,
    this.remoteBytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['series_id'] = Variable<String>(seriesId);
    map['version'] = Variable<int>(version);
    map['is_current'] = Variable<bool>(isCurrent);
    map['is_applicable'] = Variable<bool>(isApplicable);
    map['grade'] = Variable<int>(grade);
    map['subject'] = Variable<String>(subject);
    map['title'] = Variable<String>(title);
    map['academic_year'] = Variable<String>(academicYear);
    map['edition'] = Variable<String>(edition);
    map['publisher'] = Variable<String>(publisher);
    map['language'] = Variable<String>(language);
    map['source_type'] = Variable<String>(sourceType);
    map['source_url'] = Variable<String>(sourceUrl);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || fileSha256 != null) {
      map['file_sha256'] = Variable<String>(fileSha256);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || remoteFile != null) {
      map['remote_file'] = Variable<String>(remoteFile);
    }
    if (!nullToAbsent || remoteBytes != null) {
      map['remote_bytes'] = Variable<int>(remoteBytes);
    }
    return map;
  }

  TextbooksCompanion toCompanion(bool nullToAbsent) {
    return TextbooksCompanion(
      id: Value(id),
      seriesId: Value(seriesId),
      version: Value(version),
      isCurrent: Value(isCurrent),
      isApplicable: Value(isApplicable),
      grade: Value(grade),
      subject: Value(subject),
      title: Value(title),
      academicYear: Value(academicYear),
      edition: Value(edition),
      publisher: Value(publisher),
      language: Value(language),
      sourceType: Value(sourceType),
      sourceUrl: Value(sourceUrl),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      fileSha256: fileSha256 == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSha256),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      importedAt: Value(importedAt),
      notes: Value(notes),
      remoteFile: remoteFile == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteFile),
      remoteBytes: remoteBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteBytes),
    );
  }

  factory Textbook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Textbook(
      id: serializer.fromJson<String>(json['id']),
      seriesId: serializer.fromJson<String>(json['seriesId']),
      version: serializer.fromJson<int>(json['version']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
      isApplicable: serializer.fromJson<bool>(json['isApplicable']),
      grade: serializer.fromJson<int>(json['grade']),
      subject: serializer.fromJson<String>(json['subject']),
      title: serializer.fromJson<String>(json['title']),
      academicYear: serializer.fromJson<String>(json['academicYear']),
      edition: serializer.fromJson<String>(json['edition']),
      publisher: serializer.fromJson<String>(json['publisher']),
      language: serializer.fromJson<String>(json['language']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      fileSha256: serializer.fromJson<String?>(json['fileSha256']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      notes: serializer.fromJson<String>(json['notes']),
      remoteFile: serializer.fromJson<String?>(json['remoteFile']),
      remoteBytes: serializer.fromJson<int?>(json['remoteBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'seriesId': serializer.toJson<String>(seriesId),
      'version': serializer.toJson<int>(version),
      'isCurrent': serializer.toJson<bool>(isCurrent),
      'isApplicable': serializer.toJson<bool>(isApplicable),
      'grade': serializer.toJson<int>(grade),
      'subject': serializer.toJson<String>(subject),
      'title': serializer.toJson<String>(title),
      'academicYear': serializer.toJson<String>(academicYear),
      'edition': serializer.toJson<String>(edition),
      'publisher': serializer.toJson<String>(publisher),
      'language': serializer.toJson<String>(language),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'filePath': serializer.toJson<String?>(filePath),
      'fileSha256': serializer.toJson<String?>(fileSha256),
      'fileSize': serializer.toJson<int?>(fileSize),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'notes': serializer.toJson<String>(notes),
      'remoteFile': serializer.toJson<String?>(remoteFile),
      'remoteBytes': serializer.toJson<int?>(remoteBytes),
    };
  }

  Textbook copyWith({
    String? id,
    String? seriesId,
    int? version,
    bool? isCurrent,
    bool? isApplicable,
    int? grade,
    String? subject,
    String? title,
    String? academicYear,
    String? edition,
    String? publisher,
    String? language,
    String? sourceType,
    String? sourceUrl,
    Value<String?> filePath = const Value.absent(),
    Value<String?> fileSha256 = const Value.absent(),
    Value<int?> fileSize = const Value.absent(),
    DateTime? importedAt,
    String? notes,
    Value<String?> remoteFile = const Value.absent(),
    Value<int?> remoteBytes = const Value.absent(),
  }) => Textbook(
    id: id ?? this.id,
    seriesId: seriesId ?? this.seriesId,
    version: version ?? this.version,
    isCurrent: isCurrent ?? this.isCurrent,
    isApplicable: isApplicable ?? this.isApplicable,
    grade: grade ?? this.grade,
    subject: subject ?? this.subject,
    title: title ?? this.title,
    academicYear: academicYear ?? this.academicYear,
    edition: edition ?? this.edition,
    publisher: publisher ?? this.publisher,
    language: language ?? this.language,
    sourceType: sourceType ?? this.sourceType,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    filePath: filePath.present ? filePath.value : this.filePath,
    fileSha256: fileSha256.present ? fileSha256.value : this.fileSha256,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    importedAt: importedAt ?? this.importedAt,
    notes: notes ?? this.notes,
    remoteFile: remoteFile.present ? remoteFile.value : this.remoteFile,
    remoteBytes: remoteBytes.present ? remoteBytes.value : this.remoteBytes,
  );
  Textbook copyWithCompanion(TextbooksCompanion data) {
    return Textbook(
      id: data.id.present ? data.id.value : this.id,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      version: data.version.present ? data.version.value : this.version,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
      isApplicable: data.isApplicable.present
          ? data.isApplicable.value
          : this.isApplicable,
      grade: data.grade.present ? data.grade.value : this.grade,
      subject: data.subject.present ? data.subject.value : this.subject,
      title: data.title.present ? data.title.value : this.title,
      academicYear: data.academicYear.present
          ? data.academicYear.value
          : this.academicYear,
      edition: data.edition.present ? data.edition.value : this.edition,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      language: data.language.present ? data.language.value : this.language,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSha256: data.fileSha256.present
          ? data.fileSha256.value
          : this.fileSha256,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      remoteFile: data.remoteFile.present
          ? data.remoteFile.value
          : this.remoteFile,
      remoteBytes: data.remoteBytes.present
          ? data.remoteBytes.value
          : this.remoteBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Textbook(')
          ..write('id: $id, ')
          ..write('seriesId: $seriesId, ')
          ..write('version: $version, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('isApplicable: $isApplicable, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('title: $title, ')
          ..write('academicYear: $academicYear, ')
          ..write('edition: $edition, ')
          ..write('publisher: $publisher, ')
          ..write('language: $language, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('filePath: $filePath, ')
          ..write('fileSha256: $fileSha256, ')
          ..write('fileSize: $fileSize, ')
          ..write('importedAt: $importedAt, ')
          ..write('notes: $notes, ')
          ..write('remoteFile: $remoteFile, ')
          ..write('remoteBytes: $remoteBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    seriesId,
    version,
    isCurrent,
    isApplicable,
    grade,
    subject,
    title,
    academicYear,
    edition,
    publisher,
    language,
    sourceType,
    sourceUrl,
    filePath,
    fileSha256,
    fileSize,
    importedAt,
    notes,
    remoteFile,
    remoteBytes,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Textbook &&
          other.id == this.id &&
          other.seriesId == this.seriesId &&
          other.version == this.version &&
          other.isCurrent == this.isCurrent &&
          other.isApplicable == this.isApplicable &&
          other.grade == this.grade &&
          other.subject == this.subject &&
          other.title == this.title &&
          other.academicYear == this.academicYear &&
          other.edition == this.edition &&
          other.publisher == this.publisher &&
          other.language == this.language &&
          other.sourceType == this.sourceType &&
          other.sourceUrl == this.sourceUrl &&
          other.filePath == this.filePath &&
          other.fileSha256 == this.fileSha256 &&
          other.fileSize == this.fileSize &&
          other.importedAt == this.importedAt &&
          other.notes == this.notes &&
          other.remoteFile == this.remoteFile &&
          other.remoteBytes == this.remoteBytes);
}

class TextbooksCompanion extends UpdateCompanion<Textbook> {
  final Value<String> id;
  final Value<String> seriesId;
  final Value<int> version;
  final Value<bool> isCurrent;
  final Value<bool> isApplicable;
  final Value<int> grade;
  final Value<String> subject;
  final Value<String> title;
  final Value<String> academicYear;
  final Value<String> edition;
  final Value<String> publisher;
  final Value<String> language;
  final Value<String> sourceType;
  final Value<String> sourceUrl;
  final Value<String?> filePath;
  final Value<String?> fileSha256;
  final Value<int?> fileSize;
  final Value<DateTime> importedAt;
  final Value<String> notes;
  final Value<String?> remoteFile;
  final Value<int?> remoteBytes;
  final Value<int> rowid;
  const TextbooksCompanion({
    this.id = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.version = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.isApplicable = const Value.absent(),
    this.grade = const Value.absent(),
    this.subject = const Value.absent(),
    this.title = const Value.absent(),
    this.academicYear = const Value.absent(),
    this.edition = const Value.absent(),
    this.publisher = const Value.absent(),
    this.language = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSha256 = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.remoteFile = const Value.absent(),
    this.remoteBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TextbooksCompanion.insert({
    required String id,
    required String seriesId,
    this.version = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.isApplicable = const Value.absent(),
    required int grade,
    required String subject,
    required String title,
    this.academicYear = const Value.absent(),
    this.edition = const Value.absent(),
    this.publisher = const Value.absent(),
    this.language = const Value.absent(),
    required String sourceType,
    this.sourceUrl = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSha256 = const Value.absent(),
    this.fileSize = const Value.absent(),
    required DateTime importedAt,
    this.notes = const Value.absent(),
    this.remoteFile = const Value.absent(),
    this.remoteBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       seriesId = Value(seriesId),
       grade = Value(grade),
       subject = Value(subject),
       title = Value(title),
       sourceType = Value(sourceType),
       importedAt = Value(importedAt);
  static Insertable<Textbook> custom({
    Expression<String>? id,
    Expression<String>? seriesId,
    Expression<int>? version,
    Expression<bool>? isCurrent,
    Expression<bool>? isApplicable,
    Expression<int>? grade,
    Expression<String>? subject,
    Expression<String>? title,
    Expression<String>? academicYear,
    Expression<String>? edition,
    Expression<String>? publisher,
    Expression<String>? language,
    Expression<String>? sourceType,
    Expression<String>? sourceUrl,
    Expression<String>? filePath,
    Expression<String>? fileSha256,
    Expression<int>? fileSize,
    Expression<DateTime>? importedAt,
    Expression<String>? notes,
    Expression<String>? remoteFile,
    Expression<int>? remoteBytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seriesId != null) 'series_id': seriesId,
      if (version != null) 'version': version,
      if (isCurrent != null) 'is_current': isCurrent,
      if (isApplicable != null) 'is_applicable': isApplicable,
      if (grade != null) 'grade': grade,
      if (subject != null) 'subject': subject,
      if (title != null) 'title': title,
      if (academicYear != null) 'academic_year': academicYear,
      if (edition != null) 'edition': edition,
      if (publisher != null) 'publisher': publisher,
      if (language != null) 'language': language,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (filePath != null) 'file_path': filePath,
      if (fileSha256 != null) 'file_sha256': fileSha256,
      if (fileSize != null) 'file_size': fileSize,
      if (importedAt != null) 'imported_at': importedAt,
      if (notes != null) 'notes': notes,
      if (remoteFile != null) 'remote_file': remoteFile,
      if (remoteBytes != null) 'remote_bytes': remoteBytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TextbooksCompanion copyWith({
    Value<String>? id,
    Value<String>? seriesId,
    Value<int>? version,
    Value<bool>? isCurrent,
    Value<bool>? isApplicable,
    Value<int>? grade,
    Value<String>? subject,
    Value<String>? title,
    Value<String>? academicYear,
    Value<String>? edition,
    Value<String>? publisher,
    Value<String>? language,
    Value<String>? sourceType,
    Value<String>? sourceUrl,
    Value<String?>? filePath,
    Value<String?>? fileSha256,
    Value<int?>? fileSize,
    Value<DateTime>? importedAt,
    Value<String>? notes,
    Value<String?>? remoteFile,
    Value<int?>? remoteBytes,
    Value<int>? rowid,
  }) {
    return TextbooksCompanion(
      id: id ?? this.id,
      seriesId: seriesId ?? this.seriesId,
      version: version ?? this.version,
      isCurrent: isCurrent ?? this.isCurrent,
      isApplicable: isApplicable ?? this.isApplicable,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      academicYear: academicYear ?? this.academicYear,
      edition: edition ?? this.edition,
      publisher: publisher ?? this.publisher,
      language: language ?? this.language,
      sourceType: sourceType ?? this.sourceType,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      filePath: filePath ?? this.filePath,
      fileSha256: fileSha256 ?? this.fileSha256,
      fileSize: fileSize ?? this.fileSize,
      importedAt: importedAt ?? this.importedAt,
      notes: notes ?? this.notes,
      remoteFile: remoteFile ?? this.remoteFile,
      remoteBytes: remoteBytes ?? this.remoteBytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (isApplicable.present) {
      map['is_applicable'] = Variable<bool>(isApplicable.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (academicYear.present) {
      map['academic_year'] = Variable<String>(academicYear.value);
    }
    if (edition.present) {
      map['edition'] = Variable<String>(edition.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSha256.present) {
      map['file_sha256'] = Variable<String>(fileSha256.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (remoteFile.present) {
      map['remote_file'] = Variable<String>(remoteFile.value);
    }
    if (remoteBytes.present) {
      map['remote_bytes'] = Variable<int>(remoteBytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextbooksCompanion(')
          ..write('id: $id, ')
          ..write('seriesId: $seriesId, ')
          ..write('version: $version, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('isApplicable: $isApplicable, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('title: $title, ')
          ..write('academicYear: $academicYear, ')
          ..write('edition: $edition, ')
          ..write('publisher: $publisher, ')
          ..write('language: $language, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('filePath: $filePath, ')
          ..write('fileSha256: $fileSha256, ')
          ..write('fileSize: $fileSize, ')
          ..write('importedAt: $importedAt, ')
          ..write('notes: $notes, ')
          ..write('remoteFile: $remoteFile, ')
          ..write('remoteBytes: $remoteBytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textbookIdMeta = const VerificationMeta(
    'textbookId',
  );
  @override
  late final GeneratedColumn<String> textbookId = GeneratedColumn<String>(
    'textbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageStartMeta = const VerificationMeta(
    'pageStart',
  );
  @override
  late final GeneratedColumn<int> pageStart = GeneratedColumn<int>(
    'page_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageEndMeta = const VerificationMeta(
    'pageEnd',
  );
  @override
  late final GeneratedColumn<int> pageEnd = GeneratedColumn<int>(
    'page_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    textbookId,
    number,
    title,
    pageStart,
    pageEnd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('textbook_id')) {
      context.handle(
        _textbookIdMeta,
        textbookId.isAcceptableOrUnknown(data['textbook_id']!, _textbookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_textbookIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('page_start')) {
      context.handle(
        _pageStartMeta,
        pageStart.isAcceptableOrUnknown(data['page_start']!, _pageStartMeta),
      );
    }
    if (data.containsKey('page_end')) {
      context.handle(
        _pageEndMeta,
        pageEnd.isAcceptableOrUnknown(data['page_end']!, _pageEndMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      textbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}textbook_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      pageStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_start'],
      ),
      pageEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_end'],
      ),
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String textbookId;
  final int number;
  final String title;
  final int? pageStart;
  final int? pageEnd;
  const Chapter({
    required this.id,
    required this.textbookId,
    required this.number,
    required this.title,
    this.pageStart,
    this.pageEnd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['textbook_id'] = Variable<String>(textbookId);
    map['number'] = Variable<int>(number);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || pageStart != null) {
      map['page_start'] = Variable<int>(pageStart);
    }
    if (!nullToAbsent || pageEnd != null) {
      map['page_end'] = Variable<int>(pageEnd);
    }
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      textbookId: Value(textbookId),
      number: Value(number),
      title: Value(title),
      pageStart: pageStart == null && nullToAbsent
          ? const Value.absent()
          : Value(pageStart),
      pageEnd: pageEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(pageEnd),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      textbookId: serializer.fromJson<String>(json['textbookId']),
      number: serializer.fromJson<int>(json['number']),
      title: serializer.fromJson<String>(json['title']),
      pageStart: serializer.fromJson<int?>(json['pageStart']),
      pageEnd: serializer.fromJson<int?>(json['pageEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'textbookId': serializer.toJson<String>(textbookId),
      'number': serializer.toJson<int>(number),
      'title': serializer.toJson<String>(title),
      'pageStart': serializer.toJson<int?>(pageStart),
      'pageEnd': serializer.toJson<int?>(pageEnd),
    };
  }

  Chapter copyWith({
    String? id,
    String? textbookId,
    int? number,
    String? title,
    Value<int?> pageStart = const Value.absent(),
    Value<int?> pageEnd = const Value.absent(),
  }) => Chapter(
    id: id ?? this.id,
    textbookId: textbookId ?? this.textbookId,
    number: number ?? this.number,
    title: title ?? this.title,
    pageStart: pageStart.present ? pageStart.value : this.pageStart,
    pageEnd: pageEnd.present ? pageEnd.value : this.pageEnd,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      textbookId: data.textbookId.present
          ? data.textbookId.value
          : this.textbookId,
      number: data.number.present ? data.number.value : this.number,
      title: data.title.present ? data.title.value : this.title,
      pageStart: data.pageStart.present ? data.pageStart.value : this.pageStart,
      pageEnd: data.pageEnd.present ? data.pageEnd.value : this.pageEnd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('textbookId: $textbookId, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('pageStart: $pageStart, ')
          ..write('pageEnd: $pageEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, textbookId, number, title, pageStart, pageEnd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.textbookId == this.textbookId &&
          other.number == this.number &&
          other.title == this.title &&
          other.pageStart == this.pageStart &&
          other.pageEnd == this.pageEnd);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> textbookId;
  final Value<int> number;
  final Value<String> title;
  final Value<int?> pageStart;
  final Value<int?> pageEnd;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.textbookId = const Value.absent(),
    this.number = const Value.absent(),
    this.title = const Value.absent(),
    this.pageStart = const Value.absent(),
    this.pageEnd = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String textbookId,
    required int number,
    required String title,
    this.pageStart = const Value.absent(),
    this.pageEnd = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       textbookId = Value(textbookId),
       number = Value(number),
       title = Value(title);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? textbookId,
    Expression<int>? number,
    Expression<String>? title,
    Expression<int>? pageStart,
    Expression<int>? pageEnd,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textbookId != null) 'textbook_id': textbookId,
      if (number != null) 'number': number,
      if (title != null) 'title': title,
      if (pageStart != null) 'page_start': pageStart,
      if (pageEnd != null) 'page_end': pageEnd,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? id,
    Value<String>? textbookId,
    Value<int>? number,
    Value<String>? title,
    Value<int?>? pageStart,
    Value<int?>? pageEnd,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      textbookId: textbookId ?? this.textbookId,
      number: number ?? this.number,
      title: title ?? this.title,
      pageStart: pageStart ?? this.pageStart,
      pageEnd: pageEnd ?? this.pageEnd,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (textbookId.present) {
      map['textbook_id'] = Variable<String>(textbookId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pageStart.present) {
      map['page_start'] = Variable<int>(pageStart.value);
    }
    if (pageEnd.present) {
      map['page_end'] = Variable<int>(pageEnd.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('textbookId: $textbookId, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('pageStart: $pageStart, ')
          ..write('pageEnd: $pageEnd, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TopicsTable extends Topics with TableInfo<$TopicsTable, Topic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderNoMeta = const VerificationMeta(
    'orderNo',
  );
  @override
  late final GeneratedColumn<int> orderNo = GeneratedColumn<int>(
    'order_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageStartMeta = const VerificationMeta(
    'pageStart',
  );
  @override
  late final GeneratedColumn<int> pageStart = GeneratedColumn<int>(
    'page_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageEndMeta = const VerificationMeta(
    'pageEnd',
  );
  @override
  late final GeneratedColumn<int> pageEnd = GeneratedColumn<int>(
    'page_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    orderNo,
    title,
    pageStart,
    pageEnd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics';
  @override
  VerificationContext validateIntegrity(
    Insertable<Topic> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('order_no')) {
      context.handle(
        _orderNoMeta,
        orderNo.isAcceptableOrUnknown(data['order_no']!, _orderNoMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('page_start')) {
      context.handle(
        _pageStartMeta,
        pageStart.isAcceptableOrUnknown(data['page_start']!, _pageStartMeta),
      );
    }
    if (data.containsKey('page_end')) {
      context.handle(
        _pageEndMeta,
        pageEnd.isAcceptableOrUnknown(data['page_end']!, _pageEndMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Topic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Topic(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      orderNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_no'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      pageStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_start'],
      ),
      pageEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_end'],
      ),
    );
  }

  @override
  $TopicsTable createAlias(String alias) {
    return $TopicsTable(attachedDatabase, alias);
  }
}

class Topic extends DataClass implements Insertable<Topic> {
  final String id;
  final String chapterId;
  final int orderNo;
  final String title;
  final int? pageStart;
  final int? pageEnd;
  const Topic({
    required this.id,
    required this.chapterId,
    required this.orderNo,
    required this.title,
    this.pageStart,
    this.pageEnd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['order_no'] = Variable<int>(orderNo);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || pageStart != null) {
      map['page_start'] = Variable<int>(pageStart);
    }
    if (!nullToAbsent || pageEnd != null) {
      map['page_end'] = Variable<int>(pageEnd);
    }
    return map;
  }

  TopicsCompanion toCompanion(bool nullToAbsent) {
    return TopicsCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      orderNo: Value(orderNo),
      title: Value(title),
      pageStart: pageStart == null && nullToAbsent
          ? const Value.absent()
          : Value(pageStart),
      pageEnd: pageEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(pageEnd),
    );
  }

  factory Topic.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Topic(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      orderNo: serializer.fromJson<int>(json['orderNo']),
      title: serializer.fromJson<String>(json['title']),
      pageStart: serializer.fromJson<int?>(json['pageStart']),
      pageEnd: serializer.fromJson<int?>(json['pageEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'orderNo': serializer.toJson<int>(orderNo),
      'title': serializer.toJson<String>(title),
      'pageStart': serializer.toJson<int?>(pageStart),
      'pageEnd': serializer.toJson<int?>(pageEnd),
    };
  }

  Topic copyWith({
    String? id,
    String? chapterId,
    int? orderNo,
    String? title,
    Value<int?> pageStart = const Value.absent(),
    Value<int?> pageEnd = const Value.absent(),
  }) => Topic(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    orderNo: orderNo ?? this.orderNo,
    title: title ?? this.title,
    pageStart: pageStart.present ? pageStart.value : this.pageStart,
    pageEnd: pageEnd.present ? pageEnd.value : this.pageEnd,
  );
  Topic copyWithCompanion(TopicsCompanion data) {
    return Topic(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      orderNo: data.orderNo.present ? data.orderNo.value : this.orderNo,
      title: data.title.present ? data.title.value : this.title,
      pageStart: data.pageStart.present ? data.pageStart.value : this.pageStart,
      pageEnd: data.pageEnd.present ? data.pageEnd.value : this.pageEnd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Topic(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('orderNo: $orderNo, ')
          ..write('title: $title, ')
          ..write('pageStart: $pageStart, ')
          ..write('pageEnd: $pageEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chapterId, orderNo, title, pageStart, pageEnd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Topic &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.orderNo == this.orderNo &&
          other.title == this.title &&
          other.pageStart == this.pageStart &&
          other.pageEnd == this.pageEnd);
}

class TopicsCompanion extends UpdateCompanion<Topic> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<int> orderNo;
  final Value<String> title;
  final Value<int?> pageStart;
  final Value<int?> pageEnd;
  final Value<int> rowid;
  const TopicsCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.orderNo = const Value.absent(),
    this.title = const Value.absent(),
    this.pageStart = const Value.absent(),
    this.pageEnd = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopicsCompanion.insert({
    required String id,
    required String chapterId,
    this.orderNo = const Value.absent(),
    required String title,
    this.pageStart = const Value.absent(),
    this.pageEnd = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       chapterId = Value(chapterId),
       title = Value(title);
  static Insertable<Topic> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<int>? orderNo,
    Expression<String>? title,
    Expression<int>? pageStart,
    Expression<int>? pageEnd,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (orderNo != null) 'order_no': orderNo,
      if (title != null) 'title': title,
      if (pageStart != null) 'page_start': pageStart,
      if (pageEnd != null) 'page_end': pageEnd,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopicsCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<int>? orderNo,
    Value<String>? title,
    Value<int?>? pageStart,
    Value<int?>? pageEnd,
    Value<int>? rowid,
  }) {
    return TopicsCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      orderNo: orderNo ?? this.orderNo,
      title: title ?? this.title,
      pageStart: pageStart ?? this.pageStart,
      pageEnd: pageEnd ?? this.pageEnd,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (orderNo.present) {
      map['order_no'] = Variable<int>(orderNo.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pageStart.present) {
      map['page_start'] = Variable<int>(pageStart.value);
    }
    if (pageEnd.present) {
      map['page_end'] = Variable<int>(pageEnd.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('orderNo: $orderNo, ')
          ..write('title: $title, ')
          ..write('pageStart: $pageStart, ')
          ..write('pageEnd: $pageEnd, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textbookIdMeta = const VerificationMeta(
    'textbookId',
  );
  @override
  late final GeneratedColumn<String> textbookId = GeneratedColumn<String>(
    'textbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _correctIndexMeta = const VerificationMeta(
    'correctIndex',
  );
  @override
  late final GeneratedColumn<int> correctIndex = GeneratedColumn<int>(
    'correct_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _shortExplanationMeta = const VerificationMeta(
    'shortExplanation',
  );
  @override
  late final GeneratedColumn<String> shortExplanation = GeneratedColumn<String>(
    'short_explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _conceptExplanationMeta =
      const VerificationMeta('conceptExplanation');
  @override
  late final GeneratedColumn<String> conceptExplanation =
      GeneratedColumn<String>(
        'concept_explanation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _pageRefMeta = const VerificationMeta(
    'pageRef',
  );
  @override
  late final GeneratedColumn<int> pageRef = GeneratedColumn<int>(
    'page_ref',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _reviewNoteMeta = const VerificationMeta(
    'reviewNote',
  );
  @override
  late final GeneratedColumn<String> reviewNote = GeneratedColumn<String>(
    'review_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    textbookId,
    chapterId,
    topicId,
    grade,
    subject,
    type,
    body,
    optionsJson,
    correctIndex,
    answer,
    shortExplanation,
    conceptExplanation,
    pageRef,
    difficulty,
    source,
    reviewNote,
    verified,
    language,
    createdAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('textbook_id')) {
      context.handle(
        _textbookIdMeta,
        textbookId.isAcceptableOrUnknown(data['textbook_id']!, _textbookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_textbookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('correct_index')) {
      context.handle(
        _correctIndexMeta,
        correctIndex.isAcceptableOrUnknown(
          data['correct_index']!,
          _correctIndexMeta,
        ),
      );
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    }
    if (data.containsKey('short_explanation')) {
      context.handle(
        _shortExplanationMeta,
        shortExplanation.isAcceptableOrUnknown(
          data['short_explanation']!,
          _shortExplanationMeta,
        ),
      );
    }
    if (data.containsKey('concept_explanation')) {
      context.handle(
        _conceptExplanationMeta,
        conceptExplanation.isAcceptableOrUnknown(
          data['concept_explanation']!,
          _conceptExplanationMeta,
        ),
      );
    }
    if (data.containsKey('page_ref')) {
      context.handle(
        _pageRefMeta,
        pageRef.isAcceptableOrUnknown(data['page_ref']!, _pageRefMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('review_note')) {
      context.handle(
        _reviewNoteMeta,
        reviewNote.isAcceptableOrUnknown(data['review_note']!, _reviewNoteMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      textbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}textbook_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      ),
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      )!,
      correctIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_index'],
      ),
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      )!,
      shortExplanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_explanation'],
      )!,
      conceptExplanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_explanation'],
      )!,
      pageRef: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_ref'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      reviewNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_note'],
      )!,
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final String textbookId;
  final String chapterId;
  final String? topicId;
  final int grade;
  final String subject;

  /// mcq | short | long | fill | tf
  final String type;
  final String body;

  /// JSON array of option strings (mcq: 4, tf: 2, others: empty).
  final String optionsJson;
  final int? correctIndex;

  /// Model answer / marking points for non-MCQ types.
  final String answer;
  final String shortExplanation;
  final String conceptExplanation;

  /// Only set when verified against the textbook. Never guessed.
  final int? pageRef;

  /// 1 easy, 2 medium, 3 hard
  final int difficulty;

  /// manual | import | ai | demo | elearn
  final String source;

  /// Teacher-facing note when the original question was corrected.
  final String reviewNote;
  final bool verified;
  final String language;
  final DateTime createdAt;
  final bool deleted;
  const Question({
    required this.id,
    required this.textbookId,
    required this.chapterId,
    this.topicId,
    required this.grade,
    required this.subject,
    required this.type,
    required this.body,
    required this.optionsJson,
    this.correctIndex,
    required this.answer,
    required this.shortExplanation,
    required this.conceptExplanation,
    this.pageRef,
    required this.difficulty,
    required this.source,
    required this.reviewNote,
    required this.verified,
    required this.language,
    required this.createdAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['textbook_id'] = Variable<String>(textbookId);
    map['chapter_id'] = Variable<String>(chapterId);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    map['grade'] = Variable<int>(grade);
    map['subject'] = Variable<String>(subject);
    map['type'] = Variable<String>(type);
    map['body'] = Variable<String>(body);
    map['options_json'] = Variable<String>(optionsJson);
    if (!nullToAbsent || correctIndex != null) {
      map['correct_index'] = Variable<int>(correctIndex);
    }
    map['answer'] = Variable<String>(answer);
    map['short_explanation'] = Variable<String>(shortExplanation);
    map['concept_explanation'] = Variable<String>(conceptExplanation);
    if (!nullToAbsent || pageRef != null) {
      map['page_ref'] = Variable<int>(pageRef);
    }
    map['difficulty'] = Variable<int>(difficulty);
    map['source'] = Variable<String>(source);
    map['review_note'] = Variable<String>(reviewNote);
    map['verified'] = Variable<bool>(verified);
    map['language'] = Variable<String>(language);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      textbookId: Value(textbookId),
      chapterId: Value(chapterId),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      grade: Value(grade),
      subject: Value(subject),
      type: Value(type),
      body: Value(body),
      optionsJson: Value(optionsJson),
      correctIndex: correctIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(correctIndex),
      answer: Value(answer),
      shortExplanation: Value(shortExplanation),
      conceptExplanation: Value(conceptExplanation),
      pageRef: pageRef == null && nullToAbsent
          ? const Value.absent()
          : Value(pageRef),
      difficulty: Value(difficulty),
      source: Value(source),
      reviewNote: Value(reviewNote),
      verified: Value(verified),
      language: Value(language),
      createdAt: Value(createdAt),
      deleted: Value(deleted),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      textbookId: serializer.fromJson<String>(json['textbookId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      topicId: serializer.fromJson<String?>(json['topicId']),
      grade: serializer.fromJson<int>(json['grade']),
      subject: serializer.fromJson<String>(json['subject']),
      type: serializer.fromJson<String>(json['type']),
      body: serializer.fromJson<String>(json['body']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      correctIndex: serializer.fromJson<int?>(json['correctIndex']),
      answer: serializer.fromJson<String>(json['answer']),
      shortExplanation: serializer.fromJson<String>(json['shortExplanation']),
      conceptExplanation: serializer.fromJson<String>(
        json['conceptExplanation'],
      ),
      pageRef: serializer.fromJson<int?>(json['pageRef']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      source: serializer.fromJson<String>(json['source']),
      reviewNote: serializer.fromJson<String>(json['reviewNote']),
      verified: serializer.fromJson<bool>(json['verified']),
      language: serializer.fromJson<String>(json['language']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'textbookId': serializer.toJson<String>(textbookId),
      'chapterId': serializer.toJson<String>(chapterId),
      'topicId': serializer.toJson<String?>(topicId),
      'grade': serializer.toJson<int>(grade),
      'subject': serializer.toJson<String>(subject),
      'type': serializer.toJson<String>(type),
      'body': serializer.toJson<String>(body),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'correctIndex': serializer.toJson<int?>(correctIndex),
      'answer': serializer.toJson<String>(answer),
      'shortExplanation': serializer.toJson<String>(shortExplanation),
      'conceptExplanation': serializer.toJson<String>(conceptExplanation),
      'pageRef': serializer.toJson<int?>(pageRef),
      'difficulty': serializer.toJson<int>(difficulty),
      'source': serializer.toJson<String>(source),
      'reviewNote': serializer.toJson<String>(reviewNote),
      'verified': serializer.toJson<bool>(verified),
      'language': serializer.toJson<String>(language),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Question copyWith({
    String? id,
    String? textbookId,
    String? chapterId,
    Value<String?> topicId = const Value.absent(),
    int? grade,
    String? subject,
    String? type,
    String? body,
    String? optionsJson,
    Value<int?> correctIndex = const Value.absent(),
    String? answer,
    String? shortExplanation,
    String? conceptExplanation,
    Value<int?> pageRef = const Value.absent(),
    int? difficulty,
    String? source,
    String? reviewNote,
    bool? verified,
    String? language,
    DateTime? createdAt,
    bool? deleted,
  }) => Question(
    id: id ?? this.id,
    textbookId: textbookId ?? this.textbookId,
    chapterId: chapterId ?? this.chapterId,
    topicId: topicId.present ? topicId.value : this.topicId,
    grade: grade ?? this.grade,
    subject: subject ?? this.subject,
    type: type ?? this.type,
    body: body ?? this.body,
    optionsJson: optionsJson ?? this.optionsJson,
    correctIndex: correctIndex.present ? correctIndex.value : this.correctIndex,
    answer: answer ?? this.answer,
    shortExplanation: shortExplanation ?? this.shortExplanation,
    conceptExplanation: conceptExplanation ?? this.conceptExplanation,
    pageRef: pageRef.present ? pageRef.value : this.pageRef,
    difficulty: difficulty ?? this.difficulty,
    source: source ?? this.source,
    reviewNote: reviewNote ?? this.reviewNote,
    verified: verified ?? this.verified,
    language: language ?? this.language,
    createdAt: createdAt ?? this.createdAt,
    deleted: deleted ?? this.deleted,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      textbookId: data.textbookId.present
          ? data.textbookId.value
          : this.textbookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      grade: data.grade.present ? data.grade.value : this.grade,
      subject: data.subject.present ? data.subject.value : this.subject,
      type: data.type.present ? data.type.value : this.type,
      body: data.body.present ? data.body.value : this.body,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      correctIndex: data.correctIndex.present
          ? data.correctIndex.value
          : this.correctIndex,
      answer: data.answer.present ? data.answer.value : this.answer,
      shortExplanation: data.shortExplanation.present
          ? data.shortExplanation.value
          : this.shortExplanation,
      conceptExplanation: data.conceptExplanation.present
          ? data.conceptExplanation.value
          : this.conceptExplanation,
      pageRef: data.pageRef.present ? data.pageRef.value : this.pageRef,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      source: data.source.present ? data.source.value : this.source,
      reviewNote: data.reviewNote.present
          ? data.reviewNote.value
          : this.reviewNote,
      verified: data.verified.present ? data.verified.value : this.verified,
      language: data.language.present ? data.language.value : this.language,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('textbookId: $textbookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('topicId: $topicId, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('answer: $answer, ')
          ..write('shortExplanation: $shortExplanation, ')
          ..write('conceptExplanation: $conceptExplanation, ')
          ..write('pageRef: $pageRef, ')
          ..write('difficulty: $difficulty, ')
          ..write('source: $source, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('verified: $verified, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    textbookId,
    chapterId,
    topicId,
    grade,
    subject,
    type,
    body,
    optionsJson,
    correctIndex,
    answer,
    shortExplanation,
    conceptExplanation,
    pageRef,
    difficulty,
    source,
    reviewNote,
    verified,
    language,
    createdAt,
    deleted,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.textbookId == this.textbookId &&
          other.chapterId == this.chapterId &&
          other.topicId == this.topicId &&
          other.grade == this.grade &&
          other.subject == this.subject &&
          other.type == this.type &&
          other.body == this.body &&
          other.optionsJson == this.optionsJson &&
          other.correctIndex == this.correctIndex &&
          other.answer == this.answer &&
          other.shortExplanation == this.shortExplanation &&
          other.conceptExplanation == this.conceptExplanation &&
          other.pageRef == this.pageRef &&
          other.difficulty == this.difficulty &&
          other.source == this.source &&
          other.reviewNote == this.reviewNote &&
          other.verified == this.verified &&
          other.language == this.language &&
          other.createdAt == this.createdAt &&
          other.deleted == this.deleted);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<String> textbookId;
  final Value<String> chapterId;
  final Value<String?> topicId;
  final Value<int> grade;
  final Value<String> subject;
  final Value<String> type;
  final Value<String> body;
  final Value<String> optionsJson;
  final Value<int?> correctIndex;
  final Value<String> answer;
  final Value<String> shortExplanation;
  final Value<String> conceptExplanation;
  final Value<int?> pageRef;
  final Value<int> difficulty;
  final Value<String> source;
  final Value<String> reviewNote;
  final Value<bool> verified;
  final Value<String> language;
  final Value<DateTime> createdAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.textbookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.grade = const Value.absent(),
    this.subject = const Value.absent(),
    this.type = const Value.absent(),
    this.body = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.answer = const Value.absent(),
    this.shortExplanation = const Value.absent(),
    this.conceptExplanation = const Value.absent(),
    this.pageRef = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.source = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.verified = const Value.absent(),
    this.language = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String textbookId,
    required String chapterId,
    this.topicId = const Value.absent(),
    required int grade,
    required String subject,
    required String type,
    required String body,
    this.optionsJson = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.answer = const Value.absent(),
    this.shortExplanation = const Value.absent(),
    this.conceptExplanation = const Value.absent(),
    this.pageRef = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.source = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.verified = const Value.absent(),
    this.language = const Value.absent(),
    required DateTime createdAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       textbookId = Value(textbookId),
       chapterId = Value(chapterId),
       grade = Value(grade),
       subject = Value(subject),
       type = Value(type),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<String>? textbookId,
    Expression<String>? chapterId,
    Expression<String>? topicId,
    Expression<int>? grade,
    Expression<String>? subject,
    Expression<String>? type,
    Expression<String>? body,
    Expression<String>? optionsJson,
    Expression<int>? correctIndex,
    Expression<String>? answer,
    Expression<String>? shortExplanation,
    Expression<String>? conceptExplanation,
    Expression<int>? pageRef,
    Expression<int>? difficulty,
    Expression<String>? source,
    Expression<String>? reviewNote,
    Expression<bool>? verified,
    Expression<String>? language,
    Expression<DateTime>? createdAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textbookId != null) 'textbook_id': textbookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (topicId != null) 'topic_id': topicId,
      if (grade != null) 'grade': grade,
      if (subject != null) 'subject': subject,
      if (type != null) 'type': type,
      if (body != null) 'body': body,
      if (optionsJson != null) 'options_json': optionsJson,
      if (correctIndex != null) 'correct_index': correctIndex,
      if (answer != null) 'answer': answer,
      if (shortExplanation != null) 'short_explanation': shortExplanation,
      if (conceptExplanation != null) 'concept_explanation': conceptExplanation,
      if (pageRef != null) 'page_ref': pageRef,
      if (difficulty != null) 'difficulty': difficulty,
      if (source != null) 'source': source,
      if (reviewNote != null) 'review_note': reviewNote,
      if (verified != null) 'verified': verified,
      if (language != null) 'language': language,
      if (createdAt != null) 'created_at': createdAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? textbookId,
    Value<String>? chapterId,
    Value<String?>? topicId,
    Value<int>? grade,
    Value<String>? subject,
    Value<String>? type,
    Value<String>? body,
    Value<String>? optionsJson,
    Value<int?>? correctIndex,
    Value<String>? answer,
    Value<String>? shortExplanation,
    Value<String>? conceptExplanation,
    Value<int?>? pageRef,
    Value<int>? difficulty,
    Value<String>? source,
    Value<String>? reviewNote,
    Value<bool>? verified,
    Value<String>? language,
    Value<DateTime>? createdAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      textbookId: textbookId ?? this.textbookId,
      chapterId: chapterId ?? this.chapterId,
      topicId: topicId ?? this.topicId,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      type: type ?? this.type,
      body: body ?? this.body,
      optionsJson: optionsJson ?? this.optionsJson,
      correctIndex: correctIndex ?? this.correctIndex,
      answer: answer ?? this.answer,
      shortExplanation: shortExplanation ?? this.shortExplanation,
      conceptExplanation: conceptExplanation ?? this.conceptExplanation,
      pageRef: pageRef ?? this.pageRef,
      difficulty: difficulty ?? this.difficulty,
      source: source ?? this.source,
      reviewNote: reviewNote ?? this.reviewNote,
      verified: verified ?? this.verified,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (textbookId.present) {
      map['textbook_id'] = Variable<String>(textbookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (correctIndex.present) {
      map['correct_index'] = Variable<int>(correctIndex.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (shortExplanation.present) {
      map['short_explanation'] = Variable<String>(shortExplanation.value);
    }
    if (conceptExplanation.present) {
      map['concept_explanation'] = Variable<String>(conceptExplanation.value);
    }
    if (pageRef.present) {
      map['page_ref'] = Variable<int>(pageRef.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (reviewNote.present) {
      map['review_note'] = Variable<String>(reviewNote.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('textbookId: $textbookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('topicId: $topicId, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('answer: $answer, ')
          ..write('shortExplanation: $shortExplanation, ')
          ..write('conceptExplanation: $conceptExplanation, ')
          ..write('pageRef: $pageRef, ')
          ..write('difficulty: $difficulty, ')
          ..write('source: $source, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('verified: $verified, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptsTable extends Attempts with TableInfo<$AttemptsTable, Attempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolIdMeta = const VerificationMeta(
    'schoolId',
  );
  @override
  late final GeneratedColumn<String> schoolId = GeneratedColumn<String>(
    'school_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textbookIdMeta = const VerificationMeta(
    'textbookId',
  );
  @override
  late final GeneratedColumn<String> textbookId = GeneratedColumn<String>(
    'textbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textbookTitleMeta = const VerificationMeta(
    'textbookTitle',
  );
  @override
  late final GeneratedColumn<String> textbookTitle = GeneratedColumn<String>(
    'textbook_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _feedbackModeMeta = const VerificationMeta(
    'feedbackMode',
  );
  @override
  late final GeneratedColumn<String> feedbackMode = GeneratedColumn<String>(
    'feedback_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _practiceMeta = const VerificationMeta(
    'practice',
  );
  @override
  late final GeneratedColumn<bool> practice = GeneratedColumn<bool>(
    'practice',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("practice" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _chapterIdsJsonMeta = const VerificationMeta(
    'chapterIdsJson',
  );
  @override
  late final GeneratedColumn<String> chapterIdsJson = GeneratedColumn<String>(
    'chapter_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _topicIdsJsonMeta = const VerificationMeta(
    'topicIdsJson',
  );
  @override
  late final GeneratedColumn<String> topicIdsJson = GeneratedColumn<String>(
    'topic_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentageMeta = const VerificationMeta(
    'percentage',
  );
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
    'percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeTakenSecMeta = const VerificationMeta(
    'timeTakenSec',
  );
  @override
  late final GeneratedColumn<int> timeTakenSec = GeneratedColumn<int>(
    'time_taken_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feedbackMeta = const VerificationMeta(
    'feedback',
  );
  @override
  late final GeneratedColumn<String> feedback = GeneratedColumn<String>(
    'feedback',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    schoolId,
    sessionId,
    studentId,
    grade,
    subject,
    textbookId,
    textbookTitle,
    feedbackMode,
    practice,
    chapterIdsJson,
    topicIdsJson,
    startedAt,
    finishedAt,
    total,
    correct,
    percentage,
    timeTakenSec,
    feedback,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('school_id')) {
      context.handle(
        _schoolIdMeta,
        schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('textbook_id')) {
      context.handle(
        _textbookIdMeta,
        textbookId.isAcceptableOrUnknown(data['textbook_id']!, _textbookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_textbookIdMeta);
    }
    if (data.containsKey('textbook_title')) {
      context.handle(
        _textbookTitleMeta,
        textbookTitle.isAcceptableOrUnknown(
          data['textbook_title']!,
          _textbookTitleMeta,
        ),
      );
    }
    if (data.containsKey('feedback_mode')) {
      context.handle(
        _feedbackModeMeta,
        feedbackMode.isAcceptableOrUnknown(
          data['feedback_mode']!,
          _feedbackModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_feedbackModeMeta);
    }
    if (data.containsKey('practice')) {
      context.handle(
        _practiceMeta,
        practice.isAcceptableOrUnknown(data['practice']!, _practiceMeta),
      );
    }
    if (data.containsKey('chapter_ids_json')) {
      context.handle(
        _chapterIdsJsonMeta,
        chapterIdsJson.isAcceptableOrUnknown(
          data['chapter_ids_json']!,
          _chapterIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('topic_ids_json')) {
      context.handle(
        _topicIdsJsonMeta,
        topicIdsJson.isAcceptableOrUnknown(
          data['topic_ids_json']!,
          _topicIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
        _percentageMeta,
        percentage.isAcceptableOrUnknown(data['percentage']!, _percentageMeta),
      );
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    if (data.containsKey('time_taken_sec')) {
      context.handle(
        _timeTakenSecMeta,
        timeTakenSec.isAcceptableOrUnknown(
          data['time_taken_sec']!,
          _timeTakenSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeTakenSecMeta);
    }
    if (data.containsKey('feedback')) {
      context.handle(
        _feedbackMeta,
        feedback.isAcceptableOrUnknown(data['feedback']!, _feedbackMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      schoolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      textbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}textbook_id'],
      )!,
      textbookTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}textbook_title'],
      )!,
      feedbackMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback_mode'],
      )!,
      practice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}practice'],
      )!,
      chapterIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_ids_json'],
      )!,
      topicIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_ids_json'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      percentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percentage'],
      )!,
      timeTakenSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_taken_sec'],
      )!,
      feedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback'],
      )!,
    );
  }

  @override
  $AttemptsTable createAlias(String alias) {
    return $AttemptsTable(attachedDatabase, alias);
  }
}

class Attempt extends DataClass implements Insertable<Attempt> {
  final String id;
  final String schoolId;

  /// Groups the subjects assessed together in one sitting.
  final String sessionId;
  final String studentId;
  final int grade;
  final String subject;
  final String textbookId;
  final String textbookTitle;

  /// immediate | end
  final String feedbackMode;
  final bool practice;
  final String chapterIdsJson;
  final String topicIdsJson;
  final DateTime startedAt;
  final DateTime finishedAt;
  final int total;
  final int correct;
  final double percentage;
  final int timeTakenSec;
  final String feedback;
  const Attempt({
    required this.id,
    required this.schoolId,
    required this.sessionId,
    required this.studentId,
    required this.grade,
    required this.subject,
    required this.textbookId,
    required this.textbookTitle,
    required this.feedbackMode,
    required this.practice,
    required this.chapterIdsJson,
    required this.topicIdsJson,
    required this.startedAt,
    required this.finishedAt,
    required this.total,
    required this.correct,
    required this.percentage,
    required this.timeTakenSec,
    required this.feedback,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['school_id'] = Variable<String>(schoolId);
    map['session_id'] = Variable<String>(sessionId);
    map['student_id'] = Variable<String>(studentId);
    map['grade'] = Variable<int>(grade);
    map['subject'] = Variable<String>(subject);
    map['textbook_id'] = Variable<String>(textbookId);
    map['textbook_title'] = Variable<String>(textbookTitle);
    map['feedback_mode'] = Variable<String>(feedbackMode);
    map['practice'] = Variable<bool>(practice);
    map['chapter_ids_json'] = Variable<String>(chapterIdsJson);
    map['topic_ids_json'] = Variable<String>(topicIdsJson);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    map['total'] = Variable<int>(total);
    map['correct'] = Variable<int>(correct);
    map['percentage'] = Variable<double>(percentage);
    map['time_taken_sec'] = Variable<int>(timeTakenSec);
    map['feedback'] = Variable<String>(feedback);
    return map;
  }

  AttemptsCompanion toCompanion(bool nullToAbsent) {
    return AttemptsCompanion(
      id: Value(id),
      schoolId: Value(schoolId),
      sessionId: Value(sessionId),
      studentId: Value(studentId),
      grade: Value(grade),
      subject: Value(subject),
      textbookId: Value(textbookId),
      textbookTitle: Value(textbookTitle),
      feedbackMode: Value(feedbackMode),
      practice: Value(practice),
      chapterIdsJson: Value(chapterIdsJson),
      topicIdsJson: Value(topicIdsJson),
      startedAt: Value(startedAt),
      finishedAt: Value(finishedAt),
      total: Value(total),
      correct: Value(correct),
      percentage: Value(percentage),
      timeTakenSec: Value(timeTakenSec),
      feedback: Value(feedback),
    );
  }

  factory Attempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attempt(
      id: serializer.fromJson<String>(json['id']),
      schoolId: serializer.fromJson<String>(json['schoolId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      grade: serializer.fromJson<int>(json['grade']),
      subject: serializer.fromJson<String>(json['subject']),
      textbookId: serializer.fromJson<String>(json['textbookId']),
      textbookTitle: serializer.fromJson<String>(json['textbookTitle']),
      feedbackMode: serializer.fromJson<String>(json['feedbackMode']),
      practice: serializer.fromJson<bool>(json['practice']),
      chapterIdsJson: serializer.fromJson<String>(json['chapterIdsJson']),
      topicIdsJson: serializer.fromJson<String>(json['topicIdsJson']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
      total: serializer.fromJson<int>(json['total']),
      correct: serializer.fromJson<int>(json['correct']),
      percentage: serializer.fromJson<double>(json['percentage']),
      timeTakenSec: serializer.fromJson<int>(json['timeTakenSec']),
      feedback: serializer.fromJson<String>(json['feedback']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'schoolId': serializer.toJson<String>(schoolId),
      'sessionId': serializer.toJson<String>(sessionId),
      'studentId': serializer.toJson<String>(studentId),
      'grade': serializer.toJson<int>(grade),
      'subject': serializer.toJson<String>(subject),
      'textbookId': serializer.toJson<String>(textbookId),
      'textbookTitle': serializer.toJson<String>(textbookTitle),
      'feedbackMode': serializer.toJson<String>(feedbackMode),
      'practice': serializer.toJson<bool>(practice),
      'chapterIdsJson': serializer.toJson<String>(chapterIdsJson),
      'topicIdsJson': serializer.toJson<String>(topicIdsJson),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
      'total': serializer.toJson<int>(total),
      'correct': serializer.toJson<int>(correct),
      'percentage': serializer.toJson<double>(percentage),
      'timeTakenSec': serializer.toJson<int>(timeTakenSec),
      'feedback': serializer.toJson<String>(feedback),
    };
  }

  Attempt copyWith({
    String? id,
    String? schoolId,
    String? sessionId,
    String? studentId,
    int? grade,
    String? subject,
    String? textbookId,
    String? textbookTitle,
    String? feedbackMode,
    bool? practice,
    String? chapterIdsJson,
    String? topicIdsJson,
    DateTime? startedAt,
    DateTime? finishedAt,
    int? total,
    int? correct,
    double? percentage,
    int? timeTakenSec,
    String? feedback,
  }) => Attempt(
    id: id ?? this.id,
    schoolId: schoolId ?? this.schoolId,
    sessionId: sessionId ?? this.sessionId,
    studentId: studentId ?? this.studentId,
    grade: grade ?? this.grade,
    subject: subject ?? this.subject,
    textbookId: textbookId ?? this.textbookId,
    textbookTitle: textbookTitle ?? this.textbookTitle,
    feedbackMode: feedbackMode ?? this.feedbackMode,
    practice: practice ?? this.practice,
    chapterIdsJson: chapterIdsJson ?? this.chapterIdsJson,
    topicIdsJson: topicIdsJson ?? this.topicIdsJson,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt ?? this.finishedAt,
    total: total ?? this.total,
    correct: correct ?? this.correct,
    percentage: percentage ?? this.percentage,
    timeTakenSec: timeTakenSec ?? this.timeTakenSec,
    feedback: feedback ?? this.feedback,
  );
  Attempt copyWithCompanion(AttemptsCompanion data) {
    return Attempt(
      id: data.id.present ? data.id.value : this.id,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      grade: data.grade.present ? data.grade.value : this.grade,
      subject: data.subject.present ? data.subject.value : this.subject,
      textbookId: data.textbookId.present
          ? data.textbookId.value
          : this.textbookId,
      textbookTitle: data.textbookTitle.present
          ? data.textbookTitle.value
          : this.textbookTitle,
      feedbackMode: data.feedbackMode.present
          ? data.feedbackMode.value
          : this.feedbackMode,
      practice: data.practice.present ? data.practice.value : this.practice,
      chapterIdsJson: data.chapterIdsJson.present
          ? data.chapterIdsJson.value
          : this.chapterIdsJson,
      topicIdsJson: data.topicIdsJson.present
          ? data.topicIdsJson.value
          : this.topicIdsJson,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      total: data.total.present ? data.total.value : this.total,
      correct: data.correct.present ? data.correct.value : this.correct,
      percentage: data.percentage.present
          ? data.percentage.value
          : this.percentage,
      timeTakenSec: data.timeTakenSec.present
          ? data.timeTakenSec.value
          : this.timeTakenSec,
      feedback: data.feedback.present ? data.feedback.value : this.feedback,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attempt(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('sessionId: $sessionId, ')
          ..write('studentId: $studentId, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('textbookId: $textbookId, ')
          ..write('textbookTitle: $textbookTitle, ')
          ..write('feedbackMode: $feedbackMode, ')
          ..write('practice: $practice, ')
          ..write('chapterIdsJson: $chapterIdsJson, ')
          ..write('topicIdsJson: $topicIdsJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('total: $total, ')
          ..write('correct: $correct, ')
          ..write('percentage: $percentage, ')
          ..write('timeTakenSec: $timeTakenSec, ')
          ..write('feedback: $feedback')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    schoolId,
    sessionId,
    studentId,
    grade,
    subject,
    textbookId,
    textbookTitle,
    feedbackMode,
    practice,
    chapterIdsJson,
    topicIdsJson,
    startedAt,
    finishedAt,
    total,
    correct,
    percentage,
    timeTakenSec,
    feedback,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attempt &&
          other.id == this.id &&
          other.schoolId == this.schoolId &&
          other.sessionId == this.sessionId &&
          other.studentId == this.studentId &&
          other.grade == this.grade &&
          other.subject == this.subject &&
          other.textbookId == this.textbookId &&
          other.textbookTitle == this.textbookTitle &&
          other.feedbackMode == this.feedbackMode &&
          other.practice == this.practice &&
          other.chapterIdsJson == this.chapterIdsJson &&
          other.topicIdsJson == this.topicIdsJson &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.total == this.total &&
          other.correct == this.correct &&
          other.percentage == this.percentage &&
          other.timeTakenSec == this.timeTakenSec &&
          other.feedback == this.feedback);
}

class AttemptsCompanion extends UpdateCompanion<Attempt> {
  final Value<String> id;
  final Value<String> schoolId;
  final Value<String> sessionId;
  final Value<String> studentId;
  final Value<int> grade;
  final Value<String> subject;
  final Value<String> textbookId;
  final Value<String> textbookTitle;
  final Value<String> feedbackMode;
  final Value<bool> practice;
  final Value<String> chapterIdsJson;
  final Value<String> topicIdsJson;
  final Value<DateTime> startedAt;
  final Value<DateTime> finishedAt;
  final Value<int> total;
  final Value<int> correct;
  final Value<double> percentage;
  final Value<int> timeTakenSec;
  final Value<String> feedback;
  final Value<int> rowid;
  const AttemptsCompanion({
    this.id = const Value.absent(),
    this.schoolId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.grade = const Value.absent(),
    this.subject = const Value.absent(),
    this.textbookId = const Value.absent(),
    this.textbookTitle = const Value.absent(),
    this.feedbackMode = const Value.absent(),
    this.practice = const Value.absent(),
    this.chapterIdsJson = const Value.absent(),
    this.topicIdsJson = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.total = const Value.absent(),
    this.correct = const Value.absent(),
    this.percentage = const Value.absent(),
    this.timeTakenSec = const Value.absent(),
    this.feedback = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttemptsCompanion.insert({
    required String id,
    required String schoolId,
    required String sessionId,
    required String studentId,
    required int grade,
    required String subject,
    required String textbookId,
    this.textbookTitle = const Value.absent(),
    required String feedbackMode,
    this.practice = const Value.absent(),
    this.chapterIdsJson = const Value.absent(),
    this.topicIdsJson = const Value.absent(),
    required DateTime startedAt,
    required DateTime finishedAt,
    required int total,
    required int correct,
    required double percentage,
    required int timeTakenSec,
    this.feedback = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       schoolId = Value(schoolId),
       sessionId = Value(sessionId),
       studentId = Value(studentId),
       grade = Value(grade),
       subject = Value(subject),
       textbookId = Value(textbookId),
       feedbackMode = Value(feedbackMode),
       startedAt = Value(startedAt),
       finishedAt = Value(finishedAt),
       total = Value(total),
       correct = Value(correct),
       percentage = Value(percentage),
       timeTakenSec = Value(timeTakenSec);
  static Insertable<Attempt> custom({
    Expression<String>? id,
    Expression<String>? schoolId,
    Expression<String>? sessionId,
    Expression<String>? studentId,
    Expression<int>? grade,
    Expression<String>? subject,
    Expression<String>? textbookId,
    Expression<String>? textbookTitle,
    Expression<String>? feedbackMode,
    Expression<bool>? practice,
    Expression<String>? chapterIdsJson,
    Expression<String>? topicIdsJson,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? total,
    Expression<int>? correct,
    Expression<double>? percentage,
    Expression<int>? timeTakenSec,
    Expression<String>? feedback,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schoolId != null) 'school_id': schoolId,
      if (sessionId != null) 'session_id': sessionId,
      if (studentId != null) 'student_id': studentId,
      if (grade != null) 'grade': grade,
      if (subject != null) 'subject': subject,
      if (textbookId != null) 'textbook_id': textbookId,
      if (textbookTitle != null) 'textbook_title': textbookTitle,
      if (feedbackMode != null) 'feedback_mode': feedbackMode,
      if (practice != null) 'practice': practice,
      if (chapterIdsJson != null) 'chapter_ids_json': chapterIdsJson,
      if (topicIdsJson != null) 'topic_ids_json': topicIdsJson,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (total != null) 'total': total,
      if (correct != null) 'correct': correct,
      if (percentage != null) 'percentage': percentage,
      if (timeTakenSec != null) 'time_taken_sec': timeTakenSec,
      if (feedback != null) 'feedback': feedback,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttemptsCompanion copyWith({
    Value<String>? id,
    Value<String>? schoolId,
    Value<String>? sessionId,
    Value<String>? studentId,
    Value<int>? grade,
    Value<String>? subject,
    Value<String>? textbookId,
    Value<String>? textbookTitle,
    Value<String>? feedbackMode,
    Value<bool>? practice,
    Value<String>? chapterIdsJson,
    Value<String>? topicIdsJson,
    Value<DateTime>? startedAt,
    Value<DateTime>? finishedAt,
    Value<int>? total,
    Value<int>? correct,
    Value<double>? percentage,
    Value<int>? timeTakenSec,
    Value<String>? feedback,
    Value<int>? rowid,
  }) {
    return AttemptsCompanion(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      textbookId: textbookId ?? this.textbookId,
      textbookTitle: textbookTitle ?? this.textbookTitle,
      feedbackMode: feedbackMode ?? this.feedbackMode,
      practice: practice ?? this.practice,
      chapterIdsJson: chapterIdsJson ?? this.chapterIdsJson,
      topicIdsJson: topicIdsJson ?? this.topicIdsJson,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      total: total ?? this.total,
      correct: correct ?? this.correct,
      percentage: percentage ?? this.percentage,
      timeTakenSec: timeTakenSec ?? this.timeTakenSec,
      feedback: feedback ?? this.feedback,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<String>(schoolId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (textbookId.present) {
      map['textbook_id'] = Variable<String>(textbookId.value);
    }
    if (textbookTitle.present) {
      map['textbook_title'] = Variable<String>(textbookTitle.value);
    }
    if (feedbackMode.present) {
      map['feedback_mode'] = Variable<String>(feedbackMode.value);
    }
    if (practice.present) {
      map['practice'] = Variable<bool>(practice.value);
    }
    if (chapterIdsJson.present) {
      map['chapter_ids_json'] = Variable<String>(chapterIdsJson.value);
    }
    if (topicIdsJson.present) {
      map['topic_ids_json'] = Variable<String>(topicIdsJson.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (timeTakenSec.present) {
      map['time_taken_sec'] = Variable<int>(timeTakenSec.value);
    }
    if (feedback.present) {
      map['feedback'] = Variable<String>(feedback.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsCompanion(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('sessionId: $sessionId, ')
          ..write('studentId: $studentId, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('textbookId: $textbookId, ')
          ..write('textbookTitle: $textbookTitle, ')
          ..write('feedbackMode: $feedbackMode, ')
          ..write('practice: $practice, ')
          ..write('chapterIdsJson: $chapterIdsJson, ')
          ..write('topicIdsJson: $topicIdsJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('total: $total, ')
          ..write('correct: $correct, ')
          ..write('percentage: $percentage, ')
          ..write('timeTakenSec: $timeTakenSec, ')
          ..write('feedback: $feedback, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptAnswersTable extends AttemptAnswers
    with TableInfo<$AttemptAnswersTable, AttemptAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderNoMeta = const VerificationMeta(
    'orderNo',
  );
  @override
  late final GeneratedColumn<int> orderNo = GeneratedColumn<int>(
    'order_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotJsonMeta = const VerificationMeta(
    'snapshotJson',
  );
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
    'snapshot_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedIndexMeta = const VerificationMeta(
    'selectedIndex',
  );
  @override
  late final GeneratedColumn<int> selectedIndex = GeneratedColumn<int>(
    'selected_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctIndexMeta = const VerificationMeta(
    'correctIndex',
  );
  @override
  late final GeneratedColumn<int> correctIndex = GeneratedColumn<int>(
    'correct_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timeSecMeta = const VerificationMeta(
    'timeSec',
  );
  @override
  late final GeneratedColumn<int> timeSec = GeneratedColumn<int>(
    'time_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attemptId,
    studentId,
    questionId,
    chapterId,
    topicId,
    orderNo,
    snapshotJson,
    selectedIndex,
    correctIndex,
    isCorrect,
    timeSec,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempt_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttemptAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('order_no')) {
      context.handle(
        _orderNoMeta,
        orderNo.isAcceptableOrUnknown(data['order_no']!, _orderNoMeta),
      );
    } else if (isInserting) {
      context.missing(_orderNoMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
        _snapshotJsonMeta,
        snapshotJson.isAcceptableOrUnknown(
          data['snapshot_json']!,
          _snapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('selected_index')) {
      context.handle(
        _selectedIndexMeta,
        selectedIndex.isAcceptableOrUnknown(
          data['selected_index']!,
          _selectedIndexMeta,
        ),
      );
    }
    if (data.containsKey('correct_index')) {
      context.handle(
        _correctIndexMeta,
        correctIndex.isAcceptableOrUnknown(
          data['correct_index']!,
          _correctIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctIndexMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('time_sec')) {
      context.handle(
        _timeSecMeta,
        timeSec.isAcceptableOrUnknown(data['time_sec']!, _timeSecMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttemptAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttemptAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      ),
      orderNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_no'],
      )!,
      snapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_json'],
      )!,
      selectedIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_index'],
      ),
      correctIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_index'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      timeSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_sec'],
      )!,
    );
  }

  @override
  $AttemptAnswersTable createAlias(String alias) {
    return $AttemptAnswersTable(attachedDatabase, alias);
  }
}

class AttemptAnswer extends DataClass implements Insertable<AttemptAnswer> {
  final String id;
  final String attemptId;
  final String studentId;
  final String questionId;
  final String chapterId;
  final String? topicId;
  final int orderNo;

  /// Full copy of the question as shown (text, options in shown order,
  /// explanations, chapter/topic titles, page) so history stays readable
  /// even if the question bank or book is edited later.
  final String snapshotJson;

  /// Index the student chose (in shown order); null = skipped.
  final int? selectedIndex;
  final int correctIndex;
  final bool isCorrect;
  final int timeSec;
  const AttemptAnswer({
    required this.id,
    required this.attemptId,
    required this.studentId,
    required this.questionId,
    required this.chapterId,
    this.topicId,
    required this.orderNo,
    required this.snapshotJson,
    this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
    required this.timeSec,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['attempt_id'] = Variable<String>(attemptId);
    map['student_id'] = Variable<String>(studentId);
    map['question_id'] = Variable<String>(questionId);
    map['chapter_id'] = Variable<String>(chapterId);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    map['order_no'] = Variable<int>(orderNo);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    if (!nullToAbsent || selectedIndex != null) {
      map['selected_index'] = Variable<int>(selectedIndex);
    }
    map['correct_index'] = Variable<int>(correctIndex);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['time_sec'] = Variable<int>(timeSec);
    return map;
  }

  AttemptAnswersCompanion toCompanion(bool nullToAbsent) {
    return AttemptAnswersCompanion(
      id: Value(id),
      attemptId: Value(attemptId),
      studentId: Value(studentId),
      questionId: Value(questionId),
      chapterId: Value(chapterId),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      orderNo: Value(orderNo),
      snapshotJson: Value(snapshotJson),
      selectedIndex: selectedIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedIndex),
      correctIndex: Value(correctIndex),
      isCorrect: Value(isCorrect),
      timeSec: Value(timeSec),
    );
  }

  factory AttemptAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttemptAnswer(
      id: serializer.fromJson<String>(json['id']),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      topicId: serializer.fromJson<String?>(json['topicId']),
      orderNo: serializer.fromJson<int>(json['orderNo']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      selectedIndex: serializer.fromJson<int?>(json['selectedIndex']),
      correctIndex: serializer.fromJson<int>(json['correctIndex']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      timeSec: serializer.fromJson<int>(json['timeSec']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'attemptId': serializer.toJson<String>(attemptId),
      'studentId': serializer.toJson<String>(studentId),
      'questionId': serializer.toJson<String>(questionId),
      'chapterId': serializer.toJson<String>(chapterId),
      'topicId': serializer.toJson<String?>(topicId),
      'orderNo': serializer.toJson<int>(orderNo),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'selectedIndex': serializer.toJson<int?>(selectedIndex),
      'correctIndex': serializer.toJson<int>(correctIndex),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'timeSec': serializer.toJson<int>(timeSec),
    };
  }

  AttemptAnswer copyWith({
    String? id,
    String? attemptId,
    String? studentId,
    String? questionId,
    String? chapterId,
    Value<String?> topicId = const Value.absent(),
    int? orderNo,
    String? snapshotJson,
    Value<int?> selectedIndex = const Value.absent(),
    int? correctIndex,
    bool? isCorrect,
    int? timeSec,
  }) => AttemptAnswer(
    id: id ?? this.id,
    attemptId: attemptId ?? this.attemptId,
    studentId: studentId ?? this.studentId,
    questionId: questionId ?? this.questionId,
    chapterId: chapterId ?? this.chapterId,
    topicId: topicId.present ? topicId.value : this.topicId,
    orderNo: orderNo ?? this.orderNo,
    snapshotJson: snapshotJson ?? this.snapshotJson,
    selectedIndex: selectedIndex.present
        ? selectedIndex.value
        : this.selectedIndex,
    correctIndex: correctIndex ?? this.correctIndex,
    isCorrect: isCorrect ?? this.isCorrect,
    timeSec: timeSec ?? this.timeSec,
  );
  AttemptAnswer copyWithCompanion(AttemptAnswersCompanion data) {
    return AttemptAnswer(
      id: data.id.present ? data.id.value : this.id,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      orderNo: data.orderNo.present ? data.orderNo.value : this.orderNo,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      selectedIndex: data.selectedIndex.present
          ? data.selectedIndex.value
          : this.selectedIndex,
      correctIndex: data.correctIndex.present
          ? data.correctIndex.value
          : this.correctIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      timeSec: data.timeSec.present ? data.timeSec.value : this.timeSec,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttemptAnswer(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('studentId: $studentId, ')
          ..write('questionId: $questionId, ')
          ..write('chapterId: $chapterId, ')
          ..write('topicId: $topicId, ')
          ..write('orderNo: $orderNo, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeSec: $timeSec')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    attemptId,
    studentId,
    questionId,
    chapterId,
    topicId,
    orderNo,
    snapshotJson,
    selectedIndex,
    correctIndex,
    isCorrect,
    timeSec,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttemptAnswer &&
          other.id == this.id &&
          other.attemptId == this.attemptId &&
          other.studentId == this.studentId &&
          other.questionId == this.questionId &&
          other.chapterId == this.chapterId &&
          other.topicId == this.topicId &&
          other.orderNo == this.orderNo &&
          other.snapshotJson == this.snapshotJson &&
          other.selectedIndex == this.selectedIndex &&
          other.correctIndex == this.correctIndex &&
          other.isCorrect == this.isCorrect &&
          other.timeSec == this.timeSec);
}

class AttemptAnswersCompanion extends UpdateCompanion<AttemptAnswer> {
  final Value<String> id;
  final Value<String> attemptId;
  final Value<String> studentId;
  final Value<String> questionId;
  final Value<String> chapterId;
  final Value<String?> topicId;
  final Value<int> orderNo;
  final Value<String> snapshotJson;
  final Value<int?> selectedIndex;
  final Value<int> correctIndex;
  final Value<bool> isCorrect;
  final Value<int> timeSec;
  final Value<int> rowid;
  const AttemptAnswersCompanion({
    this.id = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.orderNo = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.selectedIndex = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.timeSec = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttemptAnswersCompanion.insert({
    required String id,
    required String attemptId,
    required String studentId,
    required String questionId,
    required String chapterId,
    this.topicId = const Value.absent(),
    required int orderNo,
    required String snapshotJson,
    this.selectedIndex = const Value.absent(),
    required int correctIndex,
    required bool isCorrect,
    this.timeSec = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       attemptId = Value(attemptId),
       studentId = Value(studentId),
       questionId = Value(questionId),
       chapterId = Value(chapterId),
       orderNo = Value(orderNo),
       snapshotJson = Value(snapshotJson),
       correctIndex = Value(correctIndex),
       isCorrect = Value(isCorrect);
  static Insertable<AttemptAnswer> custom({
    Expression<String>? id,
    Expression<String>? attemptId,
    Expression<String>? studentId,
    Expression<String>? questionId,
    Expression<String>? chapterId,
    Expression<String>? topicId,
    Expression<int>? orderNo,
    Expression<String>? snapshotJson,
    Expression<int>? selectedIndex,
    Expression<int>? correctIndex,
    Expression<bool>? isCorrect,
    Expression<int>? timeSec,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptId != null) 'attempt_id': attemptId,
      if (studentId != null) 'student_id': studentId,
      if (questionId != null) 'question_id': questionId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (topicId != null) 'topic_id': topicId,
      if (orderNo != null) 'order_no': orderNo,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (selectedIndex != null) 'selected_index': selectedIndex,
      if (correctIndex != null) 'correct_index': correctIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (timeSec != null) 'time_sec': timeSec,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttemptAnswersCompanion copyWith({
    Value<String>? id,
    Value<String>? attemptId,
    Value<String>? studentId,
    Value<String>? questionId,
    Value<String>? chapterId,
    Value<String?>? topicId,
    Value<int>? orderNo,
    Value<String>? snapshotJson,
    Value<int?>? selectedIndex,
    Value<int>? correctIndex,
    Value<bool>? isCorrect,
    Value<int>? timeSec,
    Value<int>? rowid,
  }) {
    return AttemptAnswersCompanion(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      studentId: studentId ?? this.studentId,
      questionId: questionId ?? this.questionId,
      chapterId: chapterId ?? this.chapterId,
      topicId: topicId ?? this.topicId,
      orderNo: orderNo ?? this.orderNo,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      correctIndex: correctIndex ?? this.correctIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      timeSec: timeSec ?? this.timeSec,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (orderNo.present) {
      map['order_no'] = Variable<int>(orderNo.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (selectedIndex.present) {
      map['selected_index'] = Variable<int>(selectedIndex.value);
    }
    if (correctIndex.present) {
      map['correct_index'] = Variable<int>(correctIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (timeSec.present) {
      map['time_sec'] = Variable<int>(timeSec.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptAnswersCompanion(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('studentId: $studentId, ')
          ..write('questionId: $questionId, ')
          ..write('chapterId: $chapterId, ')
          ..write('topicId: $topicId, ')
          ..write('orderNo: $orderNo, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeSec: $timeSec, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PapersTable extends Papers with TableInfo<$PapersTable, Paper> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PapersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolIdMeta = const VerificationMeta(
    'schoolId',
  );
  @override
  late final GeneratedColumn<String> schoolId = GeneratedColumn<String>(
    'school_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textbookIdMeta = const VerificationMeta(
    'textbookId',
  );
  @override
  late final GeneratedColumn<String> textbookId = GeneratedColumn<String>(
    'textbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentJsonMeta = const VerificationMeta(
    'contentJson',
  );
  @override
  late final GeneratedColumn<String> contentJson = GeneratedColumn<String>(
    'content_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    schoolId,
    title,
    grade,
    subject,
    textbookId,
    configJson,
    contentJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'papers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Paper> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('school_id')) {
      context.handle(
        _schoolIdMeta,
        schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('textbook_id')) {
      context.handle(
        _textbookIdMeta,
        textbookId.isAcceptableOrUnknown(data['textbook_id']!, _textbookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_textbookIdMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('content_json')) {
      context.handle(
        _contentJsonMeta,
        contentJson.isAcceptableOrUnknown(
          data['content_json']!,
          _contentJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Paper map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paper(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      schoolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      textbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}textbook_id'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
      contentJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PapersTable createAlias(String alias) {
    return $PapersTable(attachedDatabase, alias);
  }
}

class Paper extends DataClass implements Insertable<Paper> {
  final String id;
  final String schoolId;
  final String title;
  final int grade;
  final String subject;
  final String textbookId;
  final String configJson;
  final String contentJson;
  final DateTime createdAt;
  const Paper({
    required this.id,
    required this.schoolId,
    required this.title,
    required this.grade,
    required this.subject,
    required this.textbookId,
    required this.configJson,
    required this.contentJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['school_id'] = Variable<String>(schoolId);
    map['title'] = Variable<String>(title);
    map['grade'] = Variable<int>(grade);
    map['subject'] = Variable<String>(subject);
    map['textbook_id'] = Variable<String>(textbookId);
    map['config_json'] = Variable<String>(configJson);
    map['content_json'] = Variable<String>(contentJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PapersCompanion toCompanion(bool nullToAbsent) {
    return PapersCompanion(
      id: Value(id),
      schoolId: Value(schoolId),
      title: Value(title),
      grade: Value(grade),
      subject: Value(subject),
      textbookId: Value(textbookId),
      configJson: Value(configJson),
      contentJson: Value(contentJson),
      createdAt: Value(createdAt),
    );
  }

  factory Paper.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paper(
      id: serializer.fromJson<String>(json['id']),
      schoolId: serializer.fromJson<String>(json['schoolId']),
      title: serializer.fromJson<String>(json['title']),
      grade: serializer.fromJson<int>(json['grade']),
      subject: serializer.fromJson<String>(json['subject']),
      textbookId: serializer.fromJson<String>(json['textbookId']),
      configJson: serializer.fromJson<String>(json['configJson']),
      contentJson: serializer.fromJson<String>(json['contentJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'schoolId': serializer.toJson<String>(schoolId),
      'title': serializer.toJson<String>(title),
      'grade': serializer.toJson<int>(grade),
      'subject': serializer.toJson<String>(subject),
      'textbookId': serializer.toJson<String>(textbookId),
      'configJson': serializer.toJson<String>(configJson),
      'contentJson': serializer.toJson<String>(contentJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Paper copyWith({
    String? id,
    String? schoolId,
    String? title,
    int? grade,
    String? subject,
    String? textbookId,
    String? configJson,
    String? contentJson,
    DateTime? createdAt,
  }) => Paper(
    id: id ?? this.id,
    schoolId: schoolId ?? this.schoolId,
    title: title ?? this.title,
    grade: grade ?? this.grade,
    subject: subject ?? this.subject,
    textbookId: textbookId ?? this.textbookId,
    configJson: configJson ?? this.configJson,
    contentJson: contentJson ?? this.contentJson,
    createdAt: createdAt ?? this.createdAt,
  );
  Paper copyWithCompanion(PapersCompanion data) {
    return Paper(
      id: data.id.present ? data.id.value : this.id,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
      title: data.title.present ? data.title.value : this.title,
      grade: data.grade.present ? data.grade.value : this.grade,
      subject: data.subject.present ? data.subject.value : this.subject,
      textbookId: data.textbookId.present
          ? data.textbookId.value
          : this.textbookId,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
      contentJson: data.contentJson.present
          ? data.contentJson.value
          : this.contentJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paper(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('title: $title, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('textbookId: $textbookId, ')
          ..write('configJson: $configJson, ')
          ..write('contentJson: $contentJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    schoolId,
    title,
    grade,
    subject,
    textbookId,
    configJson,
    contentJson,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paper &&
          other.id == this.id &&
          other.schoolId == this.schoolId &&
          other.title == this.title &&
          other.grade == this.grade &&
          other.subject == this.subject &&
          other.textbookId == this.textbookId &&
          other.configJson == this.configJson &&
          other.contentJson == this.contentJson &&
          other.createdAt == this.createdAt);
}

class PapersCompanion extends UpdateCompanion<Paper> {
  final Value<String> id;
  final Value<String> schoolId;
  final Value<String> title;
  final Value<int> grade;
  final Value<String> subject;
  final Value<String> textbookId;
  final Value<String> configJson;
  final Value<String> contentJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PapersCompanion({
    this.id = const Value.absent(),
    this.schoolId = const Value.absent(),
    this.title = const Value.absent(),
    this.grade = const Value.absent(),
    this.subject = const Value.absent(),
    this.textbookId = const Value.absent(),
    this.configJson = const Value.absent(),
    this.contentJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PapersCompanion.insert({
    required String id,
    required String schoolId,
    required String title,
    required int grade,
    required String subject,
    required String textbookId,
    required String configJson,
    required String contentJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       schoolId = Value(schoolId),
       title = Value(title),
       grade = Value(grade),
       subject = Value(subject),
       textbookId = Value(textbookId),
       configJson = Value(configJson),
       contentJson = Value(contentJson),
       createdAt = Value(createdAt);
  static Insertable<Paper> custom({
    Expression<String>? id,
    Expression<String>? schoolId,
    Expression<String>? title,
    Expression<int>? grade,
    Expression<String>? subject,
    Expression<String>? textbookId,
    Expression<String>? configJson,
    Expression<String>? contentJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schoolId != null) 'school_id': schoolId,
      if (title != null) 'title': title,
      if (grade != null) 'grade': grade,
      if (subject != null) 'subject': subject,
      if (textbookId != null) 'textbook_id': textbookId,
      if (configJson != null) 'config_json': configJson,
      if (contentJson != null) 'content_json': contentJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PapersCompanion copyWith({
    Value<String>? id,
    Value<String>? schoolId,
    Value<String>? title,
    Value<int>? grade,
    Value<String>? subject,
    Value<String>? textbookId,
    Value<String>? configJson,
    Value<String>? contentJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PapersCompanion(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      title: title ?? this.title,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      textbookId: textbookId ?? this.textbookId,
      configJson: configJson ?? this.configJson,
      contentJson: contentJson ?? this.contentJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<String>(schoolId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (textbookId.present) {
      map['textbook_id'] = Variable<String>(textbookId.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (contentJson.present) {
      map['content_json'] = Variable<String>(contentJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PapersCompanion(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('title: $title, ')
          ..write('grade: $grade, ')
          ..write('subject: $subject, ')
          ..write('textbookId: $textbookId, ')
          ..write('configJson: $configJson, ')
          ..write('contentJson: $contentJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _triesMeta = const VerificationMeta('tries');
  @override
  late final GeneratedColumn<int> tries = GeneratedColumn<int>(
    'tries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    entityId,
    op,
    createdAt,
    status,
    tries,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('tries')) {
      context.handle(
        _triesMeta,
        tries.isAcceptableOrUnknown(data['tries']!, _triesMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      tries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tries'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncItem extends DataClass implements Insertable<SyncItem> {
  final int id;
  final String entity;
  final String entityId;

  /// upsert | delete
  final String op;
  final DateTime createdAt;

  /// pending | failed | done
  final String status;
  final int tries;
  final String lastError;
  const SyncItem({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.createdAt,
    required this.status,
    required this.tries,
    required this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['tries'] = Variable<int>(tries);
    map['last_error'] = Variable<String>(lastError);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      createdAt: Value(createdAt),
      status: Value(status),
      tries: Value(tries),
      lastError: Value(lastError),
    );
  }

  factory SyncItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncItem(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      tries: serializer.fromJson<int>(json['tries']),
      lastError: serializer.fromJson<String>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'tries': serializer.toJson<int>(tries),
      'lastError': serializer.toJson<String>(lastError),
    };
  }

  SyncItem copyWith({
    int? id,
    String? entity,
    String? entityId,
    String? op,
    DateTime? createdAt,
    String? status,
    int? tries,
    String? lastError,
  }) => SyncItem(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    tries: tries ?? this.tries,
    lastError: lastError ?? this.lastError,
  );
  SyncItem copyWithCompanion(SyncQueueCompanion data) {
    return SyncItem(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      tries: data.tries.present ? data.tries.value : this.tries,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncItem(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('tries: $tries, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entity,
    entityId,
    op,
    createdAt,
    status,
    tries,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncItem &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.tries == this.tries &&
          other.lastError == this.lastError);
}

class SyncQueueCompanion extends UpdateCompanion<SyncItem> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> tries;
  final Value<String> lastError;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.tries = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    required String entityId,
    required String op,
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.tries = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       createdAt = Value(createdAt);
  static Insertable<SyncItem> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? tries,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (tries != null) 'tries': tries,
      if (lastError != null) 'last_error': lastError,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? tries,
    Value<String>? lastError,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      tries: tries ?? this.tries,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tries.present) {
      map['tries'] = Variable<int>(tries.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('tries: $tries, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SchoolsTable schools = $SchoolsTable(this);
  late final $TeachersTable teachers = $TeachersTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $TextbooksTable textbooks = $TextbooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $TopicsTable topics = $TopicsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $AttemptsTable attempts = $AttemptsTable(this);
  late final $AttemptAnswersTable attemptAnswers = $AttemptAnswersTable(this);
  late final $PapersTable papers = $PapersTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    schools,
    teachers,
    students,
    textbooks,
    chapters,
    topics,
    questions,
    attempts,
    attemptAnswers,
    papers,
    syncQueue,
    appSettings,
  ];
}

typedef $$SchoolsTableCreateCompanionBuilder = SchoolsCompanion Function({
  required String id,
  Value<String> name,
  Value<String> district,
  Value<String> tehsil,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SchoolsTableUpdateCompanionBuilder = SchoolsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> district,
  Value<String> tehsil,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SchoolsTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tehsil => $composableBuilder(
    column: $table.tehsil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchoolsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tehsil => $composableBuilder(
    column: $table.tehsil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get tehsil =>
      $composableBuilder(column: $table.tehsil, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SchoolsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolsTable,
          School,
          $$SchoolsTableFilterComposer,
          $$SchoolsTableOrderingComposer,
          $$SchoolsTableAnnotationComposer,
          $$SchoolsTableCreateCompanionBuilder,
          $$SchoolsTableUpdateCompanionBuilder,
          (School, BaseReferences<_$AppDatabase, $SchoolsTable, School>),
          School,
          PrefetchHooks Function()
        > {
  $$SchoolsTableTableManager(_$AppDatabase db, $SchoolsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> district = const Value.absent(),
                Value<String> tehsil = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchoolsCompanion(
                id: id,
                name: name,
                district: district,
                tehsil: tehsil,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> name = const Value.absent(),
                Value<String> district = const Value.absent(),
                Value<String> tehsil = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SchoolsCompanion.insert(
                id: id,
                name: name,
                district: district,
                tehsil: tehsil,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SchoolsTable, School>(table),
                  BaseReferences<_$AppDatabase, $SchoolsTable, School>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchoolsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolsTable,
      School,
      $$SchoolsTableFilterComposer,
      $$SchoolsTableOrderingComposer,
      $$SchoolsTableAnnotationComposer,
      $$SchoolsTableCreateCompanionBuilder,
      $$SchoolsTableUpdateCompanionBuilder,
      (School, BaseReferences<_$AppDatabase, $SchoolsTable, School>),
      School,
      PrefetchHooks Function()
    >;
typedef $$TeachersTableCreateCompanionBuilder = TeachersCompanion Function({
  required String id,
  required String schoolId,
  Value<String> name,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TeachersTableUpdateCompanionBuilder = TeachersCompanion Function({
  Value<String> id,
  Value<String> schoolId,
  Value<String> name,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TeachersTableFilterComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TeachersTableOrderingComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeachersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get schoolId =>
      $composableBuilder(column: $table.schoolId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TeachersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeachersTable,
          Teacher,
          $$TeachersTableFilterComposer,
          $$TeachersTableOrderingComposer,
          $$TeachersTableAnnotationComposer,
          $$TeachersTableCreateCompanionBuilder,
          $$TeachersTableUpdateCompanionBuilder,
          (Teacher, BaseReferences<_$AppDatabase, $TeachersTable, Teacher>),
          Teacher,
          PrefetchHooks Function()
        > {
  $$TeachersTableTableManager(_$AppDatabase db, $TeachersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeachersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeachersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeachersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> schoolId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeachersCompanion(
                id: id,
                schoolId: schoolId,
                name: name,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String schoolId,
                Value<String> name = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TeachersCompanion.insert(
                id: id,
                schoolId: schoolId,
                name: name,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TeachersTable, Teacher>(table),
                  BaseReferences<_$AppDatabase, $TeachersTable, Teacher>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TeachersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeachersTable,
      Teacher,
      $$TeachersTableFilterComposer,
      $$TeachersTableOrderingComposer,
      $$TeachersTableAnnotationComposer,
      $$TeachersTableCreateCompanionBuilder,
      $$TeachersTableUpdateCompanionBuilder,
      (Teacher, BaseReferences<_$AppDatabase, $TeachersTable, Teacher>),
      Teacher,
      PrefetchHooks Function()
    >;
typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  required String id,
  required String schoolId,
  required String code,
  Value<String> name,
  Value<String> rollNo,
  required int grade,
  Value<String> section,
  Value<String> academicYear,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<String> id,
  Value<String> schoolId,
  Value<String> code,
  Value<String> name,
  Value<String> rollNo,
  Value<int> grade,
  Value<String> section,
  Value<String> academicYear,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<int> rowid,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rollNo => $composableBuilder(
    column: $table.rollNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rollNo => $composableBuilder(
    column: $table.rollNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get schoolId =>
      $composableBuilder(column: $table.schoolId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get rollNo =>
      $composableBuilder(column: $table.rollNo, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
          Student,
          PrefetchHooks Function()
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> schoolId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> rollNo = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> section = const Value.absent(),
                Value<String> academicYear = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                schoolId: schoolId,
                code: code,
                name: name,
                rollNo: rollNo,
                grade: grade,
                section: section,
                academicYear: academicYear,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String schoolId,
                required String code,
                Value<String> name = const Value.absent(),
                Value<String> rollNo = const Value.absent(),
                required int grade,
                Value<String> section = const Value.absent(),
                Value<String> academicYear = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                schoolId: schoolId,
                code: code,
                name: name,
                rollNo: rollNo,
                grade: grade,
                section: section,
                academicYear: academicYear,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudentsTable, Student>(table),
                  BaseReferences<_$AppDatabase, $StudentsTable, Student>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
      Student,
      PrefetchHooks Function()
    >;
typedef $$TextbooksTableCreateCompanionBuilder = TextbooksCompanion Function({
  required String id,
  required String seriesId,
  Value<int> version,
  Value<bool> isCurrent,
  Value<bool> isApplicable,
  required int grade,
  required String subject,
  required String title,
  Value<String> academicYear,
  Value<String> edition,
  Value<String> publisher,
  Value<String> language,
  required String sourceType,
  Value<String> sourceUrl,
  Value<String?> filePath,
  Value<String?> fileSha256,
  Value<int?> fileSize,
  required DateTime importedAt,
  Value<String> notes,
  Value<String?> remoteFile,
  Value<int?> remoteBytes,
  Value<int> rowid,
});
typedef $$TextbooksTableUpdateCompanionBuilder = TextbooksCompanion Function({
  Value<String> id,
  Value<String> seriesId,
  Value<int> version,
  Value<bool> isCurrent,
  Value<bool> isApplicable,
  Value<int> grade,
  Value<String> subject,
  Value<String> title,
  Value<String> academicYear,
  Value<String> edition,
  Value<String> publisher,
  Value<String> language,
  Value<String> sourceType,
  Value<String> sourceUrl,
  Value<String?> filePath,
  Value<String?> fileSha256,
  Value<int?> fileSize,
  Value<DateTime> importedAt,
  Value<String> notes,
  Value<String?> remoteFile,
  Value<int?> remoteBytes,
  Value<int> rowid,
});

class $$TextbooksTableFilterComposer
    extends Composer<_$AppDatabase, $TextbooksTable> {
  $$TextbooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seriesId => $composableBuilder(
    column: $table.seriesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isApplicable => $composableBuilder(
    column: $table.isApplicable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileSha256 => $composableBuilder(
    column: $table.fileSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteFile => $composableBuilder(
    column: $table.remoteFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteBytes => $composableBuilder(
    column: $table.remoteBytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TextbooksTableOrderingComposer
    extends Composer<_$AppDatabase, $TextbooksTable> {
  $$TextbooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesId => $composableBuilder(
    column: $table.seriesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isApplicable => $composableBuilder(
    column: $table.isApplicable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileSha256 => $composableBuilder(
    column: $table.fileSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteFile => $composableBuilder(
    column: $table.remoteFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteBytes => $composableBuilder(
    column: $table.remoteBytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TextbooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TextbooksTable> {
  $$TextbooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get seriesId =>
      $composableBuilder(column: $table.seriesId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);

  GeneratedColumn<bool> get isApplicable => $composableBuilder(
    column: $table.isApplicable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get edition =>
      $composableBuilder(column: $table.edition, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileSha256 => $composableBuilder(
    column: $table.fileSha256,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get remoteFile => $composableBuilder(
    column: $table.remoteFile,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remoteBytes => $composableBuilder(
    column: $table.remoteBytes,
    builder: (column) => column,
  );
}

class $$TextbooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TextbooksTable,
          Textbook,
          $$TextbooksTableFilterComposer,
          $$TextbooksTableOrderingComposer,
          $$TextbooksTableAnnotationComposer,
          $$TextbooksTableCreateCompanionBuilder,
          $$TextbooksTableUpdateCompanionBuilder,
          (Textbook, BaseReferences<_$AppDatabase, $TextbooksTable, Textbook>),
          Textbook,
          PrefetchHooks Function()
        > {
  $$TextbooksTableTableManager(_$AppDatabase db, $TextbooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextbooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TextbooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextbooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> seriesId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<bool> isApplicable = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> academicYear = const Value.absent(),
                Value<String> edition = const Value.absent(),
                Value<String> publisher = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> fileSha256 = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> remoteFile = const Value.absent(),
                Value<int?> remoteBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TextbooksCompanion(
                id: id,
                seriesId: seriesId,
                version: version,
                isCurrent: isCurrent,
                isApplicable: isApplicable,
                grade: grade,
                subject: subject,
                title: title,
                academicYear: academicYear,
                edition: edition,
                publisher: publisher,
                language: language,
                sourceType: sourceType,
                sourceUrl: sourceUrl,
                filePath: filePath,
                fileSha256: fileSha256,
                fileSize: fileSize,
                importedAt: importedAt,
                notes: notes,
                remoteFile: remoteFile,
                remoteBytes: remoteBytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String seriesId,
                Value<int> version = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<bool> isApplicable = const Value.absent(),
                required int grade,
                required String subject,
                required String title,
                Value<String> academicYear = const Value.absent(),
                Value<String> edition = const Value.absent(),
                Value<String> publisher = const Value.absent(),
                Value<String> language = const Value.absent(),
                required String sourceType,
                Value<String> sourceUrl = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> fileSha256 = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                required DateTime importedAt,
                Value<String> notes = const Value.absent(),
                Value<String?> remoteFile = const Value.absent(),
                Value<int?> remoteBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TextbooksCompanion.insert(
                id: id,
                seriesId: seriesId,
                version: version,
                isCurrent: isCurrent,
                isApplicable: isApplicable,
                grade: grade,
                subject: subject,
                title: title,
                academicYear: academicYear,
                edition: edition,
                publisher: publisher,
                language: language,
                sourceType: sourceType,
                sourceUrl: sourceUrl,
                filePath: filePath,
                fileSha256: fileSha256,
                fileSize: fileSize,
                importedAt: importedAt,
                notes: notes,
                remoteFile: remoteFile,
                remoteBytes: remoteBytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TextbooksTable, Textbook>(table),
                  BaseReferences<_$AppDatabase, $TextbooksTable, Textbook>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TextbooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TextbooksTable,
      Textbook,
      $$TextbooksTableFilterComposer,
      $$TextbooksTableOrderingComposer,
      $$TextbooksTableAnnotationComposer,
      $$TextbooksTableCreateCompanionBuilder,
      $$TextbooksTableUpdateCompanionBuilder,
      (Textbook, BaseReferences<_$AppDatabase, $TextbooksTable, Textbook>),
      Textbook,
      PrefetchHooks Function()
    >;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  required String id,
  required String textbookId,
  required int number,
  required String title,
  Value<int?> pageStart,
  Value<int?> pageEnd,
  Value<int> rowid,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<String> id,
  Value<String> textbookId,
  Value<int> number,
  Value<String> title,
  Value<int?> pageStart,
  Value<int?> pageEnd,
  Value<int> rowid,
});

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageStart => $composableBuilder(
    column: $table.pageStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageEnd => $composableBuilder(
    column: $table.pageEnd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageStart => $composableBuilder(
    column: $table.pageStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageEnd => $composableBuilder(
    column: $table.pageEnd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get pageStart =>
      $composableBuilder(column: $table.pageStart, builder: (column) => column);

  GeneratedColumn<int> get pageEnd =>
      $composableBuilder(column: $table.pageEnd, builder: (column) => column);
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>),
          Chapter,
          PrefetchHooks Function()
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> textbookId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> pageStart = const Value.absent(),
                Value<int?> pageEnd = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                textbookId: textbookId,
                number: number,
                title: title,
                pageStart: pageStart,
                pageEnd: pageEnd,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String textbookId,
                required int number,
                required String title,
                Value<int?> pageStart = const Value.absent(),
                Value<int?> pageEnd = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                textbookId: textbookId,
                number: number,
                title: title,
                pageStart: pageStart,
                pageEnd: pageEnd,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChaptersTable, Chapter>(table),
                  BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>),
      Chapter,
      PrefetchHooks Function()
    >;
typedef $$TopicsTableCreateCompanionBuilder = TopicsCompanion Function({
  required String id,
  required String chapterId,
  Value<int> orderNo,
  required String title,
  Value<int?> pageStart,
  Value<int?> pageEnd,
  Value<int> rowid,
});
typedef $$TopicsTableUpdateCompanionBuilder = TopicsCompanion Function({
  Value<String> id,
  Value<String> chapterId,
  Value<int> orderNo,
  Value<String> title,
  Value<int?> pageStart,
  Value<int?> pageEnd,
  Value<int> rowid,
});

class $$TopicsTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageStart => $composableBuilder(
    column: $table.pageStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageEnd => $composableBuilder(
    column: $table.pageEnd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageStart => $composableBuilder(
    column: $table.pageStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageEnd => $composableBuilder(
    column: $table.pageEnd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<int> get orderNo =>
      $composableBuilder(column: $table.orderNo, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get pageStart =>
      $composableBuilder(column: $table.pageStart, builder: (column) => column);

  GeneratedColumn<int> get pageEnd =>
      $composableBuilder(column: $table.pageEnd, builder: (column) => column);
}

class $$TopicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TopicsTable,
          Topic,
          $$TopicsTableFilterComposer,
          $$TopicsTableOrderingComposer,
          $$TopicsTableAnnotationComposer,
          $$TopicsTableCreateCompanionBuilder,
          $$TopicsTableUpdateCompanionBuilder,
          (Topic, BaseReferences<_$AppDatabase, $TopicsTable, Topic>),
          Topic,
          PrefetchHooks Function()
        > {
  $$TopicsTableTableManager(_$AppDatabase db, $TopicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<int> orderNo = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> pageStart = const Value.absent(),
                Value<int?> pageEnd = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion(
                id: id,
                chapterId: chapterId,
                orderNo: orderNo,
                title: title,
                pageStart: pageStart,
                pageEnd: pageEnd,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                Value<int> orderNo = const Value.absent(),
                required String title,
                Value<int?> pageStart = const Value.absent(),
                Value<int?> pageEnd = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion.insert(
                id: id,
                chapterId: chapterId,
                orderNo: orderNo,
                title: title,
                pageStart: pageStart,
                pageEnd: pageEnd,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TopicsTable, Topic>(table),
                  BaseReferences<_$AppDatabase, $TopicsTable, Topic>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TopicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TopicsTable,
      Topic,
      $$TopicsTableFilterComposer,
      $$TopicsTableOrderingComposer,
      $$TopicsTableAnnotationComposer,
      $$TopicsTableCreateCompanionBuilder,
      $$TopicsTableUpdateCompanionBuilder,
      (Topic, BaseReferences<_$AppDatabase, $TopicsTable, Topic>),
      Topic,
      PrefetchHooks Function()
    >;
typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  required String id,
  required String textbookId,
  required String chapterId,
  Value<String?> topicId,
  required int grade,
  required String subject,
  required String type,
  required String body,
  Value<String> optionsJson,
  Value<int?> correctIndex,
  Value<String> answer,
  Value<String> shortExplanation,
  Value<String> conceptExplanation,
  Value<int?> pageRef,
  Value<int> difficulty,
  Value<String> source,
  Value<String> reviewNote,
  Value<bool> verified,
  Value<String> language,
  required DateTime createdAt,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<String> id,
  Value<String> textbookId,
  Value<String> chapterId,
  Value<String?> topicId,
  Value<int> grade,
  Value<String> subject,
  Value<String> type,
  Value<String> body,
  Value<String> optionsJson,
  Value<int?> correctIndex,
  Value<String> answer,
  Value<String> shortExplanation,
  Value<String> conceptExplanation,
  Value<int?> pageRef,
  Value<int> difficulty,
  Value<String> source,
  Value<String> reviewNote,
  Value<bool> verified,
  Value<String> language,
  Value<DateTime> createdAt,
  Value<bool> deleted,
  Value<int> rowid,
});

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortExplanation => $composableBuilder(
    column: $table.shortExplanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conceptExplanation => $composableBuilder(
    column: $table.conceptExplanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageRef => $composableBuilder(
    column: $table.pageRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortExplanation => $composableBuilder(
    column: $table.shortExplanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conceptExplanation => $composableBuilder(
    column: $table.conceptExplanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageRef => $composableBuilder(
    column: $table.pageRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get shortExplanation => $composableBuilder(
    column: $table.shortExplanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conceptExplanation => $composableBuilder(
    column: $table.conceptExplanation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageRef =>
      $composableBuilder(column: $table.pageRef, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
          Question,
          PrefetchHooks Function()
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> textbookId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String?> topicId = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> optionsJson = const Value.absent(),
                Value<int?> correctIndex = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<String> shortExplanation = const Value.absent(),
                Value<String> conceptExplanation = const Value.absent(),
                Value<int?> pageRef = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> reviewNote = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                textbookId: textbookId,
                chapterId: chapterId,
                topicId: topicId,
                grade: grade,
                subject: subject,
                type: type,
                body: body,
                optionsJson: optionsJson,
                correctIndex: correctIndex,
                answer: answer,
                shortExplanation: shortExplanation,
                conceptExplanation: conceptExplanation,
                pageRef: pageRef,
                difficulty: difficulty,
                source: source,
                reviewNote: reviewNote,
                verified: verified,
                language: language,
                createdAt: createdAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String textbookId,
                required String chapterId,
                Value<String?> topicId = const Value.absent(),
                required int grade,
                required String subject,
                required String type,
                required String body,
                Value<String> optionsJson = const Value.absent(),
                Value<int?> correctIndex = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<String> shortExplanation = const Value.absent(),
                Value<String> conceptExplanation = const Value.absent(),
                Value<int?> pageRef = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> reviewNote = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String> language = const Value.absent(),
                required DateTime createdAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                textbookId: textbookId,
                chapterId: chapterId,
                topicId: topicId,
                grade: grade,
                subject: subject,
                type: type,
                body: body,
                optionsJson: optionsJson,
                correctIndex: correctIndex,
                answer: answer,
                shortExplanation: shortExplanation,
                conceptExplanation: conceptExplanation,
                pageRef: pageRef,
                difficulty: difficulty,
                source: source,
                reviewNote: reviewNote,
                verified: verified,
                language: language,
                createdAt: createdAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestionsTable, Question>(table),
                  BaseReferences<_$AppDatabase, $QuestionsTable, Question>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
      Question,
      PrefetchHooks Function()
    >;
typedef $$AttemptsTableCreateCompanionBuilder = AttemptsCompanion Function({
  required String id,
  required String schoolId,
  required String sessionId,
  required String studentId,
  required int grade,
  required String subject,
  required String textbookId,
  Value<String> textbookTitle,
  required String feedbackMode,
  Value<bool> practice,
  Value<String> chapterIdsJson,
  Value<String> topicIdsJson,
  required DateTime startedAt,
  required DateTime finishedAt,
  required int total,
  required int correct,
  required double percentage,
  required int timeTakenSec,
  Value<String> feedback,
  Value<int> rowid,
});
typedef $$AttemptsTableUpdateCompanionBuilder = AttemptsCompanion Function({
  Value<String> id,
  Value<String> schoolId,
  Value<String> sessionId,
  Value<String> studentId,
  Value<int> grade,
  Value<String> subject,
  Value<String> textbookId,
  Value<String> textbookTitle,
  Value<String> feedbackMode,
  Value<bool> practice,
  Value<String> chapterIdsJson,
  Value<String> topicIdsJson,
  Value<DateTime> startedAt,
  Value<DateTime> finishedAt,
  Value<int> total,
  Value<int> correct,
  Value<double> percentage,
  Value<int> timeTakenSec,
  Value<String> feedback,
  Value<int> rowid,
});

class $$AttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textbookTitle => $composableBuilder(
    column: $table.textbookTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedbackMode => $composableBuilder(
    column: $table.feedbackMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get practice => $composableBuilder(
    column: $table.practice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterIdsJson => $composableBuilder(
    column: $table.chapterIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicIdsJson => $composableBuilder(
    column: $table.topicIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeTakenSec => $composableBuilder(
    column: $table.timeTakenSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textbookTitle => $composableBuilder(
    column: $table.textbookTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedbackMode => $composableBuilder(
    column: $table.feedbackMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get practice => $composableBuilder(
    column: $table.practice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterIdsJson => $composableBuilder(
    column: $table.chapterIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicIdsJson => $composableBuilder(
    column: $table.topicIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeTakenSec => $composableBuilder(
    column: $table.timeTakenSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get schoolId =>
      $composableBuilder(column: $table.schoolId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textbookTitle => $composableBuilder(
    column: $table.textbookTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get feedbackMode => $composableBuilder(
    column: $table.feedbackMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get practice =>
      $composableBuilder(column: $table.practice, builder: (column) => column);

  GeneratedColumn<String> get chapterIdsJson => $composableBuilder(
    column: $table.chapterIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topicIdsJson => $composableBuilder(
    column: $table.topicIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeTakenSec => $composableBuilder(
    column: $table.timeTakenSec,
    builder: (column) => column,
  );

  GeneratedColumn<String> get feedback =>
      $composableBuilder(column: $table.feedback, builder: (column) => column);
}

class $$AttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptsTable,
          Attempt,
          $$AttemptsTableFilterComposer,
          $$AttemptsTableOrderingComposer,
          $$AttemptsTableAnnotationComposer,
          $$AttemptsTableCreateCompanionBuilder,
          $$AttemptsTableUpdateCompanionBuilder,
          (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
          Attempt,
          PrefetchHooks Function()
        > {
  $$AttemptsTableTableManager(_$AppDatabase db, $AttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> schoolId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> textbookId = const Value.absent(),
                Value<String> textbookTitle = const Value.absent(),
                Value<String> feedbackMode = const Value.absent(),
                Value<bool> practice = const Value.absent(),
                Value<String> chapterIdsJson = const Value.absent(),
                Value<String> topicIdsJson = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> finishedAt = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<double> percentage = const Value.absent(),
                Value<int> timeTakenSec = const Value.absent(),
                Value<String> feedback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptsCompanion(
                id: id,
                schoolId: schoolId,
                sessionId: sessionId,
                studentId: studentId,
                grade: grade,
                subject: subject,
                textbookId: textbookId,
                textbookTitle: textbookTitle,
                feedbackMode: feedbackMode,
                practice: practice,
                chapterIdsJson: chapterIdsJson,
                topicIdsJson: topicIdsJson,
                startedAt: startedAt,
                finishedAt: finishedAt,
                total: total,
                correct: correct,
                percentage: percentage,
                timeTakenSec: timeTakenSec,
                feedback: feedback,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String schoolId,
                required String sessionId,
                required String studentId,
                required int grade,
                required String subject,
                required String textbookId,
                Value<String> textbookTitle = const Value.absent(),
                required String feedbackMode,
                Value<bool> practice = const Value.absent(),
                Value<String> chapterIdsJson = const Value.absent(),
                Value<String> topicIdsJson = const Value.absent(),
                required DateTime startedAt,
                required DateTime finishedAt,
                required int total,
                required int correct,
                required double percentage,
                required int timeTakenSec,
                Value<String> feedback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptsCompanion.insert(
                id: id,
                schoolId: schoolId,
                sessionId: sessionId,
                studentId: studentId,
                grade: grade,
                subject: subject,
                textbookId: textbookId,
                textbookTitle: textbookTitle,
                feedbackMode: feedbackMode,
                practice: practice,
                chapterIdsJson: chapterIdsJson,
                topicIdsJson: topicIdsJson,
                startedAt: startedAt,
                finishedAt: finishedAt,
                total: total,
                correct: correct,
                percentage: percentage,
                timeTakenSec: timeTakenSec,
                feedback: feedback,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttemptsTable, Attempt>(table),
                  BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptsTable,
      Attempt,
      $$AttemptsTableFilterComposer,
      $$AttemptsTableOrderingComposer,
      $$AttemptsTableAnnotationComposer,
      $$AttemptsTableCreateCompanionBuilder,
      $$AttemptsTableUpdateCompanionBuilder,
      (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
      Attempt,
      PrefetchHooks Function()
    >;
typedef $$AttemptAnswersTableCreateCompanionBuilder =
    AttemptAnswersCompanion Function({
      required String id,
      required String attemptId,
      required String studentId,
      required String questionId,
      required String chapterId,
      Value<String?> topicId,
      required int orderNo,
      required String snapshotJson,
      Value<int?> selectedIndex,
      required int correctIndex,
      required bool isCorrect,
      Value<int> timeSec,
      Value<int> rowid,
    });
typedef $$AttemptAnswersTableUpdateCompanionBuilder =
    AttemptAnswersCompanion Function({
      Value<String> id,
      Value<String> attemptId,
      Value<String> studentId,
      Value<String> questionId,
      Value<String> chapterId,
      Value<String?> topicId,
      Value<int> orderNo,
      Value<String> snapshotJson,
      Value<int?> selectedIndex,
      Value<int> correctIndex,
      Value<bool> isCorrect,
      Value<int> timeSec,
      Value<int> rowid,
    });

class $$AttemptAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptAnswersTable> {
  $$AttemptAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSec => $composableBuilder(
    column: $table.timeSec,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttemptAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptAnswersTable> {
  $$AttemptAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSec => $composableBuilder(
    column: $table.timeSec,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttemptAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptAnswersTable> {
  $$AttemptAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<int> get orderNo =>
      $composableBuilder(column: $table.orderNo, builder: (column) => column);

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<int> get timeSec =>
      $composableBuilder(column: $table.timeSec, builder: (column) => column);
}

class $$AttemptAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptAnswersTable,
          AttemptAnswer,
          $$AttemptAnswersTableFilterComposer,
          $$AttemptAnswersTableOrderingComposer,
          $$AttemptAnswersTableAnnotationComposer,
          $$AttemptAnswersTableCreateCompanionBuilder,
          $$AttemptAnswersTableUpdateCompanionBuilder,
          (
            AttemptAnswer,
            BaseReferences<_$AppDatabase, $AttemptAnswersTable, AttemptAnswer>,
          ),
          AttemptAnswer,
          PrefetchHooks Function()
        > {
  $$AttemptAnswersTableTableManager(
    _$AppDatabase db,
    $AttemptAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String?> topicId = const Value.absent(),
                Value<int> orderNo = const Value.absent(),
                Value<String> snapshotJson = const Value.absent(),
                Value<int?> selectedIndex = const Value.absent(),
                Value<int> correctIndex = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> timeSec = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptAnswersCompanion(
                id: id,
                attemptId: attemptId,
                studentId: studentId,
                questionId: questionId,
                chapterId: chapterId,
                topicId: topicId,
                orderNo: orderNo,
                snapshotJson: snapshotJson,
                selectedIndex: selectedIndex,
                correctIndex: correctIndex,
                isCorrect: isCorrect,
                timeSec: timeSec,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String attemptId,
                required String studentId,
                required String questionId,
                required String chapterId,
                Value<String?> topicId = const Value.absent(),
                required int orderNo,
                required String snapshotJson,
                Value<int?> selectedIndex = const Value.absent(),
                required int correctIndex,
                required bool isCorrect,
                Value<int> timeSec = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptAnswersCompanion.insert(
                id: id,
                attemptId: attemptId,
                studentId: studentId,
                questionId: questionId,
                chapterId: chapterId,
                topicId: topicId,
                orderNo: orderNo,
                snapshotJson: snapshotJson,
                selectedIndex: selectedIndex,
                correctIndex: correctIndex,
                isCorrect: isCorrect,
                timeSec: timeSec,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttemptAnswersTable, AttemptAnswer>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AttemptAnswersTable,
                    AttemptAnswer
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttemptAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptAnswersTable,
      AttemptAnswer,
      $$AttemptAnswersTableFilterComposer,
      $$AttemptAnswersTableOrderingComposer,
      $$AttemptAnswersTableAnnotationComposer,
      $$AttemptAnswersTableCreateCompanionBuilder,
      $$AttemptAnswersTableUpdateCompanionBuilder,
      (
        AttemptAnswer,
        BaseReferences<_$AppDatabase, $AttemptAnswersTable, AttemptAnswer>,
      ),
      AttemptAnswer,
      PrefetchHooks Function()
    >;
typedef $$PapersTableCreateCompanionBuilder = PapersCompanion Function({
  required String id,
  required String schoolId,
  required String title,
  required int grade,
  required String subject,
  required String textbookId,
  required String configJson,
  required String contentJson,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PapersTableUpdateCompanionBuilder = PapersCompanion Function({
  Value<String> id,
  Value<String> schoolId,
  Value<String> title,
  Value<int> grade,
  Value<String> subject,
  Value<String> textbookId,
  Value<String> configJson,
  Value<String> contentJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PapersTableFilterComposer
    extends Composer<_$AppDatabase, $PapersTable> {
  $$PapersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentJson => $composableBuilder(
    column: $table.contentJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PapersTableOrderingComposer
    extends Composer<_$AppDatabase, $PapersTable> {
  $$PapersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolId => $composableBuilder(
    column: $table.schoolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentJson => $composableBuilder(
    column: $table.contentJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PapersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PapersTable> {
  $$PapersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get schoolId =>
      $composableBuilder(column: $table.schoolId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get textbookId => $composableBuilder(
    column: $table.textbookId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentJson => $composableBuilder(
    column: $table.contentJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PapersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PapersTable,
          Paper,
          $$PapersTableFilterComposer,
          $$PapersTableOrderingComposer,
          $$PapersTableAnnotationComposer,
          $$PapersTableCreateCompanionBuilder,
          $$PapersTableUpdateCompanionBuilder,
          (Paper, BaseReferences<_$AppDatabase, $PapersTable, Paper>),
          Paper,
          PrefetchHooks Function()
        > {
  $$PapersTableTableManager(_$AppDatabase db, $PapersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PapersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PapersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PapersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> schoolId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> textbookId = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<String> contentJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PapersCompanion(
                id: id,
                schoolId: schoolId,
                title: title,
                grade: grade,
                subject: subject,
                textbookId: textbookId,
                configJson: configJson,
                contentJson: contentJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String schoolId,
                required String title,
                required int grade,
                required String subject,
                required String textbookId,
                required String configJson,
                required String contentJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PapersCompanion.insert(
                id: id,
                schoolId: schoolId,
                title: title,
                grade: grade,
                subject: subject,
                textbookId: textbookId,
                configJson: configJson,
                contentJson: contentJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PapersTable, Paper>(table),
                  BaseReferences<_$AppDatabase, $PapersTable, Paper>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PapersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PapersTable,
      Paper,
      $$PapersTableFilterComposer,
      $$PapersTableOrderingComposer,
      $$PapersTableAnnotationComposer,
      $$PapersTableCreateCompanionBuilder,
      $$PapersTableUpdateCompanionBuilder,
      (Paper, BaseReferences<_$AppDatabase, $PapersTable, Paper>),
      Paper,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String entity,
  required String entityId,
  required String op,
  required DateTime createdAt,
  Value<String> status,
  Value<int> tries,
  Value<String> lastError,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> entity,
  Value<String> entityId,
  Value<String> op,
  Value<DateTime> createdAt,
  Value<String> status,
  Value<int> tries,
  Value<String> lastError,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tries => $composableBuilder(
    column: $table.tries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tries => $composableBuilder(
    column: $table.tries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get tries =>
      $composableBuilder(column: $table.tries, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncItem,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (SyncItem, BaseReferences<_$AppDatabase, $SyncQueueTable, SyncItem>),
          SyncItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> tries = const Value.absent(),
                Value<String> lastError = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                createdAt: createdAt,
                status: status,
                tries: tries,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entity,
                required String entityId,
                required String op,
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<int> tries = const Value.absent(),
                Value<String> lastError = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                createdAt: createdAt,
                status: status,
                tries: tries,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncItem>(table),
                  BaseReferences<_$AppDatabase, $SyncQueueTable, SyncItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncItem,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (SyncItem, BaseReferences<_$AppDatabase, $SyncQueueTable, SyncItem>),
      SyncItem,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SchoolsTableTableManager get schools =>
      $$SchoolsTableTableManager(_db, _db.schools);
  $$TeachersTableTableManager get teachers =>
      $$TeachersTableTableManager(_db, _db.teachers);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$TextbooksTableTableManager get textbooks =>
      $$TextbooksTableTableManager(_db, _db.textbooks);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db, _db.topics);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$AttemptsTableTableManager get attempts =>
      $$AttemptsTableTableManager(_db, _db.attempts);
  $$AttemptAnswersTableTableManager get attemptAnswers =>
      $$AttemptAnswersTableTableManager(_db, _db.attemptAnswers);
  $$PapersTableTableManager get papers =>
      $$PapersTableTableManager(_db, _db.papers);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
