import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
import 'package:confesi/core/services/fcm_notifications/notification_service.dart';
import 'package:confesi/core/services/hive_client/hive_client.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:flutter/widgets.dart';
import '../../../core/services/api_client/api.dart';
import '../../../core/router/go_router.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/shared/constants.dart';
import '../../../init.dart';
import '../../../presentation/shared/overlays/screen_overlay.dart';

part 'auth_flow_state.dart';

class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit(this._api) : super(AuthFlowDefault());

  final Api _api;

  bool get isLoading => state is AuthFlowLoading;

  void clear() {
    _api.cancelCurrReq();
    emit(AuthFlowDefault());
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _api.cancelCurrReq();

    emit(AuthFlowLoading());

    if (email.isEmpty) {
      emit(const AuthFlowNotification("Email is empty", NotificationType.failure));
      emit(AuthFlowDefault());
      return;
    }

    (await _api.req(Verb.post, false, "/api/v1/auth/send-password-reset-email", {"email": email}))
        .fold((failure) => emit(AuthFlowNotification(failure.msg(), NotificationType.failure)), (response) async {
      if (response.statusCode.toString()[0] == "4") {
        emit(AuthFlowNotification(ApiErrors.err(response), NotificationType.failure));
      } else if (response.statusCode.toString()[0] == "2") {
        emit(const AuthFlowNotification("Password reset email sent", NotificationType.success));
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    });
  }

  Future<void> sendVerificationEmail() async {
    _api.cancelCurrReq();

    emit(AuthFlowLoading());
    (await _api.req(Verb.post, true, "/api/v1/auth/resend-verification-email", {}))
        .fold((failure) => emit(AuthFlowNotification(failure.msg(), NotificationType.failure)), (response) async {
      if (response.statusCode.toString()[0] == "4") {
        emit(AuthFlowNotification(ApiErrors.err(response), NotificationType.failure));
      } else if (response.statusCode.toString()[0] == "2") {
        emit(const AuthFlowNotification("Verification email sent", NotificationType.success));
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    });
  }

  Future<void> logout(BuildContext context) async {
    _api.cancelCurrReq();
    emit(AuthFlowLoading());

    sl.get<HiveService>().clearAllLocalData().then((result) {
      result.fold(
        (failure) => emit(const AuthFlowNotification("Unknown error", NotificationType.failure)),
        (success) {
          sl.get<NotificationService>().deleteTokenFromLocalDb().then((_) {
            sl.get<FirebaseAuth>().signOut().then((_) {
              clear();
              Future.delayed(const Duration(
                      milliseconds: 1000)) // enough delay for the logout animation to finish before resetting state
                  .then((value) => sl.get<UserAuthService>().clearAllAppState(context));
            }).catchError((_) {
              emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
            });
          }).catchError((_) {
            emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
          });
        },
      );
    }).catchError((_) {
      emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
    });
  }

  Future<void> registerAnon() async {
    _api.cancelCurrReq();

    emit(AuthFlowLoading());
    try {
      UserCredential user = await sl.get<FirebaseAuth>().signInAnonymously();
      if (user.user == null) {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
      clear();
    } catch (_) {
      emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    _api.cancelCurrReq();

    emit(AuthFlowLoading());
    try {
      sl.get<FirebaseAuth>().signInWithEmailAndPassword(email: email, password: password).then((UserCredential user) {
        if (user.user == null) {
          emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
        } else {
          sl.get<UserAuthService>().reloadAppStateThatNeedsAuth(context);
        }
        clear();
      });

      // catch all firebase auth exceptions
    } on FirebaseAuthException catch (e) {
      print("caught some exception here!!!!!!!!!!");
      if (e.code == 'user-not-found') {
        emit(const AuthFlowNotification("User not found", NotificationType.failure));
      } else if (e.code == 'wrong-password') {
        emit(const AuthFlowNotification("Wrong password", NotificationType.failure));
      } else if (e.code == 'invalid-email') {
        emit(const AuthFlowNotification("Invalid email", NotificationType.failure));
      } else if (e.code == 'user-disabled') {
        emit(const AuthFlowNotification("Your account has been disabled", NotificationType.failure));
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    } catch (e) {
      emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
    }
  }

  Future<void> refreshToken() async {
    _api.cancelCurrReq();

    emit(AuthFlowLoading());

    try {
      final firebaseAuth = sl.get<FirebaseAuth>();
      final currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
        return;
      }

      // refresh old account
      await currentUser.reload();
      sl.get<StreamController<User?>>().add(sl.get<FirebaseAuth>().currentUser);
      // get new user
      final refreshedUser = firebaseAuth.currentUser;
      if (refreshedUser == null) {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
        return;
      }
      if (!refreshedUser.emailVerified) {
        emit(const AuthFlowNotification("Not verified", NotificationType.failure));
        return;
      }
    } catch (_) {
      emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      return;
    }
  }

  Future<void> register(String email, String password, String confirmPassword,
      {bool upgradingToFullAcc = false}) async {
    _api.cancelCurrReq();

    emit(AuthFlowLoading());

    if (password != confirmPassword) {
      emit(const AuthFlowNotification("Passwords don't match", NotificationType.failure));
      emit(AuthFlowDefault());
      return;
    }

    if (password.length < passwordMinLength) {
      emit(const AuthFlowNotification(
          "Password must be at least $passwordMinLength characters", NotificationType.failure));
      emit(AuthFlowDefault());
      return;
    }
    (await _api.req(
      Verb.post,
      false,
      "/api/v1/auth/register",
      <String, dynamic>{
        "email": email,
        "password": password,
        "already_existing_acc_token":
            upgradingToFullAcc ? await sl.get<FirebaseAuth>().currentUser?.getIdToken() : null,
      },
    ))
        .fold(
      (failure) => emit(AuthFlowNotification(failure.msg(), NotificationType.failure)),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(AuthFlowNotification(ApiErrors.err(response), NotificationType.failure));
        } else {
          try {
            if (upgradingToFullAcc) {
              final firebaseAuth = sl.get<FirebaseAuth>();
              final currentUser = firebaseAuth.currentUser;
              if (currentUser == null) {
                emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
                return;
              }
            }
            var res = await sl.get<FirebaseAuth>().signInWithEmailAndPassword(email: email, password: password);
            if (res.user == null) {
              emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
              return;
            }
            final user = sl.get<FirebaseAuth>().currentUser;
            if (user == null) {
              emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
              return;
            }
            if (upgradingToFullAcc) sl.get<StreamController<User?>>().add(sl.get<FirebaseAuth>().currentUser);
          } catch (err) {
            print("THIS ROUTE e: $err");
            emit(const AuthFlowNotification("Registered, but unable to login", NotificationType.failure));
            router.go("/login");
          }
        }
      },
    );
  }
}
