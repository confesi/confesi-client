import '../../domain/entities/tokens.dart';

/// Model for access and refresh token.
class TokensModel extends Tokens {
  const TokensModel({
    required String accessToken,
    required String refreshToken,
  }) : super(accessToken: accessToken, refreshToken: refreshToken);

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }
}
