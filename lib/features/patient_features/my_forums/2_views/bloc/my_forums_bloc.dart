import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/my_forums/1_controllers/my_forums_controller.dart';

part 'my_forums_event.dart';
part 'my_forums_state.dart';

class MyForumsBloc extends Bloc<MyForumsEvent, MyForumsState> {
  final MyForumsController myForumsController;
  MyForumsBloc({
    required this.myForumsController,
  }) : super(MyForumsInitial()) {
    on<GetMyForumsPostEvent>(getMyForumsPostEvent);
    on<DeleteMyForumsPostEvent>(deleteMyForumsPost);
  }

  FutureOr<void> getMyForumsPostEvent(
      GetMyForumsPostEvent event, Emitter<MyForumsState> emit) async {
    emit(MyForumsLoadingState());

    final getMyForumsPost = await myForumsController.getListOfMyForumsPost();

    getMyForumsPost.fold(
      (failure) {
        emit(MyForumsErrorState(message: failure.toString()));
      },
      (myForumsPost) {
        emit(MyForumsLoadedState(
          myForumsPosts: myForumsPost,
        ));
      },
    );
  }

  FutureOr<void> deleteMyForumsPost(
      DeleteMyForumsPostEvent event, Emitter<MyForumsState> emit) async {
    final deleteMyForumsPost =
        await myForumsController.deleteMyForumsPost(event.forumUid);

    await deleteMyForumsPost.fold(
      (failure) async {
        emit(MyForumsErrorState(message: failure.toString()));
      },
      (success) async {
        final getMyForumsPost =
            await myForumsController.getListOfMyForumsPost();

        await getMyForumsPost.fold(
          (failure) async {
            emit(MyForumsErrorState(message: failure.toString()));
          },
          (myForumsPost) async {
            emit(MyForumsLoadedState(
              myForumsPosts: myForumsPost,
            ));
          },
        );
      },
    );
  }
}
