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

class _DetailsScreenState extends State<DetailsScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late bool loading;
  late AnimationController errorAnimController;

  // What to show as error message.
  String errorText = "";

  @override
  void initState() {
    loading = false;
    errorAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    errorAnimController.dispose();
    super.dispose();
  }

  void showErrorMessage(String textToDisplay) async {
    errorAnimController.reverse().then((value) async {
      errorText = textToDisplay;
      errorAnimController.forward();
    });
    errorAnimController.addListener(() {
      setState(() {});
    });
  }

  void hideErrorMessage() {
    errorAnimController.reverse();
    errorText = "";
    errorAnimController.addListener(() {
      setState(() {});
    });
  }

  Widget buildBody() => BlocListener<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state is Error) {
            showErrorMessage(state.message);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                IgnorePointer(
                  // Disables you from navigating back while loading.
                  ignoring: context.watch<CreatePostCubit>().state is Loading
                      ? true
                      : false,
                  child: AppbarLayout(
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
                    leftIcon: CupertinoIcons.back,
                    leftIconIgnored:
                        context.watch<CreatePostCubit>().state is Loading,
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
                            [
                              "item1",
                              "item2",
                              "item3",
                              "item4",
                              "item5",
                              "item6",
                              "item7",
                              "item8",
                              "item9"
                            ],
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
                        BlocBuilder<CreatePostCubit, CreatePostState>(
                          // buildWhen: (previous, current) => true,
                          builder: (context, state) {
                            return LongButton(
                              text: 'Submit Confession',
                              onPress: () async => await context
                                  .read<CreatePostCubit>()
                                  .uploadUserPost(
                                      widget.title, widget.body, widget.id),
                              isLoading: state is Loading ? true : false,
                            );
                          },
                        ),
                        FadeSizeText(
                          text: errorText,
                          childController: errorAnimController,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) =>
      context.watch<CreatePostCubit>().state is Loading
          ? WillPopScope(child: buildBody(), onWillPop: () async => false)
          : buildBody();
}
