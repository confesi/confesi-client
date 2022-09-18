import '../../../domain/authenticatioin/entities/access_token.dart';

/// Model for access token.
class AccessTokenModel extends AccessToken {
  const AccessTokenModel({
    required String accessToken,
  }) : super(accessToken: accessToken);

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(
      accessToken: json["accessToken"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
    };
  }
}
