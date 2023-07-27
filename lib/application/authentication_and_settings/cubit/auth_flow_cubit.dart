import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../init.dart';
import '../../../presentation/shared/overlays/notification_chip.dart';

part 'auth_flow_state.dart';

class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit() : super(AuthFlowDefault());

  bool get isLoading => state is AuthFlowLoading;

  Future<void> sendPasswordResetEmail() async {
    emit(AuthFlowLoading());
    (await Api().req(Method.post, true, "/api/v1/auth/send-password-reset-email", {}))
        .fold((failure) => emit(AuthFlowNotification(failure.message, NotificationType.failure)), (response) async {
      if (response.statusCode.toString()[0] == "4") {
        emit(const AuthFlowNotification("TODO: 4XX", NotificationType.failure));
      } else if (response.statusCode.toString()[0] == "2") {
        emit(const AuthFlowNotification("Password reset email sent", NotificationType.success));
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    });
    emit(AuthFlowDefault());
  }

  Future<void> sendVerificationEmail() async {
    emit(AuthFlowLoading());
    (await Api().req(Method.post, true, "/api/v1/auth/resend-verification-email", {}))
        .fold((failure) => emit(AuthFlowNotification(failure.message, NotificationType.failure)), (response) async {
      if (response.statusCode.toString()[0] == "4") {
        emit(const AuthFlowNotification("TODO: 4XX", NotificationType.failure));
      } else if (response.statusCode.toString()[0] == "2") {
        emit(const AuthFlowNotification("Password reset email sent", NotificationType.success));
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    });
    emit(AuthFlowDefault());
  }

  Future<void> logout() async {
    emit(AuthFlowLoading());
    await sl.get<UserAuthService>().clearData().then((value) async {
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
    emit(AuthFlowDefault());
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
    emit(AuthFlowDefault());
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
      } else {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      }
    } catch (e) {
      emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
    }
    emit(AuthFlowDefault());
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
      // get new user
      final refreshedUser = firebaseAuth.currentUser;
      if (refreshedUser == null) {
        emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
        return;
      }
      if (!refreshedUser.emailVerified) {
        emit(const AuthFlowNotification("Not verified", NotificationType.failure));
        return;
      } else {
        emit(const AuthFlowNotification("Verified", NotificationType.success));
      }
    } catch (_) {
      emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
      return;
    }

    emit(AuthFlowDefault());
  }

  Future<void> register(String email, String password, String confirmPassword) async {
    emit(AuthFlowLoading());

    if (password != confirmPassword) {
      emit(const AuthFlowNotification("Passwords don't match", NotificationType.failure));
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
      },
    ))
        .fold(
      (failure) => emit(AuthFlowNotification(failure.message, NotificationType.failure)),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(const AuthFlowNotification("TODO: 4XX", NotificationType.failure));
        } else {
          try {
            var res = await sl.get<FirebaseAuth>().signInWithEmailAndPassword(email: email, password: password);
            if (res.user == null) {
              emit(const AuthFlowNotification("Unknown error", NotificationType.failure));
            }
          } catch (_) {
            emit(const AuthFlowNotification("Registered, but unable to login", NotificationType.failure));
          }
        }
      },
    );
    emit(AuthFlowDefault());
  }
}
