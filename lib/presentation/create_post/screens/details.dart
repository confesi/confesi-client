import 'package:Confessi/application/create_post/cubit/post_cubit.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/overlays/bottom_chip.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:Confessi/presentation/create_post/widgets/picker_sheet.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/buttons/long.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/spread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/text/fade_size_text.dart';

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

class _DetailsScreenState extends State<DetailsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget buildBody() => BlocListener<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state is Error) {
            showBottomChip(context, state.message);
          }
        },
        child: ThemedStatusBar(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: ShrinkingView(
              child: Column(
                children: [
                  NavBlocker(
                    blocking: context.watch<CreatePostCubit>().state is Loading,
                    child: AppbarLayout(
                      bottomBorder: false,
                      centerWidget: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          'Add Details',
                          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      leftIcon: CupertinoIcons.back,
                      leftIconIgnored: context.watch<CreatePostCubit>().state is Loading,
                      rightIcon: CupertinoIcons.info,
                      rightIconVisible: true,
                      rightIconOnPress: () => showInfoSheet(context, "Privacy/be a good person notice", "body"),
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
                            'About the confessor',
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 7.5),
                          const SpreadRowText(
                            leftText: 'University',
                            rightText: "UVic",
                          ),
                          const SpreadRowText(
                            leftText: 'Faculty',
                            rightText: "Hidden",
                          ),
                          const SpreadRowText(
                            leftText: 'Year of study',
                            rightText: "2",
                          ),
                          const SizedBox(height: 30),
                          // const DisclaimerText(
                          //   text:
                          //       'Please be civil when posting, but have fun! All confessions are anonymous, excluding the details provided above.',
                          // ),
                          // const SizedBox(height: 45),
                          BlocBuilder<CreatePostCubit, CreatePostState>(
                            // buildWhen: (previous, current) => true,
                            builder: (context, state) {
                              return LongButton(
                                text: 'Submit Confession',
                                onPress: () async => await context
                                    .read<CreatePostCubit>()
                                    .uploadUserPost(widget.title, widget.body, widget.id),
                                isLoading: state is Loading ? true : false,
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TouchableOpacity(
                              onTap: () => {}, // TODO: Implement
                              child: Container(
                                width: double.infinity,
                                // Transparent hitbox trick.
                                color: Colors.transparent,
                                child: Center(
                                  child: Container(
                                    width: widthFraction(context, 2 / 3),
                                    child: Text(
                                      "Edit university, faculty, and year details in settings",
                                      style: kTitle.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => context.watch<CreatePostCubit>().state is Loading
      ? WillPopScope(child: buildBody(), onWillPop: () async => false)
      : buildBody();
}
