import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Badge extends Equatable {
  final IconData icon;
  final String text;

  const Badge({required this.icon, required this.text});

  @override
  List<Object?> get props => [icon, text];
}
