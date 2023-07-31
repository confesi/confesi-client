import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'post_categories_state.dart';

PostCategoriesData _defaultState() => const PostCategoriesData(
      categories: [
        PostCategory("General", CupertinoIcons.cube_box),
        PostCategory("Hot takes", CupertinoIcons.flame),
        PostCategory("Classes", CupertinoIcons.book),
        PostCategory("Events", CupertinoIcons.calendar),
        PostCategory("Politics", CupertinoIcons.chat_bubble_2),
        PostCategory("Relationships", CupertinoIcons.suit_heart),
        PostCategory("Wholesome", CupertinoIcons.bandage),
      ],
      selectedIndex: 0,
      title: "",
      body: "",
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

  void updateTitle(String text) {
    if (state is PostCategoriesData) {
      print("UPDATE TITLE TO: $text");
      emit(
        PostCategoriesData(
          title: text,
          body: (state as PostCategoriesData).body,
          categories: (state as PostCategoriesData).categories,
          selectedIndex: (state as PostCategoriesData).selectedIndex,
        ),
      );
    }
  }

  void updateBody(String text) {
    if (state is PostCategoriesData) {
      emit(
        PostCategoriesData(
          title: (state as PostCategoriesData).title,
          body: text,
          categories: (state as PostCategoriesData).categories,
          selectedIndex: (state as PostCategoriesData).selectedIndex,
        ),
      );
    }
  }

  void updateCategoryIdx(int index) {
    if (state is PostCategoriesData) {
      emit(
        PostCategoriesData(
          title: (state as PostCategoriesData).title,
          body: (state as PostCategoriesData).body,
          categories: (state as PostCategoriesData).categories,
          selectedIndex: index,
        ),
      );
    }
  }

  void resetCategoryAndText() {
    print("RESET CALLED");
    if (state is PostCategoriesData) {
      emit(
        PostCategoriesData(
          title: "",
          body: "",
          categories: (state as PostCategoriesData).categories,
          selectedIndex: 0,
        ),
      );
    }
  }
}
