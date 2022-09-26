import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/domain/settings/usecases/get_biometric_setting.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/settings/usecases/update_biometric_setting.dart';

part 'biometrics_enabled_state.dart';

class BiometricsEnabledCubit extends Cubit<BiometricsEnabledState> {
  final UpdateBiometricSetting
      updateBiometricSetting; //TODO: Rename as private (_)
  final GetBiometricSetting getBiometricSetting;

  BiometricsEnabledCubit(
      {required this.updateBiometricSetting, required this.getBiometricSetting})
      : super(BiometricsEnabledInitial());

  void loadSetting() async {
    print(await getBiometricSetting.call(NoParams()));
  }

  void updateSetting() async {
    await updateBiometricSetting.call(true);
  }
}
