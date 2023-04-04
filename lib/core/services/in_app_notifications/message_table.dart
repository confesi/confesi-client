import 'package:drift/drift.dart';

class Message extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get date => dateTime().withDefault(Constant(DateTime.now()))();
}

// flutter pub run build_runner build --delete-conflicting-outputs
//! for changes, this rebuilds the database classes