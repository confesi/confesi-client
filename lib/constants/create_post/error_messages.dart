import '../../core/error_messages/messages.dart';

class CreatePostErrorMessages extends ErrorMessages {
  @override
  String getFieldsBlankError() => "Both the title and body can't be empty!";
}
