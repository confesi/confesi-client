import 'package:flutter/material.dart';

// TODO: add automatickeepalive mixin to tabs?

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.redAccent,
          height: 500,
        ),
        Container(
          color: Colors.blue,
          height: 500,
        ),
        Container(
          color: Colors.green,
          height: 500,
        ),
      ],
    );
  }
}
