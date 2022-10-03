import 'package:flutter/material.dart';

double heightWithoutTopSafeArea(BuildContext context) {
  return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
}
