import 'package:confesi/application/feed/cubit/sentiment_analysis_cubit.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/go_router.dart';

import '../../shared/behaviours/init_scale.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:scrollable/exports.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
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

  Widget buildChild(BuildContext context, SentimentAnalysisState state) {
    if (state is SentimentAnalysisData) {
      return ScrollableView(
        key: const ValueKey("loaded"),
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        controller: ScrollController(),
        child: InitScale(
          hapticEnlarge: true,
          child: PieChart(
            chartRadius: heightFraction(context, .4),
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
              Theme.of(context).colorScheme.tertiary
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
      return LoadingOrAlert(
          message: StateMessage(
              "Unknown error", () => context.read<SentimentAnalysisCubit>().loadSentimentAnalysis(widget.props.postId)),
          isLoading: state is SentimentAnalysisLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: ThemeStatusBar(
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.shadow,
            body: SafeArea(
              top: false,
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
                      child: BlocBuilder<SentimentAnalysisCubit, SentimentAnalysisState>(
                        builder: (context, state) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: buildChild(context, state),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
