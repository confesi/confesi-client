import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/typography.dart';
import '../../state/token_slice.dart';
import '../../state/user_search_slice.dart';
import '../../widgets/layouts/appbar.dart';
import '../../widgets/layouts/keyboard_dismiss.dart';
import '../../widgets/textfield/long.dart';
import '../../widgets/tiles/user.dart';

class SearchHome extends ConsumerStatefulWidget {
  const SearchHome({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchHome> createState() => _SearchHomeState();
}

class _SearchHomeState extends ConsumerState<SearchHome> {
  @override
  Widget build(BuildContext context) {
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
                      .read(userSearchProvider.notifier)
                      .refineResults(value, ref.read(tokenProvider).accessToken),
                ),
                centerWidgetFullWidth: true,
                showIcon: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...ref
                          .watch(userSearchProvider)
                          .results
                          .map(
                            (result) => UserTile(
                                displayName: result.displayName, username: result.username),
                          )
                          .toList(),
                      const SizedBox(height: 15),
                    ],
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
