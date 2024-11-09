import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/1_controllers/doctor_forums_controller.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';

part 'doctor_forums_event.dart';
part 'doctor_forums_state.dart';

class DoctorForumsBloc extends Bloc<DoctorForumsEvent, DoctorForumsState> {
  final DoctorForumsController docForumsController;
  DoctorForumsBloc({
    required this.docForumsController,
  }) : super(DoctorForumsInitial()) {
    on<DoctorForumsFetchRequestedEvent>(docForumsFetchRequestedEvent);
    on<CreateDoctorForumsPostEvent>(createDoctorForumsPostEvent);
    on<CreateReplyDoctorForumsPostEvent>(createReplyForumsPostEvent);
    on<NavigateToDoctorForumsDetailedPostEvent>(
        navigateToDoctorForumsDetailedPostEvent);
    on<NavigateToDoctorForumsCreatePostEvent>(
        navigateToDoctorForumsCreatePostEvent);
    on<NavigateToDoctorForumsReplyPostEvent>(
        navigateToDoctorForumsReplyPostEvent);
    on<GetRepliesDoctorForumsPostRequestedEvent>(
        getRepliesDoctorForumsPostRequestedEvent);
  }

  FutureOr<void> docForumsFetchRequestedEvent(
      DoctorForumsFetchRequestedEvent event,
      Emitter<DoctorForumsState> emit) async {
    emit(GetDoctorForumsPostsLoadingState());

    final getDoctorRatingIds = await docForumsController.getDoctorRatingIds();
    getDoctorRatingIds.fold((failure) {}, (doctorRatingIds) {
      listDoctorRatingIds = doctorRatingIds;
    });

    final result = await docForumsController.getForumPosts();
    result.fold(
        (failure) =>
            emit(GetDoctorForumsPostsFailedState(message: failure.toString())),
        (forumPosts) {
      if (forumPosts.isEmpty) {
        emit(GetDoctorForumsPostsEmptyState());
      }
      emit(GetDoctorForumsPostsSuccessState(
        forumsPosts: forumPosts,
        doctorRatingIds: listDoctorRatingIds,
      ));
    });
  }

  FutureOr<void> createDoctorForumsPostEvent(CreateDoctorForumsPostEvent event,
      Emitter<DoctorForumsState> emit) async {
    emit(CreateDoctorForumsPostLoadingState());

    final result = await docForumsController.createForumPost(
      title: event.title,
      content: event.content,
      postedAt: event.postedAt,
    );
    result.fold((failure) {
      emit(CreateDoctorForumsPostFailedState());
    }, (success) {
      emit(CreateDoctorForumsPostSuccessState());
    });
  }

  FutureOr<void> createReplyForumsPostEvent(
      CreateReplyDoctorForumsPostEvent event,
      Emitter<DoctorForumsState> emit) async {
    emit(CreateDoctorForumsPostLoadingState());
    int? doctorRatingIdForCreate;

    final result = await docForumsController.addReplyToPost(
      forumPost: event.docForumPost,
      replyContent: event.replyContent,
      repliedAt: event.repliedAt,
    );

    final getDoctorRatingId = await docForumsController.getDoctorRating(
      doctorUid: event.docForumPost.posterUid,
    );

    getDoctorRatingId.fold((failure) {}, (doctorRatingId) {
      doctorRatingIdForCreate = doctorRatingId;
    });

    final repliesPost = await docForumsController.getRepliesPost(
      postId: event.docForumPost.postId,
    );
    result.fold((failure) {
      emit(CreateDoctorForumsPostFailedState());
    }, (success) {
      emit(CreateReplyDoctorForumsPostSuccessState());
      if (repliesPost.isRight()) {
        emit(NavigateToDoctorForumsDetailedPostState(
          doctorForumPost: event.docForumPost,
          forumReplies: repliesPost.getOrElse(() => []),
          doctorRatingId: doctorRatingIdForCreate ?? 0,
        ));
      }
    });
  }

  FutureOr<void> navigateToDoctorForumsDetailedPostEvent(
      NavigateToDoctorForumsDetailedPostEvent event,
      Emitter<DoctorForumsState> emit) async {
    final forumPost = event.docForumPost;
    final repliesPost = await docForumsController.getRepliesPost(
      postId: event.docForumPost.postId,
    );
    final doctorRatingId = event.doctorRatingId;

    repliesPost.fold((failure) {
      emit(GetDoctorForumsPostsFailedState(message: failure.toString()));
    }, (forumReplies) {
      emit(NavigateToDoctorForumsDetailedPostState(
        doctorForumPost: forumPost,
        forumReplies: forumReplies,
        doctorRatingId: doctorRatingId,
      ));
    });
  }

  FutureOr<void> navigateToDoctorForumsCreatePostEvent(
      NavigateToDoctorForumsCreatePostEvent event,
      Emitter<DoctorForumsState> emit) {
    emit(NavigateToDoctorForumsCreatePostState());
  }

  FutureOr<void> navigateToDoctorForumsReplyPostEvent(
      NavigateToDoctorForumsReplyPostEvent event,
      Emitter<DoctorForumsState> emit) {
    emit(NavigateToDoctorForumsReplyPostState(
      docForumPost: event.docForumPost,
    ));
  }

  FutureOr<void> getRepliesDoctorForumsPostRequestedEvent(
      GetRepliesDoctorForumsPostRequestedEvent event,
      Emitter<DoctorForumsState> emit) async {
    emit(GetRepliesDoctorForumsPostLoadingState());
    int? doctorRatingId;

    final repliesPost = await docForumsController.getRepliesPost(
      postId: event.docForumPost.postId,
    );

    final getDoctorRatingId = await docForumsController.getDoctorRating(
      doctorUid: event.docForumPost.posterUid,
    );

    getDoctorRatingId.fold((failure) {}, (doctorRatingId) {
      doctorRatingId = doctorRatingId;
    });

    repliesPost.fold((failure) {
      emit(GetRepliesDoctorForumsPostFailedState(message: failure.toString()));
    }, (replies) {
      emit(GetRepliesDoctorForumsPostSuccessState(
        forumPost: event.docForumPost,
        forumReplies: replies,
        doctorRatingId: doctorRatingId ?? 0,
      ));
    });
  }
}
