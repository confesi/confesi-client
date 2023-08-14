import 'package:bloc/bloc.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/router/go_router.dart';

part 'post_categories_state.dart';

PostCategoriesData _defaultState() => PostCategoriesData(
      categories: postCategories,
      selectedIndex: 0,
      title: "",
      body: "",
      postType: CreatingNewPost(),
    );

class PostCategoriesCubit extends Cubit<PostCategoriesState> {
  PostCategoriesCubit() : super(_defaultState());

  PostCategoriesData get data {
    if (state is PostCategoriesData) {
      return state as PostCategoriesData;
    } else {
      // default
      return _defaultState();
    }
  }

  String updateTitle(String text) {
    if (state is PostCategoriesData) {
      emit(
        PostCategoriesData(
          title: text,
          postType: (state as PostCategoriesData).postType,
          body: (state as PostCategoriesData).body,
          categories: (state as PostCategoriesData).categories,
          selectedIndex: (state as PostCategoriesData).selectedIndex,
        ),
      );
    }
    return text;
  }

  String updateBody(String text) {
    if (state is PostCategoriesData) {
      emit(
        PostCategoriesData(
          postType: (state as PostCategoriesData).postType,
          title: (state as PostCategoriesData).title,
          body: text,
          categories: (state as PostCategoriesData).categories,
          selectedIndex: (state as PostCategoriesData).selectedIndex,
        ),
      );
    }
    return text;
  }

  void updateCategoryIdx(int index) {
    if (state is PostCategoriesData) {
      emit(
        PostCategoriesData(
          postType: (state as PostCategoriesData).postType,
          title: (state as PostCategoriesData).title,
          body: (state as PostCategoriesData).body,
          categories: (state as PostCategoriesData).categories,
          selectedIndex: index,
        ),
      );
    }
  }

  void resetCategoryAndText() {
    if (state is PostCategoriesData) {
      emit(
        PostCategoriesData(
          postType: (state as PostCategoriesData).postType,
          title: "",
          body: "",
          categories: (state as PostCategoriesData).categories,
          selectedIndex: 0,
        ),
      );
    }
  }
}
