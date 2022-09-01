import 'package:Confessi/presentation/create_post/cubit/post_cubit.dart';
import 'package:Confessi/presentation/create_post/widgets/disclaimer_text.dart';
import 'package:Confessi/presentation/create_post/widgets/text_row.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/line.dart';
import '../widgets/floating_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TouchableOpacity(
                        onTap: () => Navigator.pop(context),
                        child: Transform.translate(
                          offset: const Offset(-4, 0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                right: 10, top: 2, bottom: 2),
                            // Transparent hitbox trick.
                            color: Colors.transparent,
                            child: Icon(
                              CupertinoIcons.back,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    FloatingButton(
                      text: 'Post',
                      onTap: () {
                        context.read<CreatePostCubit>().uploadUserPost(
                              widget.title,
                              widget.body,
                              widget.id,
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.shadow,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: ScrollableView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(
                                  'Edited every post:',
                                  style: kTitle.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const TextRow(
                                leftText: 'Genre',
                                rightText: 'General',
                                bottomLine: true,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'Taken from your account:',
                                  style: kTitle.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const TextRow(
                                leftText: 'Faculty',
                                rightText: 'Engineering',
                              ),
                              const TextRow(
                                leftText: 'Year of Study',
                                rightText: '2',
                              ),
                              const TextRow(
                                leftText: 'University',
                                rightText: 'University of Victoria',
                                bottomLine: true,
                              ),
                              const DisclaimerText(
                                text:
                                    'Please be civil, but have fun. All posts are completely anonymous (excluding above details).',
                              ),
                              const DisclaimerText(
                                text:
                                    'Change your default account details in settings.',
                              ),
                            ],
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
    );
  }
}
