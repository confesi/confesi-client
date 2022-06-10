import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/action.dart';
import 'package:flutter_mobile_client/widgets/buttons/emblem.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';

import '../../widgets/images/circle.dart';
import '../../widgets/tiles/stat.dart';

class ProfileHome extends StatelessWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                const Expanded(
                  flex: 2,
                  child: GroupText(body: "@stardust", header: "Matthew Trent"),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          onPress: () {
                            print("left TAP");
                          },
                          text: "add details",
                          icon: CupertinoIcons.pen,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          iconColor: Theme.of(context).colorScheme.onSurface,
                          textColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        EmblemButton(
                          onPress: () {
                            print("MY TAP BRO");
                          },
                          icon: CupertinoIcons.gear,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          iconColor: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          LineLayout(
            color: Theme.of(context).colorScheme.surface,
            horizontalPadding: 15,
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Text(
                        "Achievements",
                        style: kHeader.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: const [
                            CircleImage(),
                            CircleImage(),
                            CircleImage(),
                            CircleImage(),
                            CircleImage(),
                            CircleImage(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Flexes",
                        style: kHeader.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: const [
                            StatTile(),
                            StatTile(),
                            StatTile(),
                            StatTile(),
                            StatTile(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
