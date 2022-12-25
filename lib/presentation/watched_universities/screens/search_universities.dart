import 'package:Confessi/core/rate_limiters/debouncer.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/textfields/expandable.dart';
import 'package:Confessi/presentation/watched_universities/widgets/searched_university_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:scrollable/exports.dart';

import '../../shared/buttons/emblem.dart';
import '../../shared/buttons/pop.dart';

class SearchUniversitiesScreen extends StatefulWidget {
  const SearchUniversitiesScreen({super.key});

  @override
  State<SearchUniversitiesScreen> createState() => _SearchUniversitiesScreenState();
}

class _SearchUniversitiesScreenState extends State<SearchUniversitiesScreen> {
  late TextEditingController _textEditingController;
  final Debouncer _debouncer = Debouncer();

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
    return ThemedStatusBar(
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Container(
                //   width: double.infinity,
                //   color: Theme.of(context).colorScheme.secondary,
                //   padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                //   margin: const EdgeInsets.only(bottom: 10),
                //   child: SafeArea(
                //     bottom: false,
                //     child: Text(
                //       "Edit your Watched Universities",
                //       style: kTitle.copyWith(
                //         color: Theme.of(context).colorScheme.onSecondary,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                        width: .8,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      TouchableOpacity(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.only(right: 20, left: 10),
                          // Transparent hitbox trick
                          color: Colors.transparent,
                          child: Icon(
                            CupertinoIcons.xmark,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ExpandableTextfield(
                          maxLines: 1,
                          controller: _textEditingController,
                          onChanged: (newValue) {
                            _debouncer.run(() {
                              print(newValue);
                              //perform search here
                            });
                          },
                          hintText: "Search universities",
                        ),
                      ),
                      IgnorePointer(
                        ignoring: _textEditingController.text.isEmpty,
                        child: TouchableOpacity(
                          onTap: () => _textEditingController.clear(),
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            // Transparent hitbox trick
                            color: Colors.transparent,
                            child: Icon(
                              CupertinoIcons.trash,
                              color: _textEditingController.text.isEmpty
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ScrollableView(
                      scrollBarVisible: false,
                      inlineBottomOrRightPadding: bottomSafeArea(context),
                      inlineTopOrLeftPadding: 10,
                      hapticsEnabled: false,
                      controller: ScrollController(),
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      child: Column(
                        children: [
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                          SearchedUniversityTile(
                            onPress: () => print("tap"),
                            topText: "University of Victoria",
                            bottomText: "Victoria, BC",
                          ),
                        ],
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
