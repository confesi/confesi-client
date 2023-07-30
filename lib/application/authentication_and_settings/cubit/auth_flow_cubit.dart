import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/services/fcm_notifications/notification_service.dart';
import 'package:confesi/core/services/hive/hive_client.dart';
import '../../../core/clients/api.dart';
import '../../../core/router/go_router.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/shared/dev.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../init.dart';
import '../../../presentation/shared/overlays/notification_chip.dart';

part 'auth_flow_state.dart';

class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit() : super(AuthFlowDefault());

  bool get isLoading => state is AuthFlowLoading;

  void emitDefault() {
    emit(AuthFlowDefault());
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthFlowLoading());

    if (email.isEmpty) {
      emit(const AuthFlowNotification("Email is empty", NotificationType.failure));
      emit(AuthFlowDefault());
      return;
    }

    (await Api().req(Method.post, false, "/api/v1/auth/send-password-reset-email", {"email": email}))
        .fold((failure) => emit(AuthFlowNotification(failure.message(), NotificationType.failure)), (response) async {
      if (response.statusCode.toString()[0] == "4") {
        emit(const AuthFlowNotification("TODO: 4XX", NotificationType.failure));
      } else if (response.statusCode.toString()[0] == "2") {
        emit(const AuthFlowNotification("Password reset email sent", NotificationType.success));
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    });
  }

  Future<void> sendVerificationEmail() async {
    emit(AuthFlowLoading());
    (await Api().req(Method.post, true, "/api/v1/auth/resend-verification-email", {}))
        .fold((failure) => emit(AuthFlowNotification(failure.message(), NotificationType.failure)), (response) async {
      if (response.statusCode.toString()[0] == "4") {
        emit(const AuthFlowNotification("TODO: 4XX", NotificationType.failure));
      } else if (response.statusCode.toString()[0] == "2") {
        emit(const AuthFlowNotification("Verification email sent", NotificationType.success));
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    });
  }

  Future<void> logout() async {
    emit(AuthFlowLoading());
    await sl.get<HiveService>().clearAllData().then((value) async {
      await sl.get<NotificationService>().deleteTokenFromLocalDb();
      sl.get<UserAuthService>().setNoDataState();
      if (sl.get<UserAuthService>().state is UserAuthNoData) {
        try {
          await sl.get<FirebaseAuth>().signOut();
        } catch (_) {
          emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
        }
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    });
  }

  Future<void> registerAnon() async {
    emit(AuthFlowLoading());
    try {
      UserCredential user = await sl.get<FirebaseAuth>().signInAnonymously();
      if (user.user == null) {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    } catch (_) {
      emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthFlowLoading());
    try {
      UserCredential user = await sl.get<FirebaseAuth>().signInWithEmailAndPassword(email: email, password: password);
      if (user.user == null) {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
      // catch all firebase auth exceptions
    } on FirebaseAuthException catch (e) {
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
    (await Api().req(
      Method.post,
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
      (failure) => emit(AuthFlowNotification(failure.message(), NotificationType.failure)),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(const AuthFlowNotification("TODO: 4XX", NotificationType.failure));
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
