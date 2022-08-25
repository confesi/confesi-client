import 'package:equatable/equatable.dart';

/// [Tokens] entity. Stores the access and refresh token.
class Tokens extends Equatable {
  final String accessToken;
  final String refreshToken;

  const Tokens({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
