import '../../../core/usecases/no_params.dart';
import '../../../domain/authentication_and_settings/usecases/copy_email_text.dart';
import '../../../domain/authentication_and_settings/usecases/open_mail_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'contact_setting_state.dart';

class ContactSettingCubit extends Cubit<ContactSettingState> {
  final CopyEmailText copyEmailTextUsecase;
  final OpenMailClient openMailClientUsecase;

  ContactSettingCubit({
    required this.copyEmailTextUsecase,
    required this.openMailClientUsecase,
  }) : super(ContactBase());

  // resets the cubit state to base
  void setContactStateToBase() => emit(ContactBase());

  // copies the email text
  void copyEmailText() async {
    (await copyEmailTextUsecase.call(NoParams())).fold(
      (failure) {
        emit(ContactError(message: "Unable to copy text. Email is: support@confesi.com."));
      },
      (success) {
        emit(ContactSuccess());
      },
    );
  }

  // opens the device's default mail client with default email set (attempts to)
  void openMailClient() async {
    (await openMailClientUsecase.call(NoParams())).fold(
      (failure) {
        emit(ContactError(message: "Unable to open a mail app."));
      },
      (success) => {}, // Nothing needed if it works, as the mail client would be clearly opening
    );
  }
}
