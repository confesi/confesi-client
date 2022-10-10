import 'package:equatable/equatable.dart';

abstract class Success extends Equatable {
  @override
  List<Object> get props => [];
}

/// Returned upon a successful API call/execution.
class ApiSuccess extends Success {}

/// Returned upon successfully completing a biometric operation.
class BiometricSuccess extends Success {}

/// Returned upon a setting being properly updated.
class SettingSuccess extends Success {}
