import 'package:Confessi/features/authentication/domain/entities/access_token.dart';

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
