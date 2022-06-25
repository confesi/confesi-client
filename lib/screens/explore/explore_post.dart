import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/textfield/long.dart';
import '../../constants/typography.dart';
import '../../widgets/layouts/appbar.dart';

// TODO: Show cupertertino scrollbar inside here

class ExplorePost extends StatelessWidget {
  const ExplorePost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LongTextField(
                      onChange: (value) => print(value),
                      topPadding: 15,
                      icon: CupertinoIcons.chat_bubble,
                      horizontalPadding: 15,
                      hintText: "What do you think?",
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
