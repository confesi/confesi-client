import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/profile/profile_edit.dart';
import 'package:flutter_mobile_client/widgets/buttons/details.dart';
import 'package:flutter_mobile_client/widgets/buttons/long.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/text/animated_load.dart';
import 'package:flutter_mobile_client/widgets/text/link.dart';
import 'package:flutter_mobile_client/widgets/text/row.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppbarLayout(
              text: "Post details",
            ),
            Expanded(
              child: SingleChildScrollView(
                primary: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      const DetailsButton(
                        header: "Genre",
                        body: "relationships",
                      ),
                      const DetailsButton(
                        header: "Link a friend",
                        body: "@thatguy69",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Hero(
                          tag: "details-button",
                          child: Material(
                            child: LongButton(
                              text: "Done",
                              onPress: () => Navigator.of(context).pop(),
                              textColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            "Account settings",
                            style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const RowText(
                                leftText: "University",
                                rightText: "university of victoria",
                                topLine: true),
                            const RowText(leftText: "Faculty", rightText: "computer science"),
                            const RowText(leftText: "Year", rightText: "two"),
                            const SizedBox(height: 15),
                            LinkText(
                              text: "These details are auto-populated from your profile. ",
                              linkText: "Change them here.",
                              widthMultiplier: 100,
                              onPress: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileEdit(),
                                ),
                              ),
                            ),
                          ],
                        ),
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
