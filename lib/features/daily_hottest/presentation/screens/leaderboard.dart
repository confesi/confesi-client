import 'dart:math';

import 'package:Confessi/core/widgets/indicators/alert.dart';
import 'package:Confessi/core/widgets/indicators/loading.dart';
import 'package:Confessi/core/widgets/layout/appbar.dart';
import 'package:Confessi/core/widgets/layout/line.dart';
import 'package:Confessi/core/widgets/sheets/info_sheet.dart';
import 'package:Confessi/features/daily_hottest/constants.dart';
import 'package:Confessi/features/daily_hottest/presentation/cubit/leaderboard_cubit.dart';
import 'package:Confessi/features/daily_hottest/presentation/widgets/leaderboard_circle_tile.dart';
import 'package:Confessi/features/daily_hottest/presentation/widgets/leaderboard_rectangle_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/typography.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  List<Widget> getCircleRanks(Data data) {
    return [
      data.rankings.isNotEmpty
          ? Flexible(
              child: LeaderboardCircleTile(
                minSize: 90,
                placing: data.rankings[0].placing.toString(),
                university: data.rankings[0].universityName,
                points: data.rankings[0].points.toString(),
              ),
            )
          : Container(),
      data.rankings.length >= 2
          ? Flexible(
              child: LeaderboardCircleTile(
                minSize: 120,
                placing: data.rankings[1].placing.toString(),
                university: data.rankings[1].universityName,
                points: data.rankings[1].points.toString(),
              ),
            )
          : Container(),
      data.rankings.length >= 3
          ? Flexible(
              child: LeaderboardCircleTile(
                minSize: 90,
                placing: data.rankings[2].placing.toString(),
                university: data.rankings[2].universityName,
                points: data.rankings[2].points.toString(),
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
                        children: getCircleRanks(state),
                      ),
                      // HERE
                      LineLayout(
                        topPadding: 30,
                        width: MediaQuery.of(context).size.width * .3,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const SizedBox(height: 30);
                            } else if (index >= 3) {
                              return LeaderboardRectangleTile(
                                placing:
                                    state.rankings[index].placing.toString(),
                                points: state.rankings[index].points.toString(),
                                university:
                                    state.rankings[index].universityName,
                              );
                            } else {
                              return Container();
                            }
                          },
                          itemCount: state.rankings.length,
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
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Theme.of(context).colorScheme.shadow,
          child: Column(
            children: [
              AppbarLayout(
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
