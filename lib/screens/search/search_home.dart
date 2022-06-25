import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/state/search_slice.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/layouts/keyboard_dismiss.dart';
import 'package:flutter_mobile_client/widgets/textfield/long.dart';
import 'package:flutter_mobile_client/widgets/tiles/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/typography.dart';

class SearchHome extends ConsumerWidget {
  const SearchHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardDismissLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                centerWidget: LongTextField(
                  onChange: (value) => ref
                      .read(searchProvider.notifier)
                      .refineResults(value, ref.read(tokenProvider).accessToken),
                ),
                centerWidgetFullWidth: true,
                showIcon: false,
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: ref
                        .watch(searchProvider)
                        .results
                        .map(
                          (result) =>
                              UserTile(displayName: result.displayName, username: result.username),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
