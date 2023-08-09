import 'package:flutter/cupertino.dart';

import '../../../init.dart';
import '../../../presentation/shared/overlays/registered_users_only_sheet.dart';
import '../../services/user_auth/user_auth_service.dart';

void verifiedUserOnly(BuildContext context, VoidCallback callback, {VoidCallback? onFail}) {
  if (sl.get<UserAuthService>().isAnon) {
    showRegisteredUserOnlySheet(context);
    if (onFail != null) onFail();
  } else {
    callback();
  }
}
