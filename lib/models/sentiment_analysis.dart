// To parse this JSON data, do
//
//     final sentimentAnalysis = sentimentAnalysisFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SentimentAnalysis sentimentAnalysisFromJson(String str) => SentimentAnalysis.fromJson(json.decode(str));

class SentimentAnalysis extends Equatable {
  num positive;
  num negative;
  num neutral;
  num compound;

  SentimentAnalysis({
    required this.positive,
    required this.negative,
    required this.neutral,
    required this.compound,
  });

  factory SentimentAnalysis.fromJson(Map<String, dynamic> json) => SentimentAnalysis(
        positive: json["positive"]?.toDouble(),
        negative: json["negative"],
        neutral: json["neutral"]?.toDouble(),
        compound: json["compound"]?.toDouble(),
      );

  @override
  List<Object?> get props => [positive, negative, neutral, compound];
}
