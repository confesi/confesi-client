import 'package:equatable/equatable.dart';

abstract class Success extends Equatable {
  @override
  List<Object> get props => [];
}

/// Returned upon a successful API call/execution.
class ApiSuccess extends Success {}
