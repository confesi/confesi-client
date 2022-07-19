import 'package:equatable/equatable.dart';

abstract class Success extends Equatable {
  @override
  List<Object> get props => [];
}

class ApiSuccess extends Success {}
