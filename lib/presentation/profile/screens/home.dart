import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_burst.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_shrink.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileHome extends StatelessWidget {
  const ProfileHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SwipeRefresh(
      onRefresh: () async => print("refresh"),
      child: ScrollableView(
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightFraction(context, .3),
              child: Image.asset(
                "assets/images/universities/ufv.jpeg",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Expanded(
                          child: GroupText(
                            leftAlign: true,
                            small: true,
                            header: "mattrlt",
                            body: "University of Victoria",
                          ),
                        ),
                        const SizedBox(width: 10),
                        TouchableOpacity(
                          onTap: () => print("TAP"),
                          child: const Icon(CupertinoIcons.gear),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: widthFraction(context, 1),
                      child: Row(
                        children: [
                          Expanded(
                            child: SimpleTextButton(
                              onTap: () => print('tap'),
                              text: "Comments",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SimpleTextButton(
                              onTap: () => print('tap'),
                              text: "Stats",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SimpleTextButton(
                              onTap: () => print('tap'),
                              text: "Posts",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   color: Theme.of(context).colorScheme.background,
            // ),
          ],
        ),
      ),
    );
  }
}
