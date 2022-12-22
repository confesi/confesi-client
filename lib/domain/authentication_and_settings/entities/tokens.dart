import 'package:equatable/equatable.dart';

/// [Tokens] entity. Stores the access and refresh token.
class Tokens extends Equatable {
  final String token;

  const Tokens({required this.token});

  @override
  List<Object?> get props => [token];
}
