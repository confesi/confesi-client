import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/profile/profile_edit.dart';
import 'package:flutter_mobile_client/widgets/buttons/details.dart';
import 'package:flutter_mobile_client/widgets/buttons/long.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';
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
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Details from profile",
                            style: kTitle.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            RowText(
                                leftText: "University",
                                rightText: "university of victoria",
                                topLine: true),
                            RowText(
                                leftText: "Faculty",
                                rightText: "computer science"),
                            RowText(leftText: "Year", rightText: "two"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 30),
                        child: Hero(
                          tag: "details-button",
                          child: Material(
                            child: LongButton(
                              text: "Done",
                              onPress: () => Navigator.of(context).pop(),
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
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
      ),
    );
  }
}
