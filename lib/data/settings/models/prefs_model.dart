import 'package:Confessi/constants/settings/enums.dart';
import 'package:Confessi/domain/settings/entities/prefs.dart';

class PrefsModel extends Prefs {
  PrefsModel({
    required BiometricAuthEnum biometricAuthEnum,
    required AppearanceEnum appearanceEnum,
  }) : super(
          biometricAuthEnum: d(),
          appearanceEnum: appearanceEnum,
        );

  static BiometricAuthEnum d() {
    return BiometricAuthEnum.off;
  }

  factory PrefsModel.fromJson(Map<String, dynamic> json) {
    return PrefsModel(
      biometricAuthEnum: json["TEST"],
      appearanceEnum: json["TEST"],
    );
  }
}
