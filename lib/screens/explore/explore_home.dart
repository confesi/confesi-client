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
                    PostTile(topLine: false),
                    PostTile(),
                    PostTile(),
                    PostTile(),
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
