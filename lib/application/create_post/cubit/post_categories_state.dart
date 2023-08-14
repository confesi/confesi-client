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
  final GenericPost postType;

  const PostCategoriesData({
    required this.categories,
    required this.selectedIndex,
    required this.title,
    required this.body,
    required this.postType,
  });

  @override
  List<Object> get props => [categories, selectedIndex, title, body, postType];
}

class PostCategory {
  final String name;
  final IconData icon;

  const PostCategory(this.name, this.icon);
}
