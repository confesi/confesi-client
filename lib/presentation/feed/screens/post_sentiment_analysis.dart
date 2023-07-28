import 'package:confesi/application/feed/cubit/sentiment_analysis_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/go_router.dart';

import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/behaviours/init_scale.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:scrollable/exports.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/layout/appbar.dart';

class SentimentAnalysisScreen extends StatefulWidget {
  HomePostsSentimentProps props;

  SentimentAnalysisScreen({
    required this.props,
    Key? key,
  }) : super(key: key);

  @override
  State<SentimentAnalysisScreen> createState() => _SentimentAnalysisScreenState();
}

class _SentimentAnalysisScreenState extends State<SentimentAnalysisScreen> {
  @override
  void initState() {
    context.read<SentimentAnalysisCubit>().loadSentimentAnalysis(widget.props.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppbarLayout(
                bottomBorder: true,
                centerWidget: Text(
                  "Confession Sentiment",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: BlocBuilder<SentimentAnalysisCubit, SentimentAnalysisState>(
                      builder: (context, state) {
                        if (state is SentimentAnalysisLoading) {
                          return const LoadingCupertinoIndicator();
                        } else if (state is SentimentAnalysisData) {
                          return ScrollableView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            controller: ScrollController(),
                            child: InitScale(
                              child: PieChart(
                                chartRadius: widthFraction(context, .8),
                                ringStrokeWidth: 10,
                                dataMap: {
                                  "😁 Positive": state.sentimentAnalysis.positive.toDouble(),
                                  "🤬 Negative": state.sentimentAnalysis.negative.toDouble(),
                                  "😐 Neutral": state.sentimentAnalysis.neutral.toDouble(),
                                },
                                animationDuration: const Duration(milliseconds: 500),
                                chartLegendSpacing: 55,
                                colorList: [
                                  Theme.of(context).colorScheme.surfaceTint,
                                  Theme.of(context).colorScheme.error,
                                  Theme.of(context).colorScheme.secondary
                                ],
                                chartType: ChartType.ring,
                                legendOptions: LegendOptions(
                                  legendPosition: LegendPosition.bottom,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: kDisplay2.copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  chartValueStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                                  showChartValueBackground: false,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return AlertIndicator(
                            message: "Error loading sentiment",
                            onPress: () =>
                                context.read<SentimentAnalysisCubit>().loadSentimentAnalysis(widget.props.postId),
                          );
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
