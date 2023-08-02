import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../services/user_auth/user_auth_data.dart';
import '../../services/user_auth/user_auth_service.dart';
import 'add_commas_to_number.dart';

String distanceFormatter(BuildContext context, num distanceInKm) {
  double multiplierToGetToKmOrMiles =
      Provider.of<UserAuthService>(context).data().unitSystem == UnitSystem.metric ? 1 : 0.621371;
  String unit = Provider.of<UserAuthService>(context).data().unitSystem == UnitSystem.metric ? "km" : "mi";
  return "${addCommasToNumber((distanceInKm * multiplierToGetToKmOrMiles).floor())} $unit away";
}

// todo: distance type