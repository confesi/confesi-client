import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/models/notification_log.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/api_client/api.dart';
import '../../../init.dart';

part 'noti_server_state.dart';

class NotiServerCubit extends Cubit<NotiServerState> {
  NotiServerCubit(this._api) : super(const NotiServerData([], NotiServerFeedState.feedLoading, null));

  final Api _api;

  /// loads notifications from server
  ///
  /// [next] is the cursor for pagination (null to reset pagination)
  Future<void> loadNotis({bool refresh = false}) async {
    _api.cancelCurrReq();
    int? nextCursor;
    if (refresh) {
      // clear
      sl.get<GlobalContentService>().clearServerNotis();
      if (state is NotiServerData) {
        (state as NotiServerData).setNext(null);
      }
    } else {
      if (state is NotiServerData) {
        nextCursor = (state as NotiServerData).next;
      }
    }
    (await _api.req(Verb.get, true, "/api/v1/notifications/notifications", {
      "next": nextCursor,
    }))
        .fold(
      (failureWithMsg) {
        // set feed state to error
        if (state is NotiServerData) {
          emit((state as NotiServerData).copyWith(feedState: NotiServerFeedState.errorLoadingMore));
        } else {
          emit(NotiServerError(message: failureWithMsg.msg()));
        }
      },
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          try {
            final NotificationLog notiLog = NotificationLog.fromJson(json.decode(response.body)["value"]);
            sl.get<GlobalContentService>().addServerNotis(notiLog.notifications);
            // check if empty, if so, set feed state to no more
            if (notiLog.notifications.isEmpty) {
              if (state is NotiServerData) {
                emit((state as NotiServerData).copyWith(feedState: NotiServerFeedState.noMore, next: notiLog.next));
              } else {
                emit(NotiServerData(
                    notiLog.notifications.map((e) => e.id).toList(), NotiServerFeedState.feedLoading, notiLog.next));
              }
            } else {
              emit(NotiServerData(
                  notiLog.notifications.map((e) => e.id).toList(), NotiServerFeedState.noMore, notiLog.next));
            }
          } catch (_) {
            // set feed state to error
            if (state is NotiServerData) {
              emit((state as NotiServerData).copyWith(feedState: NotiServerFeedState.errorLoadingMore));
            } else {
              emit(const NotiServerError(message: "todo: error"));
            }
          }
        }
      },
    );
  }
}
