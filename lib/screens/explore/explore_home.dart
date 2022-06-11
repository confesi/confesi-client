import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';

class ExploreHome extends StatelessWidget {
  const ExploreHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // TODO: make into dismissables with report/share or something?
            // TODO: make title clickable (navigates to change university profile setting)
            const AppbarLayout(text: "University of Victoria", backNav: false),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    PostTile(
                        icon: CupertinoIcons.flame,
                        date: "Dec 14, 9:04am",
                        faculty: "engineering",
                        genre: "Relationships",
                        body:
                            "Gotta be honest. Sometimes I swipe by girls and guys on Tinder or Bumble and I wish there was a super dislike button. Like bro, I don't know what your parents were thinking having you.",
                        likes: 31,
                        dislikes: 1,
                        comments: 16,
                        topLine: false),
                    PostTile(
                        icon: CupertinoIcons.star,
                        date: "Dec 14, 12:01pm",
                        faculty: "visual arts",
                        genre: "Classes",
                        body:
                            "I really hate my profs. They drive me absolutely insane. Like seriously, grow up, get better, and do better!!",
                        likes: 11,
                        dislikes: 3,
                        comments: 25),
                    PostTile(
                        icon: CupertinoIcons.flame,
                        date: "Dec 14, 9:04am",
                        faculty: "engineering",
                        genre: "Relationships",
                        body:
                            "Gotta be honest. Sometimes I swipe by girls and guys on Tinder or Bumble and I wish there was a super dislike button. Like bro, I don't know what your parents were thinking having you.",
                        likes: 31,
                        dislikes: 1,
                        comments: 16,
                        topLine: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
