import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'notification_table.g.dart';

@DataClassName('FcmNotification')
class FcmNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255).nullable()();
  TextColumn get body => text().withLength(min: 1, max: 255).nullable()();
  TextColumn get data => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(Constant(DateTime.now()))();
}

@DataClassName('FcmNotificationCompanion')
class FcmNotificationCompanion extends UpdateCompanion<FcmNotification> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String?> body;
  final Value<String?> data;

  const FcmNotificationCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.data = const Value.absent(),
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value!);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value!);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value!);
    }
    return map;
  }
}

LazyDatabase openDb() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [FcmNotifications])
class FcmDatabase extends _$FcmDatabase {
  FcmDatabase() : super(openDb());

  @override
  int get schemaVersion => 1;

  void closeDb() => close();

  Future<void> insertNotification(FcmNotificationCompanion entry) => into(fcmNotifications).insert(entry);

  Future<List<FcmNotification>> getAllNotifications() => select(fcmNotifications).get();

  Future<void> deleteNotificationById(int id) => (delete(fcmNotifications)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<FcmNotification>> getNotificationsByPagination({
    required int limit,
    DateTime? cursor,
  }) async {
    final orderByColumn = fcmNotifications.date; // Use the datetime column for ordering
    const orderByMode = OrderingMode.desc;

    final orderExpr = cursor != null
        ? (orderByMode == OrderingMode.asc
            ? fcmNotifications.date.isSmallerThanValue(cursor) // Older notifications
            : fcmNotifications.date.isBiggerThanValue(cursor)) // Newer notifications
        : fcmNotifications.date.isBiggerThanValue(DateTime.now()); // Start from the oldest notifications

    return (select(fcmNotifications)
          ..where((tbl) => orderExpr)
          ..orderBy([(t) => OrderingTerm(expression: orderByColumn, mode: orderByMode)])
          ..limit(limit))
        .get();
  }
}
