import 'package:hive/hive.dart';

part 'token_data.g.dart';

//? Whenever changed, run `flutter packages pub run build_runner build` to rebuild the generated file.

@HiveType(typeId: 1)
class FcmToken extends HiveObject {
  @HiveField(0)
  final bool withUid;

  @HiveField(1)
  final String token;

  FcmToken(this.withUid, this.token);
}

// FcmToken.g.dart should be generated for the extension to work.
// Make sure to run the build_runner to generate the required file.

// copyWith extension
extension FcmTokenCopyWith on FcmToken {
  FcmToken copyWith({
    bool? withUid,
    String? token,
  }) {
    return FcmToken(
      withUid ?? this.withUid,
      token ?? this.token,
    );
  }
}
