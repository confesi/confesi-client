import 'package:Confessi/domain/authentication_and_settings/usecases/open_device_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/usecases/no_params.dart';

part 'language_setting_state.dart';

class LanguageSettingCubit extends Cubit<LanguageSettingState> {
  final OpenDeviceSettings openDeviceSettingsUsecase;

  LanguageSettingCubit({
    required this.openDeviceSettingsUsecase,
  }) : super(LanguageSettingBase());

  // resets the cubit state to base
  void setLanguageStateToBase() => emit(LanguageSettingBase());

  // opens the device's local system settings
  void openDeviceSettings() async {
    (await openDeviceSettingsUsecase.call(NoParams())).fold(
      (failure) {
        emit(LanguageSettingError(message: "Unable to open device settings. Please navigate there manually."));
      },
      (success) => {}, // Nothing needed if it works, as the mail client would be clearly opening
    );
  }
}
