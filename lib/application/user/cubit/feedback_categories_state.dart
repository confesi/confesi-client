part of 'feedback_categories_cubit.dart';

abstract class FeedbackCategoriesState extends Equatable {
  const FeedbackCategoriesState();

  @override
  List<Object> get props => [];
}

class FeedbackCategoriesData extends FeedbackCategoriesState {
  final List<FeedbackCategory> categories;
  final int selectedIndex;

  const FeedbackCategoriesData({
    required this.categories,
    required this.selectedIndex,
  });

  @override
  List<Object> get props => [categories, selectedIndex];
}

class FeedbackCategory {
  final String name;
  final IconData icon;

  const FeedbackCategory(this.name, this.icon);
}
