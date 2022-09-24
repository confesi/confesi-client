import 'dart:math';

import 'package:Confessi/core/utils/numbers/is_plural.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/indicators/alert.dart';
import 'package:Confessi/presentation/shared/indicators/loading.dart';
import 'package:Confessi/presentation/shared/layout/appbar.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:Confessi/application/daily_hottest/leaderboard_cubit.dart';
import 'package:Confessi/presentation/daily_hottest/widgets/leaderboard_circle_tile.dart';
import 'package:Confessi/presentation/daily_hottest/widgets/leaderboard_rectangle_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/daily_hottest/general.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../../core/utils/numbers/number_postfix.dart';
import '../../shared/overlays/info_sheet.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  List<Widget> getCircleRanks(Data data, BuildContext context) {
    return [
      data.rankings.length >= 2
          ? Flexible(
              child: LeaderboardCircleTile(
                universityImagePath: data.rankings[1].universityImagePath,
                minSize: 90,
                placing:
                    '${data.rankings[1].placing}${numberPostfix(data.rankings[1].placing)}',
                universityFullName: data.rankings[1].universityFullName,
                universityName: data.rankings[1].universityName,
                points: isPlural(data.rankings[1].points)
                    ? '${largeNumberFormatter(data.rankings[1].points)} pts'
                    : '${largeNumberFormatter(data.rankings[1].points)} pt',
              ),
            )
          : Container(),
      data.rankings.isNotEmpty
          ? Flexible(
              child: LeaderboardCircleTile(
                universityImagePath: data.rankings[0].universityImagePath,
                minSize: 120,
                placing:
                    '${data.rankings[0].placing}${numberPostfix(data.rankings[0].placing)}',
                universityFullName: data.rankings[0].universityFullName,
                universityName: data.rankings[0].universityName,
                points: isPlural(data.rankings[0].points)
                    ? '${largeNumberFormatter(data.rankings[0].points)} pts'
                    : '${largeNumberFormatter(data.rankings[0].points)} pt',
              ),
            )
          : Container(),
      data.rankings.length >= 3
          ? Flexible(
              child: LeaderboardCircleTile(
                universityImagePath: data.rankings[2].universityImagePath,
                minSize: 90,
                placing:
                    '${data.rankings[2].placing}${numberPostfix(data.rankings[2].placing)}',
                universityFullName: data.rankings[2].universityFullName,
                universityName: data.rankings[2].universityName,
                points: isPlural(data.rankings[2].points)
                    ? '${largeNumberFormatter(data.rankings[2].points)} pts'
                    : '${largeNumberFormatter(data.rankings[2].points)} pt',
              ),
            )
          : Container(),
    ];
  }

  Widget buildChild(BuildContext context, LeaderboardState state) {
    if (state is Loading) {
      return const Center(
        key: ValueKey('loading'),
        child: LoadingIndicator(),
      );
    } else if (state is Data && state.rankings.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomPaint(
                  painter: PaintedHeader(context: context),
                  size: Size(MediaQuery.of(context).size.width, 125),
                ),
                Positioned.fill(
                  top: 30,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getCircleRanks(state, context),
                      ),
                      // HERE
                      LineLayout(
                        topPadding: 30,
                        width: MediaQuery.of(context).size.width * .3,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      Expanded(
                        child: InitTransform(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return const SizedBox(height: 30);
                              } else if (index >= 3) {
                                return LeaderboardRectangleTile(
                                  placing:
                                      '${state.rankings[index].placing}${numberPostfix(state.rankings[index].placing)}',
                                  points: isPlural(state.rankings[index].points)
                                      ? '${largeNumberFormatter(state.rankings[index].points)} pts'
                                      : '${largeNumberFormatter(state.rankings[index].points)} pt',
                                  university:
                                      state.rankings[index].universityFullName,
                                );
                              } else {
                                return Container();
                              }
                            },
                            itemCount: state.rankings.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      final error = state as Error;
      return Center(
        key: const ValueKey('alert'),
        child: AlertIndicator(
          isLoading: error.retryingAfterError,
          message: error.message,
          onPress: () => context.read<LeaderboardCubit>().loadRankings(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ShrinkingView(
        safeAreaBottom: false,
        child: Container(
          color: Theme.of(context).colorScheme.shadow,
          child: Column(
            children: [
              AppbarLayout(
                bottomBorder: false,
                centerWidget: Text(
                  'University Leaderboard',
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                rightIcon: CupertinoIcons.info,
                rightIconVisible: true,
                rightIconOnPress: () => showInfoSheet(
                    context, kLeaderboardInfoHeader, kLeaderboardInfoBody),
              ),
              Expanded(
                child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: buildChild(context, state),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaintedHeader extends CustomPainter {
  PaintedHeader({required this.context});

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Theme.of(context).colorScheme.background;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, 0),
        height: size.height * 1.75,
        width: size.width,
      ),
      pi * 2,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
