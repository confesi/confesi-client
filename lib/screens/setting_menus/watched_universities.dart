import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/typography.dart';
import '../../state/token_slice.dart';
import '../../state/university_search_slice.dart';
import '../../widgets/buttons/icon_text.dart';
import '../../widgets/layouts/appbar.dart';
import '../../widgets/layouts/keyboard_dismiss.dart';
import '../../widgets/text/row_with_border.dart';
import '../../widgets/textfield/long.dart';

class WatchedUniversitiesSettingsMenu extends ConsumerWidget {
  const WatchedUniversitiesSettingsMenu({Key? key}) : super(key: key);

  List<Widget> getBody(List<dynamic> universities, BuildContext context) {
    if (universities.isNotEmpty) {
      return [
        ...universities
            .map(
              (result) => IconTextButton(
                onPress: () => print("tap"),
                text: "${result.universityName} ∙ ${result.universityCode}",
                rightIcon: CupertinoIcons.add,
                leftIconVisible: false,
              ),
            )
            .toList()
      ];
    } else {
      return [
        IconTextButton(
          onPress: () => print("tap"),
          text: "University of Colorado",
          rightIcon: CupertinoIcons.xmark,
          leftIconVisible: false,
        ),
        IconTextButton(
          onPress: () => print("tap"),
          text: "Trinity Western University",
          rightIcon: CupertinoIcons.xmark,
          leftIconVisible: false,
        ),
        IconTextButton(
          onPress: () => print("tap"),
          text: "University of Michigan",
          rightIcon: CupertinoIcons.xmark,
          leftIconVisible: false,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardDismissLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarLayout(
                iconTap: () {
                  Navigator.of(context).pop();
                  ref.read(universitySearchProvider.notifier).clearSearchResults();
                },
                centerWidget: Text(
                  "Watched Universities",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LongTextField(
                          onChange: (value) => ref
                              .read(universitySearchProvider.notifier)
                              .refineResults(value, ref.read(tokenProvider).accessToken),
                        ),
                        const SizedBox(height: 20),
                        const RowWithBorderText(
                          leftText: "Add or remove watched universities",
                          rightText: "(3/5)",
                        ),
                        ...getBody(ref.watch(universitySearchProvider).results, context),
                        const SizedBox(height: 20),
                      ],
                    ),
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
