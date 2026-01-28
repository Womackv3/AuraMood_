// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MoodEntriesTable extends MoodEntries
    with TableInfo<$MoodEntriesTable, MoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _moodLevelMeta = const VerificationMeta(
    'moodLevel',
  );
  @override
  late final GeneratedColumn<int> moodLevel = GeneratedColumn<int>(
    'mood_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anxietyLevelMeta = const VerificationMeta(
    'anxietyLevel',
  );
  @override
  late final GeneratedColumn<int> anxietyLevel = GeneratedColumn<int>(
    'anxiety_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _irritabilityLevelMeta = const VerificationMeta(
    'irritabilityLevel',
  );
  @override
  late final GeneratedColumn<int> irritabilityLevel = GeneratedColumn<int>(
    'irritability_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    moodLevel,
    anxietyLevel,
    irritabilityLevel,
    sleepHours,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('mood_level')) {
      context.handle(
        _moodLevelMeta,
        moodLevel.isAcceptableOrUnknown(data['mood_level']!, _moodLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_moodLevelMeta);
    }
    if (data.containsKey('anxiety_level')) {
      context.handle(
        _anxietyLevelMeta,
        anxietyLevel.isAcceptableOrUnknown(
          data['anxiety_level']!,
          _anxietyLevelMeta,
        ),
      );
    }
    if (data.containsKey('irritability_level')) {
      context.handle(
        _irritabilityLevelMeta,
        irritabilityLevel.isAcceptableOrUnknown(
          data['irritability_level']!,
          _irritabilityLevelMeta,
        ),
      );
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      moodLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_level'],
      )!,
      anxietyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anxiety_level'],
      ),
      irritabilityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}irritability_level'],
      ),
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $MoodEntriesTable createAlias(String alias) {
    return $MoodEntriesTable(attachedDatabase, alias);
  }
}

class MoodEntry extends DataClass implements Insertable<MoodEntry> {
  final String id;
  final DateTime timestamp;
  final int moodLevel;
  final int? anxietyLevel;
  final int? irritabilityLevel;
  final double? sleepHours;
  final String? notes;
  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.moodLevel,
    this.anxietyLevel,
    this.irritabilityLevel,
    this.sleepHours,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['mood_level'] = Variable<int>(moodLevel);
    if (!nullToAbsent || anxietyLevel != null) {
      map['anxiety_level'] = Variable<int>(anxietyLevel);
    }
    if (!nullToAbsent || irritabilityLevel != null) {
      map['irritability_level'] = Variable<int>(irritabilityLevel);
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      moodLevel: Value(moodLevel),
      anxietyLevel: anxietyLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(anxietyLevel),
      irritabilityLevel: irritabilityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(irritabilityLevel),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory MoodEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntry(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      moodLevel: serializer.fromJson<int>(json['moodLevel']),
      anxietyLevel: serializer.fromJson<int?>(json['anxietyLevel']),
      irritabilityLevel: serializer.fromJson<int?>(json['irritabilityLevel']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'moodLevel': serializer.toJson<int>(moodLevel),
      'anxietyLevel': serializer.toJson<int?>(anxietyLevel),
      'irritabilityLevel': serializer.toJson<int?>(irritabilityLevel),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MoodEntry copyWith({
    String? id,
    DateTime? timestamp,
    int? moodLevel,
    Value<int?> anxietyLevel = const Value.absent(),
    Value<int?> irritabilityLevel = const Value.absent(),
    Value<double?> sleepHours = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => MoodEntry(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    moodLevel: moodLevel ?? this.moodLevel,
    anxietyLevel: anxietyLevel.present ? anxietyLevel.value : this.anxietyLevel,
    irritabilityLevel: irritabilityLevel.present
        ? irritabilityLevel.value
        : this.irritabilityLevel,
    sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
    notes: notes.present ? notes.value : this.notes,
  );
  MoodEntry copyWithCompanion(MoodEntriesCompanion data) {
    return MoodEntry(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      moodLevel: data.moodLevel.present ? data.moodLevel.value : this.moodLevel,
      anxietyLevel: data.anxietyLevel.present
          ? data.anxietyLevel.value
          : this.anxietyLevel,
      irritabilityLevel: data.irritabilityLevel.present
          ? data.irritabilityLevel.value
          : this.irritabilityLevel,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntry(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('moodLevel: $moodLevel, ')
          ..write('anxietyLevel: $anxietyLevel, ')
          ..write('irritabilityLevel: $irritabilityLevel, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    moodLevel,
    anxietyLevel,
    irritabilityLevel,
    sleepHours,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntry &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.moodLevel == this.moodLevel &&
          other.anxietyLevel == this.anxietyLevel &&
          other.irritabilityLevel == this.irritabilityLevel &&
          other.sleepHours == this.sleepHours &&
          other.notes == this.notes);
}

class MoodEntriesCompanion extends UpdateCompanion<MoodEntry> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<int> moodLevel;
  final Value<int?> anxietyLevel;
  final Value<int?> irritabilityLevel;
  final Value<double?> sleepHours;
  final Value<String?> notes;
  final Value<int> rowid;
  const MoodEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.moodLevel = const Value.absent(),
    this.anxietyLevel = const Value.absent(),
    this.irritabilityLevel = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    required int moodLevel,
    this.anxietyLevel = const Value.absent(),
    this.irritabilityLevel = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : moodLevel = Value(moodLevel);
  static Insertable<MoodEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? moodLevel,
    Expression<int>? anxietyLevel,
    Expression<int>? irritabilityLevel,
    Expression<double>? sleepHours,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (moodLevel != null) 'mood_level': moodLevel,
      if (anxietyLevel != null) 'anxiety_level': anxietyLevel,
      if (irritabilityLevel != null) 'irritability_level': irritabilityLevel,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? timestamp,
    Value<int>? moodLevel,
    Value<int?>? anxietyLevel,
    Value<int?>? irritabilityLevel,
    Value<double?>? sleepHours,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return MoodEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodLevel: moodLevel ?? this.moodLevel,
      anxietyLevel: anxietyLevel ?? this.anxietyLevel,
      irritabilityLevel: irritabilityLevel ?? this.irritabilityLevel,
      sleepHours: sleepHours ?? this.sleepHours,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (moodLevel.present) {
      map['mood_level'] = Variable<int>(moodLevel.value);
    }
    if (anxietyLevel.present) {
      map['anxiety_level'] = Variable<int>(anxietyLevel.value);
    }
    if (irritabilityLevel.present) {
      map['irritability_level'] = Variable<int>(irritabilityLevel.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('moodLevel: $moodLevel, ')
          ..write('anxietyLevel: $anxietyLevel, ')
          ..write('irritabilityLevel: $irritabilityLevel, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleTimeMeta = const VerificationMeta(
    'scheduleTime',
  );
  @override
  late final GeneratedColumn<String> scheduleTime = GeneratedColumn<String>(
    'schedule_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, dosage, scheduleTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    }
    if (data.containsKey('schedule_time')) {
      context.handle(
        _scheduleTimeMeta,
        scheduleTime.isAcceptableOrUnknown(
          data['schedule_time']!,
          _scheduleTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      ),
      scheduleTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_time'],
      ),
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final String id;
  final String name;
  final String? dosage;
  final String? scheduleTime;
  const Medication({
    required this.id,
    required this.name,
    this.dosage,
    this.scheduleTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || scheduleTime != null) {
      map['schedule_time'] = Variable<String>(scheduleTime);
    }
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      dosage: dosage == null && nullToAbsent
          ? const Value.absent()
          : Value(dosage),
      scheduleTime: scheduleTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleTime),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      scheduleTime: serializer.fromJson<String?>(json['scheduleTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String?>(dosage),
      'scheduleTime': serializer.toJson<String?>(scheduleTime),
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    Value<String?> dosage = const Value.absent(),
    Value<String?> scheduleTime = const Value.absent(),
  }) => Medication(
    id: id ?? this.id,
    name: name ?? this.name,
    dosage: dosage.present ? dosage.value : this.dosage,
    scheduleTime: scheduleTime.present ? scheduleTime.value : this.scheduleTime,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      scheduleTime: data.scheduleTime.present
          ? data.scheduleTime.value
          : this.scheduleTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('scheduleTime: $scheduleTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, dosage, scheduleTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.scheduleTime == this.scheduleTime);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<String?> scheduleTime;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.scheduleTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.dosage = const Value.absent(),
    this.scheduleTime = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Medication> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? scheduleTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (scheduleTime != null) 'schedule_time': scheduleTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? dosage,
    Value<String?>? scheduleTime,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduleTime: scheduleTime ?? this.scheduleTime,
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
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (scheduleTime.present) {
      map['schedule_time'] = Variable<String>(scheduleTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('scheduleTime: $scheduleTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedLogsTable extends MedLogs with TableInfo<$MedLogsTable, MedLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id)',
    ),
  );
  static const VerificationMeta _scheduledForMeta = const VerificationMeta(
    'scheduledFor',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
    'scheduled_for',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    scheduledFor,
    takenAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'med_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
        _scheduledForMeta,
        scheduledFor.isAcceptableOrUnknown(
          data['scheduled_for']!,
          _scheduledForMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledForMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      scheduledFor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_for'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MedLogsTable createAlias(String alias) {
    return $MedLogsTable(attachedDatabase, alias);
  }
}

class MedLog extends DataClass implements Insertable<MedLog> {
  final String id;
  final String medicationId;
  final DateTime scheduledFor;
  final DateTime? takenAt;
  final String status;
  const MedLog({
    required this.id,
    required this.medicationId,
    required this.scheduledFor,
    this.takenAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<DateTime>(takenAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  MedLogsCompanion toCompanion(bool nullToAbsent) {
    return MedLogsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      scheduledFor: Value(scheduledFor),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      status: Value(status),
    );
  }

  factory MedLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedLog(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduledFor: serializer.fromJson<DateTime>(json['scheduledFor']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduledFor': serializer.toJson<DateTime>(scheduledFor),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'status': serializer.toJson<String>(status),
    };
  }

  MedLog copyWith({
    String? id,
    String? medicationId,
    DateTime? scheduledFor,
    Value<DateTime?> takenAt = const Value.absent(),
    String? status,
  }) => MedLog(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    scheduledFor: scheduledFor ?? this.scheduledFor,
    takenAt: takenAt.present ? takenAt.value : this.takenAt,
    status: status ?? this.status,
  );
  MedLog copyWithCompanion(MedLogsCompanion data) {
    return MedLog(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedLog(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('takenAt: $takenAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicationId, scheduledFor, takenAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedLog &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.scheduledFor == this.scheduledFor &&
          other.takenAt == this.takenAt &&
          other.status == this.status);
}

class MedLogsCompanion extends UpdateCompanion<MedLog> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<DateTime> scheduledFor;
  final Value<DateTime?> takenAt;
  final Value<String> status;
  final Value<int> rowid;
  const MedLogsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedLogsCompanion.insert({
    this.id = const Value.absent(),
    required String medicationId,
    required DateTime scheduledFor,
    this.takenAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicationId = Value(medicationId),
       scheduledFor = Value(scheduledFor);
  static Insertable<MedLog> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<DateTime>? scheduledFor,
    Expression<DateTime>? takenAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (takenAt != null) 'taken_at': takenAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<DateTime>? scheduledFor,
    Value<DateTime?>? takenAt,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return MedLogsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      takenAt: takenAt ?? this.takenAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedLogsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('takenAt: $takenAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeatherSnapshotsTable extends WeatherSnapshots
    with TableInfo<$WeatherSnapshotsTable, WeatherSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mood_entries (id)',
    ),
  );
  static const VerificationMeta _tempCMeta = const VerificationMeta('tempC');
  @override
  late final GeneratedColumn<double> tempC = GeneratedColumn<double>(
    'temp_c',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cloudCoverPctMeta = const VerificationMeta(
    'cloudCoverPct',
  );
  @override
  late final GeneratedColumn<int> cloudCoverPct = GeneratedColumn<int>(
    'cloud_cover_pct',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rainMmMeta = const VerificationMeta('rainMm');
  @override
  late final GeneratedColumn<double> rainMm = GeneratedColumn<double>(
    'rain_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moonPhaseMeta = const VerificationMeta(
    'moonPhase',
  );
  @override
  late final GeneratedColumn<String> moonPhase = GeneratedColumn<String>(
    'moon_phase',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryId,
    tempC,
    cloudCoverPct,
    rainMm,
    moonPhase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeatherSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('temp_c')) {
      context.handle(
        _tempCMeta,
        tempC.isAcceptableOrUnknown(data['temp_c']!, _tempCMeta),
      );
    }
    if (data.containsKey('cloud_cover_pct')) {
      context.handle(
        _cloudCoverPctMeta,
        cloudCoverPct.isAcceptableOrUnknown(
          data['cloud_cover_pct']!,
          _cloudCoverPctMeta,
        ),
      );
    }
    if (data.containsKey('rain_mm')) {
      context.handle(
        _rainMmMeta,
        rainMm.isAcceptableOrUnknown(data['rain_mm']!, _rainMmMeta),
      );
    }
    if (data.containsKey('moon_phase')) {
      context.handle(
        _moonPhaseMeta,
        moonPhase.isAcceptableOrUnknown(data['moon_phase']!, _moonPhaseMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeatherSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      tempC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temp_c'],
      ),
      cloudCoverPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cloud_cover_pct'],
      ),
      rainMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rain_mm'],
      ),
      moonPhase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moon_phase'],
      ),
    );
  }

  @override
  $WeatherSnapshotsTable createAlias(String alias) {
    return $WeatherSnapshotsTable(attachedDatabase, alias);
  }
}

class WeatherSnapshot extends DataClass implements Insertable<WeatherSnapshot> {
  final String id;
  final String entryId;
  final double? tempC;
  final int? cloudCoverPct;
  final double? rainMm;
  final String? moonPhase;
  const WeatherSnapshot({
    required this.id,
    required this.entryId,
    this.tempC,
    this.cloudCoverPct,
    this.rainMm,
    this.moonPhase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    if (!nullToAbsent || tempC != null) {
      map['temp_c'] = Variable<double>(tempC);
    }
    if (!nullToAbsent || cloudCoverPct != null) {
      map['cloud_cover_pct'] = Variable<int>(cloudCoverPct);
    }
    if (!nullToAbsent || rainMm != null) {
      map['rain_mm'] = Variable<double>(rainMm);
    }
    if (!nullToAbsent || moonPhase != null) {
      map['moon_phase'] = Variable<String>(moonPhase);
    }
    return map;
  }

  WeatherSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return WeatherSnapshotsCompanion(
      id: Value(id),
      entryId: Value(entryId),
      tempC: tempC == null && nullToAbsent
          ? const Value.absent()
          : Value(tempC),
      cloudCoverPct: cloudCoverPct == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudCoverPct),
      rainMm: rainMm == null && nullToAbsent
          ? const Value.absent()
          : Value(rainMm),
      moonPhase: moonPhase == null && nullToAbsent
          ? const Value.absent()
          : Value(moonPhase),
    );
  }

  factory WeatherSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherSnapshot(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      tempC: serializer.fromJson<double?>(json['tempC']),
      cloudCoverPct: serializer.fromJson<int?>(json['cloudCoverPct']),
      rainMm: serializer.fromJson<double?>(json['rainMm']),
      moonPhase: serializer.fromJson<String?>(json['moonPhase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'tempC': serializer.toJson<double?>(tempC),
      'cloudCoverPct': serializer.toJson<int?>(cloudCoverPct),
      'rainMm': serializer.toJson<double?>(rainMm),
      'moonPhase': serializer.toJson<String?>(moonPhase),
    };
  }

  WeatherSnapshot copyWith({
    String? id,
    String? entryId,
    Value<double?> tempC = const Value.absent(),
    Value<int?> cloudCoverPct = const Value.absent(),
    Value<double?> rainMm = const Value.absent(),
    Value<String?> moonPhase = const Value.absent(),
  }) => WeatherSnapshot(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    tempC: tempC.present ? tempC.value : this.tempC,
    cloudCoverPct: cloudCoverPct.present
        ? cloudCoverPct.value
        : this.cloudCoverPct,
    rainMm: rainMm.present ? rainMm.value : this.rainMm,
    moonPhase: moonPhase.present ? moonPhase.value : this.moonPhase,
  );
  WeatherSnapshot copyWithCompanion(WeatherSnapshotsCompanion data) {
    return WeatherSnapshot(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      tempC: data.tempC.present ? data.tempC.value : this.tempC,
      cloudCoverPct: data.cloudCoverPct.present
          ? data.cloudCoverPct.value
          : this.cloudCoverPct,
      rainMm: data.rainMm.present ? data.rainMm.value : this.rainMm,
      moonPhase: data.moonPhase.present ? data.moonPhase.value : this.moonPhase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherSnapshot(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tempC: $tempC, ')
          ..write('cloudCoverPct: $cloudCoverPct, ')
          ..write('rainMm: $rainMm, ')
          ..write('moonPhase: $moonPhase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entryId, tempC, cloudCoverPct, rainMm, moonPhase);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherSnapshot &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.tempC == this.tempC &&
          other.cloudCoverPct == this.cloudCoverPct &&
          other.rainMm == this.rainMm &&
          other.moonPhase == this.moonPhase);
}

class WeatherSnapshotsCompanion extends UpdateCompanion<WeatherSnapshot> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<double?> tempC;
  final Value<int?> cloudCoverPct;
  final Value<double?> rainMm;
  final Value<String?> moonPhase;
  final Value<int> rowid;
  const WeatherSnapshotsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.tempC = const Value.absent(),
    this.cloudCoverPct = const Value.absent(),
    this.rainMm = const Value.absent(),
    this.moonPhase = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeatherSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String entryId,
    this.tempC = const Value.absent(),
    this.cloudCoverPct = const Value.absent(),
    this.rainMm = const Value.absent(),
    this.moonPhase = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId);
  static Insertable<WeatherSnapshot> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<double>? tempC,
    Expression<int>? cloudCoverPct,
    Expression<double>? rainMm,
    Expression<String>? moonPhase,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (tempC != null) 'temp_c': tempC,
      if (cloudCoverPct != null) 'cloud_cover_pct': cloudCoverPct,
      if (rainMm != null) 'rain_mm': rainMm,
      if (moonPhase != null) 'moon_phase': moonPhase,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeatherSnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? entryId,
    Value<double?>? tempC,
    Value<int?>? cloudCoverPct,
    Value<double?>? rainMm,
    Value<String?>? moonPhase,
    Value<int>? rowid,
  }) {
    return WeatherSnapshotsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      tempC: tempC ?? this.tempC,
      cloudCoverPct: cloudCoverPct ?? this.cloudCoverPct,
      rainMm: rainMm ?? this.rainMm,
      moonPhase: moonPhase ?? this.moonPhase,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (tempC.present) {
      map['temp_c'] = Variable<double>(tempC.value);
    }
    if (cloudCoverPct.present) {
      map['cloud_cover_pct'] = Variable<int>(cloudCoverPct.value);
    }
    if (rainMm.present) {
      map['rain_mm'] = Variable<double>(rainMm.value);
    }
    if (moonPhase.present) {
      map['moon_phase'] = Variable<String>(moonPhase.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tempC: $tempC, ')
          ..write('cloudCoverPct: $cloudCoverPct, ')
          ..write('rainMm: $rainMm, ')
          ..write('moonPhase: $moonPhase, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoodEntriesTable moodEntries = $MoodEntriesTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedLogsTable medLogs = $MedLogsTable(this);
  late final $WeatherSnapshotsTable weatherSnapshots = $WeatherSnapshotsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    moodEntries,
    medications,
    medLogs,
    weatherSnapshots,
  ];
}

typedef $$MoodEntriesTableCreateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      required int moodLevel,
      Value<int?> anxietyLevel,
      Value<int?> irritabilityLevel,
      Value<double?> sleepHours,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$MoodEntriesTableUpdateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      Value<int> moodLevel,
      Value<int?> anxietyLevel,
      Value<int?> irritabilityLevel,
      Value<double?> sleepHours,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$MoodEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry> {
  $$MoodEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WeatherSnapshotsTable, List<WeatherSnapshot>>
  _weatherSnapshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weatherSnapshots,
    aliasName: $_aliasNameGenerator(
      db.moodEntries.id,
      db.weatherSnapshots.entryId,
    ),
  );

  $$WeatherSnapshotsTableProcessedTableManager get weatherSnapshotsRefs {
    final manager = $$WeatherSnapshotsTableTableManager(
      $_db,
      $_db.weatherSnapshots,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weatherSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableFilterComposer({
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

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodLevel => $composableBuilder(
    column: $table.moodLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anxietyLevel => $composableBuilder(
    column: $table.anxietyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get irritabilityLevel => $composableBuilder(
    column: $table.irritabilityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weatherSnapshotsRefs(
    Expression<bool> Function($$WeatherSnapshotsTableFilterComposer f) f,
  ) {
    final $$WeatherSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weatherSnapshots,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeatherSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.weatherSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodLevel => $composableBuilder(
    column: $table.moodLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anxietyLevel => $composableBuilder(
    column: $table.anxietyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get irritabilityLevel => $composableBuilder(
    column: $table.irritabilityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get moodLevel =>
      $composableBuilder(column: $table.moodLevel, builder: (column) => column);

  GeneratedColumn<int> get anxietyLevel => $composableBuilder(
    column: $table.anxietyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get irritabilityLevel => $composableBuilder(
    column: $table.irritabilityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> weatherSnapshotsRefs<T extends Object>(
    Expression<T> Function($$WeatherSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$WeatherSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weatherSnapshots,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeatherSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.weatherSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MoodEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntriesTable,
          MoodEntry,
          $$MoodEntriesTableFilterComposer,
          $$MoodEntriesTableOrderingComposer,
          $$MoodEntriesTableAnnotationComposer,
          $$MoodEntriesTableCreateCompanionBuilder,
          $$MoodEntriesTableUpdateCompanionBuilder,
          (MoodEntry, $$MoodEntriesTableReferences),
          MoodEntry,
          PrefetchHooks Function({bool weatherSnapshotsRefs})
        > {
  $$MoodEntriesTableTableManager(_$AppDatabase db, $MoodEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> moodLevel = const Value.absent(),
                Value<int?> anxietyLevel = const Value.absent(),
                Value<int?> irritabilityLevel = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntriesCompanion(
                id: id,
                timestamp: timestamp,
                moodLevel: moodLevel,
                anxietyLevel: anxietyLevel,
                irritabilityLevel: irritabilityLevel,
                sleepHours: sleepHours,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                required int moodLevel,
                Value<int?> anxietyLevel = const Value.absent(),
                Value<int?> irritabilityLevel = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntriesCompanion.insert(
                id: id,
                timestamp: timestamp,
                moodLevel: moodLevel,
                anxietyLevel: anxietyLevel,
                irritabilityLevel: irritabilityLevel,
                sleepHours: sleepHours,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weatherSnapshotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (weatherSnapshotsRefs) db.weatherSnapshots,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (weatherSnapshotsRefs)
                    await $_getPrefetchedData<
                      MoodEntry,
                      $MoodEntriesTable,
                      WeatherSnapshot
                    >(
                      currentTable: table,
                      referencedTable: $$MoodEntriesTableReferences
                          ._weatherSnapshotsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MoodEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).weatherSnapshotsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.entryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MoodEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntriesTable,
      MoodEntry,
      $$MoodEntriesTableFilterComposer,
      $$MoodEntriesTableOrderingComposer,
      $$MoodEntriesTableAnnotationComposer,
      $$MoodEntriesTableCreateCompanionBuilder,
      $$MoodEntriesTableUpdateCompanionBuilder,
      (MoodEntry, $$MoodEntriesTableReferences),
      MoodEntry,
      PrefetchHooks Function({bool weatherSnapshotsRefs})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> dosage,
      Value<String?> scheduleTime,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> dosage,
      Value<String?> scheduleTime,
      Value<int> rowid,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedLogsTable, List<MedLog>> _medLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.medLogs,
    aliasName: $_aliasNameGenerator(db.medications.id, db.medLogs.medicationId),
  );

  $$MedLogsTableProcessedTableManager get medLogsRefs {
    final manager = $$MedLogsTableTableManager(
      $_db,
      $_db.medLogs,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
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

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleTime => $composableBuilder(
    column: $table.scheduleTime,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medLogsRefs(
    Expression<bool> Function($$MedLogsTableFilterComposer f) f,
  ) {
    final $$MedLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedLogsTableFilterComposer(
            $db: $db,
            $table: $db.medLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
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

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleTime => $composableBuilder(
    column: $table.scheduleTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
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

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get scheduleTime => $composableBuilder(
    column: $table.scheduleTime,
    builder: (column) => column,
  );

  Expression<T> medLogsRefs<T extends Object>(
    Expression<T> Function($$MedLogsTableAnnotationComposer a) f,
  ) {
    final $$MedLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.medLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({bool medLogsRefs})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<String?> scheduleTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                dosage: dosage,
                scheduleTime: scheduleTime,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> dosage = const Value.absent(),
                Value<String?> scheduleTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                dosage: dosage,
                scheduleTime: scheduleTime,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (medLogsRefs) db.medLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medLogsRefs)
                    await $_getPrefetchedData<
                      Medication,
                      $MedicationsTable,
                      MedLog
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._medLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MedicationsTableReferences(
                            db,
                            table,
                            p0,
                          ).medLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({bool medLogsRefs})
    >;
typedef $$MedLogsTableCreateCompanionBuilder =
    MedLogsCompanion Function({
      Value<String> id,
      required String medicationId,
      required DateTime scheduledFor,
      Value<DateTime?> takenAt,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$MedLogsTableUpdateCompanionBuilder =
    MedLogsCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<DateTime> scheduledFor,
      Value<DateTime?> takenAt,
      Value<String> status,
      Value<int> rowid,
    });

final class $$MedLogsTableReferences
    extends BaseReferences<_$AppDatabase, $MedLogsTable, MedLog> {
  $$MedLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.medLogs.medicationId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedLogsTable> {
  $$MedLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedLogsTable> {
  $$MedLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedLogsTable> {
  $$MedLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedLogsTable,
          MedLog,
          $$MedLogsTableFilterComposer,
          $$MedLogsTableOrderingComposer,
          $$MedLogsTableAnnotationComposer,
          $$MedLogsTableCreateCompanionBuilder,
          $$MedLogsTableUpdateCompanionBuilder,
          (MedLog, $$MedLogsTableReferences),
          MedLog,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedLogsTableTableManager(_$AppDatabase db, $MedLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<DateTime> scheduledFor = const Value.absent(),
                Value<DateTime?> takenAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedLogsCompanion(
                id: id,
                medicationId: medicationId,
                scheduledFor: scheduledFor,
                takenAt: takenAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String medicationId,
                required DateTime scheduledFor,
                Value<DateTime?> takenAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedLogsCompanion.insert(
                id: id,
                medicationId: medicationId,
                scheduledFor: scheduledFor,
                takenAt: takenAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicationId,
                                referencedTable: $$MedLogsTableReferences
                                    ._medicationIdTable(db),
                                referencedColumn: $$MedLogsTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedLogsTable,
      MedLog,
      $$MedLogsTableFilterComposer,
      $$MedLogsTableOrderingComposer,
      $$MedLogsTableAnnotationComposer,
      $$MedLogsTableCreateCompanionBuilder,
      $$MedLogsTableUpdateCompanionBuilder,
      (MedLog, $$MedLogsTableReferences),
      MedLog,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$WeatherSnapshotsTableCreateCompanionBuilder =
    WeatherSnapshotsCompanion Function({
      Value<String> id,
      required String entryId,
      Value<double?> tempC,
      Value<int?> cloudCoverPct,
      Value<double?> rainMm,
      Value<String?> moonPhase,
      Value<int> rowid,
    });
typedef $$WeatherSnapshotsTableUpdateCompanionBuilder =
    WeatherSnapshotsCompanion Function({
      Value<String> id,
      Value<String> entryId,
      Value<double?> tempC,
      Value<int?> cloudCoverPct,
      Value<double?> rainMm,
      Value<String?> moonPhase,
      Value<int> rowid,
    });

final class $$WeatherSnapshotsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WeatherSnapshotsTable, WeatherSnapshot> {
  $$WeatherSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MoodEntriesTable _entryIdTable(_$AppDatabase db) =>
      db.moodEntries.createAlias(
        $_aliasNameGenerator(db.weatherSnapshots.entryId, db.moodEntries.id),
      );

  $$MoodEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$MoodEntriesTableTableManager(
      $_db,
      $_db.moodEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeatherSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $WeatherSnapshotsTable> {
  $$WeatherSnapshotsTableFilterComposer({
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

  ColumnFilters<double> get tempC => $composableBuilder(
    column: $table.tempC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cloudCoverPct => $composableBuilder(
    column: $table.cloudCoverPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rainMm => $composableBuilder(
    column: $table.rainMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moonPhase => $composableBuilder(
    column: $table.moonPhase,
    builder: (column) => ColumnFilters(column),
  );

  $$MoodEntriesTableFilterComposer get entryId {
    final $$MoodEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeatherSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeatherSnapshotsTable> {
  $$WeatherSnapshotsTableOrderingComposer({
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

  ColumnOrderings<double> get tempC => $composableBuilder(
    column: $table.tempC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cloudCoverPct => $composableBuilder(
    column: $table.cloudCoverPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rainMm => $composableBuilder(
    column: $table.rainMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moonPhase => $composableBuilder(
    column: $table.moonPhase,
    builder: (column) => ColumnOrderings(column),
  );

  $$MoodEntriesTableOrderingComposer get entryId {
    final $$MoodEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeatherSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeatherSnapshotsTable> {
  $$WeatherSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get tempC =>
      $composableBuilder(column: $table.tempC, builder: (column) => column);

  GeneratedColumn<int> get cloudCoverPct => $composableBuilder(
    column: $table.cloudCoverPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rainMm =>
      $composableBuilder(column: $table.rainMm, builder: (column) => column);

  GeneratedColumn<String> get moonPhase =>
      $composableBuilder(column: $table.moonPhase, builder: (column) => column);

  $$MoodEntriesTableAnnotationComposer get entryId {
    final $$MoodEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeatherSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeatherSnapshotsTable,
          WeatherSnapshot,
          $$WeatherSnapshotsTableFilterComposer,
          $$WeatherSnapshotsTableOrderingComposer,
          $$WeatherSnapshotsTableAnnotationComposer,
          $$WeatherSnapshotsTableCreateCompanionBuilder,
          $$WeatherSnapshotsTableUpdateCompanionBuilder,
          (WeatherSnapshot, $$WeatherSnapshotsTableReferences),
          WeatherSnapshot,
          PrefetchHooks Function({bool entryId})
        > {
  $$WeatherSnapshotsTableTableManager(
    _$AppDatabase db,
    $WeatherSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<double?> tempC = const Value.absent(),
                Value<int?> cloudCoverPct = const Value.absent(),
                Value<double?> rainMm = const Value.absent(),
                Value<String?> moonPhase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeatherSnapshotsCompanion(
                id: id,
                entryId: entryId,
                tempC: tempC,
                cloudCoverPct: cloudCoverPct,
                rainMm: rainMm,
                moonPhase: moonPhase,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String entryId,
                Value<double?> tempC = const Value.absent(),
                Value<int?> cloudCoverPct = const Value.absent(),
                Value<double?> rainMm = const Value.absent(),
                Value<String?> moonPhase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeatherSnapshotsCompanion.insert(
                id: id,
                entryId: entryId,
                tempC: tempC,
                cloudCoverPct: cloudCoverPct,
                rainMm: rainMm,
                moonPhase: moonPhase,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeatherSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.entryId,
                                referencedTable:
                                    $$WeatherSnapshotsTableReferences
                                        ._entryIdTable(db),
                                referencedColumn:
                                    $$WeatherSnapshotsTableReferences
                                        ._entryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeatherSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeatherSnapshotsTable,
      WeatherSnapshot,
      $$WeatherSnapshotsTableFilterComposer,
      $$WeatherSnapshotsTableOrderingComposer,
      $$WeatherSnapshotsTableAnnotationComposer,
      $$WeatherSnapshotsTableCreateCompanionBuilder,
      $$WeatherSnapshotsTableUpdateCompanionBuilder,
      (WeatherSnapshot, $$WeatherSnapshotsTableReferences),
      WeatherSnapshot,
      PrefetchHooks Function({bool entryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db, _db.moodEntries);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedLogsTableTableManager get medLogs =>
      $$MedLogsTableTableManager(_db, _db.medLogs);
  $$WeatherSnapshotsTableTableManager get weatherSnapshots =>
      $$WeatherSnapshotsTableTableManager(_db, _db.weatherSnapshots);
}
