part of 'contact_setting_cubit.dart';

@immutable
abstract class ContactSettingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactBase extends ContactSettingState {}

class ContactSuccess extends ContactSettingState {}

class ContactError extends ContactSettingState {
  final String message;

  ContactError({required this.message});

  @override
  List<Object?> get props => [message];
}
