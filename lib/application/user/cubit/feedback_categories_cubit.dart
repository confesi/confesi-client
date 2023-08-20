import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'feedback_categories_state.dart';

FeedbackCategoriesData _defaultState() => const FeedbackCategoriesData(
      categories: [
        FeedbackCategory("General", CupertinoIcons.cube_box),
        FeedbackCategory("Bug", CupertinoIcons.ant_fill),
      ],
      selectedIndex: 0,
    );

class FeedbackCategoriesCubit extends Cubit<FeedbackCategoriesState> {
  FeedbackCategoriesCubit() : super(_defaultState());

  void clear() {
    emit(_defaultState());
  }

  String category() {
    if (state is FeedbackCategoriesData) {
      return (state as FeedbackCategoriesData).categories[(state as FeedbackCategoriesData).selectedIndex].name;
    } else {
      // default
      return _defaultState().categories[0].name;
    }
  }

  void updateCategoryIdx(int index) {
    if (state is FeedbackCategoriesData) {
      emit(
        FeedbackCategoriesData(
          categories: (state as FeedbackCategoriesData).categories,
          selectedIndex: index,
        ),
      );
    }
  }

  void resetCategoryAndText() {
    if (state is FeedbackCategoriesData) {
      emit(
        FeedbackCategoriesData(
          categories: (state as FeedbackCategoriesData).categories,
          selectedIndex: 0,
        ),
      );
    }
  }
}
