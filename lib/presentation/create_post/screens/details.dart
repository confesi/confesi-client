import 'package:Confessi/presentation/create_post/cubit/post_cubit.dart';
import 'package:Confessi/presentation/create_post/widgets/disclaimer_text.dart';
import 'package:Confessi/presentation/create_post/widgets/picker_sheet.dart';
import 'package:Confessi/presentation/shared/buttons/long.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/spread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.title,
    required this.body,
    required this.id,
  }) : super(key: key);

  final String title;
  final String body;
  final String? id;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            AppbarLayout(
              bottomBorder: false,
              centerWidget: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  'Add Details',
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ScrollableView(
                horizontalPadding: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Post details',
                      style: kTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 7.5),
                    SpreadRowText(
                      leftText: 'Genre',
                      rightText: "Politics",
                      onPress: () => print('tap'),
                    ),
                    const SizedBox(height: 22.5),
                    Text(
                      'About the poster (you)',
                      style: kTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 7.5),
                    SpreadRowText(
                      leftText: 'University',
                      rightText: "UVic",
                      onPress: () => showPickerSheet(
                        context,
                        ["item1", "item2", "item3"],
                        0,
                        "University",
                        (index) => print(index),
                      ),
                    ),
                    SpreadRowText(
                      leftText: 'Faculty',
                      rightText: "Engineering",
                      onPress: () => print('tap'),
                    ),
                    SpreadRowText(
                      leftText: 'Year of study',
                      rightText: "2",
                      onPress: () => print('tap'),
                    ),
                    const SizedBox(height: 7.5),
                    const DisclaimerText(
                        text:
                            'Please be civil when posting, but have fun! All confessions are anonymous, excluding the details provided above.'),
                    const SizedBox(height: 30),
                    LongButton(
                      text: 'Submit Confession',
                      onPress: () async {
                        setState(() {
                          loading = true;
                        });
                        await context.read<CreatePostCubit>().uploadUserPost(
                            widget.title, widget.body, widget.id);
                        setState(() {
                          loading = false;
                        });
                      },
                      isLoading: loading,
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
