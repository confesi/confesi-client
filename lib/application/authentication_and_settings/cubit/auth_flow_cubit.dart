import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_flow_state.dart';

class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit() : super(const AuthFlowEnteringData());

  bool get isLoading => state is AuthFlowEnteringData && (state as AuthFlowEnteringData).mode is EnteringLoading;

  Future<void> login(String email, String password) async {
    if (state is AuthFlowEnteringData) {
      final enteringState = state as AuthFlowEnteringData;
      emit(enteringState.copyWith(mode: const EnteringLoading()));
      await Future.delayed(const Duration(seconds: 2));
      emit(enteringState.copyWith(mode: const EnteringRegular(), email: email, password: password));
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
      await Future.delayed(const Duration(seconds: 2));
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
