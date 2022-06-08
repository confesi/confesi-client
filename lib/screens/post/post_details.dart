import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/buttons/details.dart';
import 'package:flutter_mobile_client/widgets/buttons/long.dart';
import 'package:flutter_mobile_client/widgets/layouts/scrollbar.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        color: Theme.of(context).colorScheme.onSecondary,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            body: Column(
              children: [
                const ScrollbarLayout(),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                      primary: true,
                      child: Column(
                        children: [
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          const DetailsButton(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: LongButton(
                              text: "Done",
                              onPress: () => Navigator.of(context).pop(),
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
