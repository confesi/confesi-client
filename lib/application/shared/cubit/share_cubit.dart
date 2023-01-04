import '../../../core/usecases/no_params.dart';
import '../../../domain/shared/usecases/share_content.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'share_state.dart';

class ShareCubit extends Cubit<ShareState> {
  final ShareContent shareContentUsecase;

  ShareCubit({required this.shareContentUsecase}) : super(ShareBase());

  /// Sets the share state back to base (resting) state.
  void setToBase() => emit(ShareBase());

  /// Shares the content via the OS' native menu.
  void shareContent(BuildContext context, String message, String subject) async {
    (await shareContentUsecase.call(ShareParams(context: context, message: message, subject: subject))).fold(
      (failure) {
        emit(const ShareError(message: "Unexpected error. Unable to share."));
      },
      (success) => {}, // Nothing needed if it works, as the share menu would clearly be opening
    );
  }
}
