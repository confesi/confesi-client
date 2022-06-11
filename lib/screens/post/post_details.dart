import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/details.dart';
import 'package:flutter_mobile_client/widgets/buttons/long.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';
import 'package:flutter_mobile_client/widgets/layouts/scrollbar.dart';
import 'package:flutter_mobile_client/widgets/text/animated_load.dart';

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
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TouchableOpacity(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        color: Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(CupertinoIcons.chevron_back),
                        ),
                      ),
                    ),
                    Text(
                      "Post details",
                      style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(CupertinoIcons.chevron_back,
                          color: Colors.transparent),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  primary: true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        const DetailsButton(
                          header: "University",
                          body: "university of victoria",
                        ),
                        const DetailsButton(
                          header: "Genre",
                          body: "relationships",
                        ),
                        const DetailsButton(
                          header: "Student year",
                          body: "year 2",
                        ),
                        const DetailsButton(
                          header: "Faculty",
                          body: "visual arts",
                        ),
                        const DetailsButton(
                          header: "Link a friend",
                          body: "@thatguy69",
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const AnimatedLoadText(
                                text: "✨ details saved automatically ✨",
                              ),
                              const SizedBox(height: 15),
                              Hero(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
