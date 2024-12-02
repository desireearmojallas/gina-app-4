import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/my_forums/1_controllers/my_forums_controller.dart';

part 'doctor_my_forums_event.dart';
part 'doctor_my_forums_state.dart';

class DoctorMyForumsBloc
    extends Bloc<DoctorMyForumsEvent, DoctorMyForumsState> {
  final MyForumsController myForumsController;

  DoctorMyForumsBloc({
    required this.myForumsController,
  }) : super(DoctorMyForumsInitial()) {
    on<GetMyDoctorForumsPostEvent>(getMyForumsPost);
  }

  FutureOr<void> getMyForumsPost(GetMyDoctorForumsPostEvent event,
      Emitter<DoctorMyForumsState> emit) async {
    emit(GetMyForumsLoadingState());

    final getMyForumsPost = await myForumsController.getListOfMyForumsPost();

    getMyForumsPost.fold(
      (failure) {
        emit(GetMyForumsPostErrorState(error: failure.toString()));
      },
      (myForumsPost) {
        myForumsPost.isEmpty
            ? emit(GetMyForumsPostEmptyState())
            : emit(GetMyForumsPostState(myForumsPost: myForumsPost));
      },
    );
  }
}
