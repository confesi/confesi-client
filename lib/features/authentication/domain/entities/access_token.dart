import 'package:equatable/equatable.dart';

class AccessToken extends Equatable {
  final String accessToken;

  const AccessToken({required this.accessToken});

  @override
  List<Object> get props => [accessToken];
}
