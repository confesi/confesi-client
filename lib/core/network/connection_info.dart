import 'dart:io' show Platform;

import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class INetworkInfo {
  Future<bool> get isConnected;
}

// Checks if the current device can connect to the internet (iOS and Android only).
class NetworkInfo implements INetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfo(this.connectionChecker);

  /// Returns TRUE if the current device has an internet connection. Returns FALSE if the device doesn't.
  ///
  /// Returns TRUE by default for platforms that aren't iOS or Android.
  @override
  Future<bool> get isConnected async => Platform.isAndroid || Platform.isIOS
      ? await connectionChecker.hasConnection
      : true;
}
