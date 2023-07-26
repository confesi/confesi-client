import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../init.dart';

part 'auth_flow_state.dart';

class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit() : super(const AuthFlowEnteringData());

  bool get isLoading => state is AuthFlowEnteringData && (state as AuthFlowEnteringData).mode is EnteringLoading;

  void setEmptyFields() async {
    if (state is AuthFlowEnteringData) {
      final AuthFlowEnteringData currentState = state as AuthFlowEnteringData;
      emit(currentState.copyWith(email: "", password: ""));
    }
  }

  Future<void> resendVerificationEmail() async {
    if (state is AuthFlowEnteringData) {
      final enteringState = state as AuthFlowEnteringData;
      emit(enteringState.copyWith(mode: const EnteringLoading()));
      (await Api().req(Method.post, true, "/api/v1/auth/resend-verification-email", {}))
          .fold((failure) => emit(enteringState.copyWith(mode: EnteringError(failure.message))), (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(enteringState.copyWith(mode: const EnteringError("TODO: error message here")));
        } else if (sl.get<FirebaseAuth>().currentUser != null && response.statusCode.toString()[0] == "2") {
          try {
            // don't care if this works or fails
            IdTokenResult token = await sl.get<FirebaseAuth>().currentUser!.getIdTokenResult(true);
          } catch (_) {}
        } else {
          emit(enteringState.copyWith(mode: const EnteringError("Unknown error.")));
          return;
        }
      });
      emit(enteringState.copyWith(mode: const EnteringRegular()));
    }
  }

  Future<void> logout() async {
    emit(const AuthFlowEnteringData(mode: EnteringLoading()));
    await sl.get<UserAuthService>().clearData().then((value) async {
      if (sl.get<UserAuthService>().state is UserAuthNoData) {
        try {
          await sl.get<FirebaseAuth>().signOut();
        } catch (_) {
          emit(const AuthFlowEnteringData(mode: EnteringError("Couldn't log out. Try again later.")));
        }
      } else {
        emit(const AuthFlowEnteringData(mode: EnteringError("Couldn't log out. Try again later.")));
      }
    });
  }

  Future<void> registerAnon() async {
    if (state is AuthFlowEnteringData) {
      final enteringState = state as AuthFlowEnteringData;
      emit(enteringState.copyWith(mode: const EnteringLoading()));
      try {
        await sl.get<FirebaseAuth>().signInAnonymously();
      } catch (_) {
        emit(enteringState.copyWith(mode: const EnteringError('An error occurred. Please try again later.')));
      }
    }
  }

  Future<void> login(String email, String password) async {
    if (state is AuthFlowEnteringData) {
      final enteringState = state as AuthFlowEnteringData;
      emit(enteringState.copyWith(mode: const EnteringLoading()));
      try {
        await sl.get<FirebaseAuth>().signInWithEmailAndPassword(email: email, password: password);
        // catch all firebase auth exceptions
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(enteringState.copyWith(mode: const EnteringError('No user found for that email.')));
        } else if (e.code == 'wrong-password') {
          emit(enteringState.copyWith(mode: const EnteringError('Wrong password provided for that user.')));
        } else if (e.code == 'invalid-email') {
          emit(enteringState.copyWith(mode: const EnteringError('Invalid email provided.')));
        } else {
          emit(enteringState.copyWith(mode: const EnteringError('An error occurred. Please try again later.')));
        }
      } catch (e) {
        emit(enteringState.copyWith(mode: const EnteringError('An error occurred. Please try again later.')));
      }
    }
  }

  Future<void> refreshToken() async {
    if (state is AuthFlowEnteringData) {
      final enteringState = state as AuthFlowEnteringData;
      emit(enteringState.copyWith(mode: const EnteringLoading()));
      try {
        // don't care if this works or fails
        IdTokenResult token = await sl.get<FirebaseAuth>().currentUser!.getIdTokenResult(true);
        if (token.token != null) {
          // todo OG onTap body
        } else {
          emit(enteringState.copyWith(mode: const EnteringError("Temporary error, try again later.")));
        }
      } catch (_) {
        emit(enteringState.copyWith(mode: const EnteringError("Temporary error, try again later.")));
      }
    }
  }

  Future<void> register(String email, String password, String confirmPassword) async {
    if (state is AuthFlowEnteringData) {
      final enteringState = state as AuthFlowEnteringData;
      emit(enteringState.copyWith(mode: const EnteringLoading()));
      if (password != confirmPassword) {
        emit(enteringState.copyWith(mode: const EnteringError("Passwords don't match")));
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
        (failure) => emit(enteringState.copyWith(mode: EnteringError(failure.message))),
        (response) async {
          if (response.statusCode.toString()[0] == "4") {
            emit(enteringState.copyWith(mode: const EnteringError("TODO: error message here")));
          } else {
            var res = await sl.get<FirebaseAuth>().signInWithEmailAndPassword(email: email, password: password);
            if (res.user == null) {
              emit(enteringState.copyWith(
                  mode: const EnteringError("Account successfully created, but couldn't log in.")));
            }
          }
        },
      );
      emit(enteringState.copyWith(mode: const EnteringRegular(), email: email, password: password));
    }
  }

  void updateEmail(String value) {
    if (state is AuthFlowEnteringData) {
      final AuthFlowEnteringData currentState = state as AuthFlowEnteringData;
      emit(currentState.copyWith(email: value));
    }
  }

  void updatePassword(String value) {
    if (state is AuthFlowEnteringData) {
      final AuthFlowEnteringData currentState = state as AuthFlowEnteringData;
      emit(currentState.copyWith(password: value));
    }
  }
}
