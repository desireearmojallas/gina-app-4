import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
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
    on<DeleteMyForumsPostEvent>(deleteMyForumsPost);
  }

  Future<void> getMyForumsPost(GetMyDoctorForumsPostEvent event,
      Emitter<DoctorMyForumsState> emit) async {
    emit(GetMyForumsLoadingState());
    debugPrint('Fetching my forum posts...');

    final getMyForumsPost = await myForumsController.getListOfMyForumsPost();

    await getMyForumsPost.fold(
      (failure) async {
        debugPrint('Failed to fetch my forums posts: $failure');
        emit(GetMyForumsPostErrorState(error: failure.toString()));
      },
      (myForumsPost) async {
        debugPrint('Fetched my forums posts successfully');
        if (myForumsPost.isEmpty) {
          emit(GetMyForumsPostEmptyState());
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
          emit(GetMyForumsPostState(
            myForumsPost: myForumsPost,
            currentUser: myForumsController.currentUser!,
            doctorModel: doctorModel,
          ));
        }
      },
    );
  }

  Future<void> deleteMyForumsPost(
      DeleteMyForumsPostEvent event, Emitter<DoctorMyForumsState> emit) async {
    debugPrint('Deleting forum post with ID: ${event.forumUid}');
    final deleteMyForumsPost =
        await myForumsController.deleteMyForumsPost(event.forumUid);

    await deleteMyForumsPost.fold(
      (failure) async {
        debugPrint('Failed to delete forum post: $failure');
        emit(GetMyForumsPostErrorState(error: failure.toString()));
      },
      (success) async {
        debugPrint('Deleted forum post successfully');
        emit(DeleteMyForumsPostSuccessState());
        final getMyForumsPost =
            await myForumsController.getListOfMyForumsPost();

        await getMyForumsPost.fold(
          (failure) async {
            debugPrint(
                'Failed to fetch my forums posts after deletion: $failure');
            emit(GetMyForumsPostErrorState(error: failure.toString()));
          },
          (myForumsPost) async {
            debugPrint('Fetched my forums posts successfully after deletion');
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
            emit(GetMyForumsPostState(
              myForumsPost: myForumsPost,
              currentUser: myForumsController.currentUser!,
              doctorModel: doctorModel,
            ));
          },
        );
      },
    );
  }
}
