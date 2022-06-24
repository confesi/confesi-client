import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';

import '../../constants/typography.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppbarLayout(
              centerWidget: Text(
                "Edit Profile",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
