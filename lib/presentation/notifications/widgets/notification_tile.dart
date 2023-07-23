import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.8,
            style: BorderStyle.solid,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              body,
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
