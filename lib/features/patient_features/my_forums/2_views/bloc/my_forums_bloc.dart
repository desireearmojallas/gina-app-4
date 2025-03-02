import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
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

  Future<void> getMyForumsPostEvent(
      GetMyForumsPostEvent event, Emitter<MyForumsState> emit) async {
    emit(MyForumsLoadingState());

    final getMyForumsPost = await myForumsController.getListOfMyForumsPost();

    await getMyForumsPost.fold(
      (failure) async {
        emit(MyForumsErrorState(message: failure.toString()));
      },
      (myForumsPost) async {
        if (myForumsPost.isEmpty) {
          emit(MyForumsEmptyState());
        } else {
          DoctorModel? doctorModel;
          if (myForumsController.currentUser != null) {
            final doctorDoc = await FirebaseFirestore.instance
                .collection('doctors')
                .doc(myForumsController.currentUser!.uid)
                .get();
            if (doctorDoc.exists) {
              doctorModel = DoctorModel.fromDocumentSnap(doctorDoc);
            }
          }

          debugPrint('Doctor Model: $doctorModel');
          emit(MyForumsLoadedState(
            myForumsPosts: myForumsPost,
            currentUser: myForumsController.currentUser!,
            doctorModel: doctorModel,
          ));
        }
      },
    );
  }

  Future<void> deleteMyForumsPost(
      DeleteMyForumsPostEvent event, Emitter<MyForumsState> emit) async {
    final deleteMyForumsPost =
        await myForumsController.deleteMyForumsPost(event.forumUid);

    await deleteMyForumsPost.fold(
      (failure) async {
        emit(MyForumsErrorState(message: failure.toString()));
      },
      (success) async {
        debugPrint('Deleted forum post successfully');
        emit(DeleteMyForumsPostSuccessState());
        final getMyForumsPost =
            await myForumsController.getListOfMyForumsPost();

        await getMyForumsPost.fold(
          (failure) async {
            emit(MyForumsErrorState(message: failure.toString()));
          },
          (myForumsPost) async {
            DoctorModel? doctorModel;
            if (myForumsController.currentUser != null) {
              final doctorDoc = await FirebaseFirestore.instance
                  .collection('doctors')
                  .doc(myForumsController.currentUser!.uid)
                  .get();
              if (doctorDoc.exists) {
                doctorModel = DoctorModel.fromDocumentSnap(doctorDoc);
              }
            }
            emit(MyForumsLoadedState(
              myForumsPosts: myForumsPost,
              currentUser: myForumsController.currentUser!,
              doctorModel: doctorModel,
            ));
          },
        );
      },
    );
  }
}
