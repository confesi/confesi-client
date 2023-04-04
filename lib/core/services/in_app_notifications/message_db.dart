import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';

import 'message_table.dart';

import 'message_db.dart';
import 'package:drift/drift.dart';

part 'message_db.g.dart';

LazyDatabase _openConnection() {
  // TODO: REMOVE; this allows for multiple instances and causes race conditions
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, "message.sqlite"));

    return NativeDatabase(file);
  });
}

// Does throw exceptions
@DriftDatabase(tables: [Message])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // return results in descending order based on time created (id always increases)
  Future<List<MessageData>> getAllMessages() =>
      (select(message)..orderBy([(t) => OrderingTerm(expression: t.id)])).get();

  Future<int> deleteMessage(int id) => (delete(message)..where((t) => t.id.equals(id))).go();

  Future<int> insertMessage(MessageCompanion entity) async => into(message).insert(entity);

  Future<int> deleteAllMessages() => delete(message).go();

  void dispose() => close();
}
