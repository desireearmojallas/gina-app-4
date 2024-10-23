import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<RequestPasswordReset>(requestPasswordReset);
    on<CountdownTickEvent>(onCountdownTick);
    on<CountdownCompleteEvent>(onCountdownComplete);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  Timer? _countdownTimer;

  FutureOr<void> requestPasswordReset(
      RequestPasswordReset event, Emitter<ForgotPasswordState> emit) async {
    emit(RequestPasswordResetLoading());
    try {
      await auth.sendPasswordResetEmail(email: event.email);

      if (emit.isDone) return;

      emit(RequestPasswordResetSuccess());

      if (!emit.isDone) startCountdown(emit);
    } catch (e) {
      if (!emit.isDone) {
        emit(RequestPasswordResetError(errorMessage: e.toString()));
      }
    }
  }

  void startCountdown(Emitter<ForgotPasswordState> emit) {
    int countdown = 18;
    emit(CountdownState(countdown: countdown));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown -= 1;
      debugPrint('Countdown: $countdown');

      add(CountdownTickEvent(countdown: countdown));

      if (countdown <= 0) {
        timer.cancel();
        add(CountdownCompleteEvent());
      }
    });
  }

  FutureOr<void> onCountdownTick(
      CountdownTickEvent event, Emitter<ForgotPasswordState> emit) {
    emit(CountdownState(countdown: event.countdown));
  }

  FutureOr<void> onCountdownComplete(
      CountdownCompleteEvent event, Emitter<ForgotPasswordState> emit) {
    emit(CountdownCompleteState());
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
