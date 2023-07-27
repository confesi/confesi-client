import 'package:confesi/presentation/shared/behaviours/nav_blocker.dart';

import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/behaviours/init_scale.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:scrollable/exports.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';

class SentimentAnalysisScreen extends StatelessWidget {
  const SentimentAnalysisScreen({
    Key? key,
  }) : super(key: key);

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
                  child: ScrollableView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    controller: ScrollController(),
                    child: InitScale(
                      child: PieChart(
                        chartRadius: widthFraction(context, .75),
                        ringStrokeWidth: 20,
                        dataMap: const {
                          "Positive": 5,
                          "Negative": 4,
                          "Neutral": 2,
                        },
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 55,
                        colorList: const [Colors.green, Colors.red, Colors.yellow],
                        chartType: ChartType.ring,
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          chartValueStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                        ),
                      ),
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
