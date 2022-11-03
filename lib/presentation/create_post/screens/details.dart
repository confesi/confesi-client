import 'package:Confessi/application/create_post/cubit/post_cubit.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/create_post/widgets/genre_group.dart';
import 'package:Confessi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:Confessi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:Confessi/presentation/shared/buttons/long.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/spread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
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

class _DetailsScreenState extends State<DetailsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is Error) showNotificationChip(context, state.message);
      },
      child: NavBlocker(
        blocking: context.watch<CreatePostCubit>().state is Loading,
        child: ThemedStatusBar(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              bottom: false,
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
                      rightIconOnPress: () => showInfoSheet(context, "Confessing",
                          "Please be civil when posting, but have fun! All confessions are anonymous, excluding the details provided here."),
                    ),
                  ),
                  Expanded(
                    child: ScrollableView(
                      horizontalPadding: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            "Select genre",
                            style: kBody.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 15),
                          const GenreGroup(),
                          const SizedBox(height: 25),
                          Text(
                            "Auto-populated details",
                            style: kBody.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          const SpreadRowText(
                            leftText: 'University',
                            rightText: "UVic",
                          ),
                          const SpreadRowText(
                            leftText: 'Year of study',
                            rightText: "2",
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Kept Private",
                            style: kBody.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          const SpreadRowText(
                            leftText: 'Faculty (optional)',
                            rightText: "Hidden",
                          ),
                          const SpreadRowText(
                            leftText: 'Who you are',
                            rightText: "Hidden",
                          ),
                          const SizedBox(height: 25),
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
                                  child: SizedBox(
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
                          const SimulatedBottomSafeArea(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
