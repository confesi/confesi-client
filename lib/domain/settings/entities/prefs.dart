import 'package:equatable/equatable.dart';

import '../../../constants/settings/enums.dart';

class Prefs extends Equatable {
  final BiometricAuthEnum biometricAuthEnum;
  final AppearanceEnum appearanceEnum;

  const Prefs({
    required this.biometricAuthEnum,
    required this.appearanceEnum,
  });

  @override
  List<Object?> get props => [];
}
