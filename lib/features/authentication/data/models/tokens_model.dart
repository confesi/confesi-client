import 'package:Confessi/features/authentication/domain/entities/tokens.dart';

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
