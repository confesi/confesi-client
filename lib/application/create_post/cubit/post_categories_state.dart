part of 'post_categories_cubit.dart';

abstract class PostCategoriesState extends Equatable {
  const PostCategoriesState();

  @override
  List<Object> get props => [];
}

class PostCategoriesData extends PostCategoriesState {
  final List<PostCategory> categories;
  final int selectedIndex;
  final String title;
  final String body;

  const PostCategoriesData({
    required this.categories,
    required this.selectedIndex,
    required this.title,
    required this.body,
  });

  @override
  List<Object> get props => [categories, selectedIndex];
}

class PostCategory {
  final String name;
  final IconData icon;

  const PostCategory(this.name, this.icon);
}
