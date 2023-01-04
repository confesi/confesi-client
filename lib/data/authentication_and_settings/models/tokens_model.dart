import '../../../domain/authentication_and_settings/entities/tokens.dart';

/// Model for access and refresh token.
class TokensModel extends Tokens {
  const TokensModel({
    required String token,
  }) : super(
          token: token,
        );

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
    };
  }
}
