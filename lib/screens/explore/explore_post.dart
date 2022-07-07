import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../constants/typography.dart';
import '../../widgets/layouts/appbar.dart';
import '../../widgets/textfield/long.dart';
import '../../widgets/tiles/post.dart';

// TODO: Show cupertertino scrollbar inside here

class ExplorePost extends StatelessWidget {
  const ExplorePost(
      {required this.date,
      required this.icon,
      required this.faculty,
      required this.genre,
      required this.body,
      required this.likes,
      required this.dislikes,
      required this.comments,
      required this.parentID,
      required this.parentGenre,
      required this.parentFaculty,
      required this.parentText,
      Key? key})
      : super(key: key);

  final ObjectId? parentID;
  final String? parentGenre;
  final String? parentFaculty;
  final String? parentText;
  final IconData icon;
  final String date;
  final String faculty;
  final String genre;
  final String body;
  final int likes;
  final int dislikes;
  final int comments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: LongTextField(
        onChange: (value) => print(value),
        topPadding: 15,
        bottomPadding: 15,
        icon: CupertinoIcons.chat_bubble,
        horizontalPadding: 15,
        hintText: "What do you think?",
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            AppbarLayout(
              centerWidget: Text(
                "Thread",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PostTile(
                      parentFaculty: parentFaculty,
                      parentGenre: parentGenre,
                      parentText: parentText,
                      parentID: parentID,
                      threadView: true,
                      date: date,
                      icon: icon,
                      faculty: faculty,
                      genre: genre,
                      body: body,
                      likes: likes,
                      dislikes: dislikes,
                      comments: comments,
                    ),
                    Container(
                      height: 500,
                      color: Colors.blueAccent,
                    ),
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
