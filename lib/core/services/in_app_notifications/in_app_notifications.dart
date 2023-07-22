import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' as drift;

import 'message_db.dart';

// todo: ALWAYS USE A SINGLE VERSION OF THIS CLASS TO AVOID RACE CONDITIONS:
// todo: REMOVE `driftRuntimeOptions.dontWarnAboutMultipleDatabases = true`

// replace with your custom failure class
class MessageFailure {}

class InAppMessageService {
  final AppDb _db;

  InAppMessageService() : _db = AppDb();

  // insert a message
  Future<Either<MessageFailure, int>> addMessage(String title, String body) async {
    try {
      int insertionId = await _db.insertMessage(
        MessageCompanion(
          title: drift.Value(title),
          content: drift.Value(body),
          date: drift.Value(DateTime.now()),
        ),
      );
      return Right(insertionId);
    } catch (_) {
      return Left(MessageFailure());
    }
  }

  // fetch all messages
  Future<Either<MessageFailure, List<MessageData>>> getAllMessages() async {
    try {
      List<MessageData> messages = await _db.getAllMessages();
      return Right(messages);
    } catch (_) {
      return Left(MessageFailure());
    }
  }

  // delete a single record by its id
  Future<Either<MessageFailure, int>> deleteMessage(int id) async {
    try {
      int deletionId = await _db.deleteMessage(id);
      return Right(deletionId);
    } catch (_) {
      return Left(MessageFailure());
    }
  }

  // delete all records
  Future<Either<MessageFailure, int>> deleteAllMessages() async {
    try {
      int deletionId = await _db.deleteAllMessages();
      return Right(deletionId);
    } catch (_) {
      return Left(MessageFailure());
    }
  }

  void dispose() => _db.dispose();
}
