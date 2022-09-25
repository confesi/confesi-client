part of 'reduced_animations_cubit.dart';

@immutable
abstract class ReducedAnimationsState {}

class ReducedAnimationsInitial extends ReducedAnimationsState {}

class ReducedAnimationDataLoading extends ReducedAnimationsState {}

class ReducedAnimationsEnabled extends ReducedAnimationsState {}

class ReducedAnimationsDisabled extends ReducedAnimationsState {}
