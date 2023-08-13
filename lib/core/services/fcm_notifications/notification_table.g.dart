// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_table.dart';

// ignore_for_file: type=lint
class $FcmNotificationsTable extends FcmNotifications
    with TableInfo<$FcmNotificationsTable, FcmNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FcmNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns => [id, title, body, data, date];
  @override
  String get aliasedName => _alias ?? 'fcm_notifications';
  @override
  String get actualTableName => 'fcm_notifications';
  @override
  VerificationContext validateIntegrity(Insertable<FcmNotification> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FcmNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FcmNotification(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $FcmNotificationsTable createAlias(String alias) {
    return $FcmNotificationsTable(attachedDatabase, alias);
  }
}

class FcmNotification extends DataClass implements Insertable<FcmNotification> {
  final int id;
  final String? title;
  final String? body;
  final String? data;
  final DateTime date;
  const FcmNotification(
      {required this.id, this.title, this.body, this.data, required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  FcmNotificationsCompanion toCompanion(bool nullToAbsent) {
    return FcmNotificationsCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      date: Value(date),
    );
  }

  factory FcmNotification.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FcmNotification(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      data: serializer.fromJson<String?>(json['data']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String?>(body),
      'data': serializer.toJson<String?>(data),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  FcmNotification copyWith(
          {int? id,
          Value<String?> title = const Value.absent(),
          Value<String?> body = const Value.absent(),
          Value<String?> data = const Value.absent(),
          DateTime? date}) =>
      FcmNotification(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        body: body.present ? body.value : this.body,
        data: data.present ? data.value : this.data,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('FcmNotification(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('data: $data, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, data, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FcmNotification &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.data == this.data &&
          other.date == this.date);
}

class FcmNotificationsCompanion extends UpdateCompanion<FcmNotification> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String?> body;
  final Value<String?> data;
  final Value<DateTime> date;
  const FcmNotificationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.data = const Value.absent(),
    this.date = const Value.absent(),
  });
  FcmNotificationsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.data = const Value.absent(),
    this.date = const Value.absent(),
  });
  static Insertable<FcmNotification> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? data,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (data != null) 'data': data,
      if (date != null) 'date': date,
    });
  }

  FcmNotificationsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? title,
      Value<String?>? body,
      Value<String?>? data,
      Value<DateTime>? date}) {
    return FcmNotificationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FcmNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('data: $data, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$FcmDatabase extends GeneratedDatabase {
  _$FcmDatabase(QueryExecutor e) : super(e);
  late final $FcmNotificationsTable fcmNotifications =
      $FcmNotificationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [fcmNotifications];
}
