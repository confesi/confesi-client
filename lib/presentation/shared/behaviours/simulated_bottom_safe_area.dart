import 'package:flutter/material.dart';

class SimulatedBottomSafeArea extends StatelessWidget {
  const SimulatedBottomSafeArea({super.key, this.heightFactor = 2});

  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).padding.bottom * heightFactor);
  }
}
