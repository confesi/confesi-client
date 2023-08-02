import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/textfields/expandable_textfield.dart';
import '../widgets/searched_university_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

class SearchSchoolsScreen extends StatefulWidget {
  const SearchSchoolsScreen({super.key});

  @override
  State<SearchSchoolsScreen> createState() => _SearchSchoolsScreenState();
}

class _SearchSchoolsScreenState extends State<SearchSchoolsScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textEditingController.addListener(() {
        if (!mounted) return;
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: .8,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: ExpandableTextfield(
                            color: Theme.of(context).colorScheme.surface,
                            maxLines: 1,
                            controller: _textEditingController,
                            hintText: "Search universities",
                          ),
                        ),
                        const SizedBox(width: 15),
                        CircleIconBtn(onTap: () => router.pop(context)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.shadow,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ScrollableView(
                        inlineTopOrLeftPadding: 5,
                        scrollBarVisible: false,
                        inlineBottomOrRightPadding: bottomSafeArea(context),
                        hapticsEnabled: false,
                        controller: ScrollController(),
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        child: Column(
                          children: [
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "1.5 km away",
                              bottomText: "UVIC",
                            ),
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "hey",
                              bottomText: "Victoria, BC",
                            ),
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "hey",
                              bottomText: "Victoria, BC",
                            ),
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "hey",
                              bottomText: "Victoria, BC",
                            ),
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "hey",
                              bottomText: "Victoria, BC",
                            ),
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "16 km away",
                              bottomText: "Victoria, BC",
                            ),
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "hey",
                              bottomText: "Victoria, BC",
                            ),
                            SearchedUniversityTile(
                              onPress: () => print("tap"),
                              topText: "University of Victoria",
                              middleText: "hey",
                              bottomText: "Victoria, BC",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
