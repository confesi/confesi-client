import 'package:equatable/equatable.dart';

/// [AccessToken] entity. Stores the access token.
class AccessToken extends Equatable {
  final String accessToken;

  const AccessToken({required this.accessToken});

  @override
  List<Object> get props => [accessToken];
}
