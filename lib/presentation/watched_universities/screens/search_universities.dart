import '../../../core/rate_limiters/debouncer.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/textfields/expandable_textfield.dart';
import '../widgets/searched_university_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';


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
                  child: Row(
                    children: [
                      TouchableOpacity(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          // Transparent hitbox trick
                          color: Colors.transparent,
                          child: Icon(
                            CupertinoIcons.arrow_left,
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
                      const SizedBox(width: 10)
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
