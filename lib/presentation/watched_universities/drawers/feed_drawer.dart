import 'package:Confessi/presentation/shared/buttons/emblem.dart';
import 'package:Confessi/presentation/watched_universities/widgets/drawer_university_tile.dart';
import 'package:Confessi/presentation/watched_universities/widgets/section_accordian.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/layout/line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../widgets/searched_university_tile.dart';

class FeedDrawer extends StatefulWidget {
  const FeedDrawer({Key? key}) : super(key: key);

  @override
  State<FeedDrawer> createState() => _FeedDrawerState();
}

class _FeedDrawerState extends State<FeedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.secondary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Currently viewing",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "University of British Columbia",
                      style: kDisplay1.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ScrollableView(
              physics: const BouncingScrollPhysics(),
              hapticsEnabled: false,
              inlineBottomOrRightPadding: bottomSafeArea(context),
              scrollBarVisible: false,
              controller: ScrollController(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SimpleTextButton(
                      infiniteWidth: true,
                      onTap: () => Navigator.pushNamed(context, "/search_universities"),
                      text: "Edit home university",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: SimpleTextButton(
                      infiniteWidth: true,
                      onTap: () => Navigator.pushNamed(context, "/search_universities"),
                      text: "Edit watched universities",
                    ),
                  ),
                  SectionAccordian(
                    topBorder: true,
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Home university",
                    items: [
                      DrawerUniversityTile(
                        text: "University of Victoria",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Special",
                    items: [
                      DrawerUniversityTile(
                        text: "Random university",
                        onTap: () => print("tap"),
                      ),
                      DrawerUniversityTile(
                        text: "All universities mixed",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Watched universities",
                    items: [
                      DrawerUniversityTile(
                        text: "University of the Fraser Valley",
                        onTap: () => print("tap"),
                      ),
                      DrawerUniversityTile(
                        text: "University of British Columbia Okanagan",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
