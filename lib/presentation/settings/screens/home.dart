import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/settings/widgets/setting_tile.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:Confessi/presentation/shared/layout/minimal_appbar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/textfields/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/layout/appbar.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            AppbarLayout(
              bottomBorder: false,
              centerWidget: Text(
                'Settings',
                style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Settings are synced between all logged in devices when online.",
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 15),
                      SettingTile(
                        icon: CupertinoIcons.color_filter,
                        text: "Themes",
                        secondaryText: "(system)",
                        onTap: () => print("tap"),
                      ),
                      SettingTile(
                        icon: CupertinoIcons.map,
                        text: "Languages",
                        secondaryText: "(en)",
                        onTap: () => print("tap"),
                      ),
                      SettingTile(
                        icon: CupertinoIcons.paintbrush_fill,
                        text: "Reduced Animations",
                        secondaryText: "(off)",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
