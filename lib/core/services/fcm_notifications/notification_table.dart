import 'dart:convert';

import 'package:drift/drift.dart';

part 'notification_table.g.dart';

//? to rebuild run `flutter packages pub run build_runner build

@DataClassName('FcmNotification')
class FcmNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get body => text().withLength(min: 1, max: 255)();
  TextColumn get data => text()();
}

@DataClassName('FcmNotificationCompanion')
class FcmNotificationCompanions extends UpdateCompanion<FcmNotification> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> data;

  const FcmNotificationCompanions({
    this.id = const Value.absent(),
    required this.title,
    required this.body,
    required this.data,
  });

  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    map['title'] = Variable<String>(title.value);
    map['body'] = Variable<String>(body.value);
    map['data'] = Variable<String>(data.value);
    return map;
  }
}

@DriftDatabase(tables: [FcmNotifications])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  Future<void> insertNotification(FcmNotificationCompanions entry) => into(fcmNotifications).insert(entry);

  Future<List<FcmNotification>> getAllNotifications() => select(fcmNotifications).get();
}
