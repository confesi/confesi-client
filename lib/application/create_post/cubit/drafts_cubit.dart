import '../../../domain/create_post/entities/draft_post_entity.dart';
import '../../../domain/create_post/usecases/delete_draft.dart';
import '../../../domain/create_post/usecases/get_draft.dart';
import '../../../domain/create_post/usecases/save_draft.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drafts_state.dart';

class DraftsCubit extends Cubit<DraftsState> {
  final GetDraftUsecase getDraftUsecase;
  final SaveDraftUsecase saveDraftUsecase;
  final DeleteDraftUsecase deleteDraftUsecase;

  DraftsCubit({
    required this.getDraftUsecase,
    required this.saveDraftUsecase,
    required this.deleteDraftUsecase,
  }) : super(DraftsLoading());

  /// Saves a draft post.
  ///
  /// Returns [true] if saving was successful.
  Future<bool> saveDraft(String userId, String title, String body) async {
    final failureOrSuccess = await saveDraftUsecase.call(
      SaveDraftPostParams(
        draftPostEntity: DraftPostEntity(
          body: body,
          title: title,
        ),
        userId: userId,
      ),
    );
    return failureOrSuccess.fold(
      (failure) {
        emit(const DraftsError(message: "Error adding"));
        return false;
      },
      (success) => true,
    );
  }

  Future<List<DraftPostEntity>> getDrafts(String userId) async {
    emit(DraftsLoading());
    final failureOrDrafts = await getDraftUsecase.call(userId);
    return failureOrDrafts.fold(
      (failure) {
        emit(const DraftsError(message: "Error loading drafts"));
        return [];
      },
      (draftPosts) {
        emit(DraftsData(drafts: draftPosts));
        return draftPosts;
      },
    );
  }

  /// Returns [true] if succeeds, [false] if fails.
  Future<bool> deleteDraft(String userId, int index) async {
    final failureOrSuccess = await deleteDraftUsecase.call(DeleteDraftParams(index: index, userId: userId));
    return failureOrSuccess.fold(
      (failure) {
        emit(const DraftsError(message: "Error"));
        return false;
      },
      (_) {
        return true;
      },
    );
  }

  /// Emits a draft state with its data.
  Future<void> loadFromDraft(
    String userId,
    int indexOfLoadedDraft,
    String title,
    String body,
  ) async {
    // If deleting draft is successful, then load it.
    if (await deleteDraft(userId, indexOfLoadedDraft)) {
      emit(LoadedFromDraft(
        body: body,
        title: title,
      ));
    } else {
      // Else, emit an error loading the draft.
      emit(const DraftsError(message: "Error loading selected draft."));
    }
  }
}
