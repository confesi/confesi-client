import 'dart:math';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/presentation/profile/widgets/award_tile.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/off.dart';
import '../../shared/behaviours/themed_status_bar.dart';

class AwardsScreen extends StatefulWidget {
  const AwardsScreen({super.key});

  @override
  State<AwardsScreen> createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleIconBtn(
                        icon: CupertinoIcons.arrow_left,
                        onTap: () => router.pop(context),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "Your Achievements",
                        style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 15),
                      Off(
                        child: CircleIconBtn(
                          icon: CupertinoIcons.arrow_left,
                          onTap: () => router.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        double emojiSize = constraints.maxWidth / 2.5;
                        return AwardTile(
                          count: Random().nextInt(5),
                          title: "Award",
                          desc: "Award description",
                          emoji: ["❤️", "🚀", "🥹", "😐", "🥂"][Random().nextInt(5)],
                          fontSize: emojiSize,
                        );
                      },
                    );
                  },
                  childCount: 10,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom)),
            ],
          ),
        ),
      ),
    );
  }
}
