import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Badge extends Equatable {
  final Color darkColor;
  final Color lightColor;
  final String text;

  const Badge(
      {required this.darkColor, required this.lightColor, required this.text});

  @override
  List<Object?> get props => [darkColor, lightColor, text];
}
