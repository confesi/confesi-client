import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BadgeEntity extends Equatable {
  final IconData icon;
  final String text;

  const BadgeEntity({required this.icon, required this.text});

  @override
  List<Object?> get props => [icon, text];
}
