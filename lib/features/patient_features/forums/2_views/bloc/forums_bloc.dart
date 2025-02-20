import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/1_controllers/forums_controller.dart';

part 'forums_event.dart';
part 'forums_state.dart';

List<int> listDoctorRatingIds = [];

class ForumsBloc extends Bloc<ForumsEvent, ForumsState> {
  final ForumsController forumsController;
  ForumsBloc({required this.forumsController}) : super(ForumsInitial()) {
    on<ForumsFetchRequestedEvent>(forumsFetchRequestedEvent);
    on<CreateForumsPostEvent>(createForumsPostEvent);
    on<NavigateToForumsDetailedPostEvent>(navigateToForumsDetailedPostEvent);
    on<NavigateToForumsCreatePostEvent>(navigateToForumsCreatePostEvent);
    on<NavigateToForumsReplyPostEvent>(navigateToForumsReplyPostEvent);
    on<CreateReplyForumsPostEvent>(createReplyForumsPostEvent);
    on<GetRepliesForumsPostEvent>(getRepliesForumsPostEvent);
  }

  FutureOr<void> forumsFetchRequestedEvent(
      ForumsFetchRequestedEvent event, Emitter<ForumsState> emit) async {
    emit(GetForumsPostsLoadingState());

    final getDoctorRatingIds = await forumsController.getDoctorRatingIds();
    getDoctorRatingIds.fold((failure) {}, (doctorRatingIds) {
      listDoctorRatingIds = doctorRatingIds;
    });

    final result = await forumsController.getForumsPosts();
    result.fold((failure) {
      emit(GetForumsPostsFailedState(message: failure.toString()));
    }, (forumsPosts) {
      if (forumsPosts.isEmpty) {
        emit(GetForumsPostsEmptyState());
      }
      emit(GetForumsPostsSuccessState(
        forumsPosts: forumsPosts,
        doctorRatingIds: listDoctorRatingIds,
      ));
    });
  }

  FutureOr<void> createForumsPostEvent(
      CreateForumsPostEvent event, Emitter<ForumsState> emit) async {
    emit(CreateForumsPostLoadingState());

    final result = await forumsController.createForumPost(
      title: event.title,
      content: event.content,
      postedAt: event.postedAt,
    );
    result.fold((failure) {
      emit(CreateForumsPostFailedState());
    }, (success) {
      emit(CreateForumsPostSuccessState());
    });
  }

  FutureOr<void> navigateToForumsDetailedPostEvent(
      NavigateToForumsDetailedPostEvent event,
      Emitter<ForumsState> emit) async {
    debugPrint('NavigateToForumsDetailedPostEvent received');
    final forumPost = event.forumPost;

    final repliesPost = await forumsController.getRepliesPost(
      postId: forumPost.postId,
    );

    final doctorRatingId = event.doctorRatingId;

    repliesPost.fold((failure) {
      emit(GetForumsPostsFailedState(message: failure.toString()));
    }, (replies) {
      emit(NavigateToForumsDetailedPostState(
        forumPost: forumPost,
        forumReplies: replies,
        doctorRatingId: doctorRatingId,
        currentUser: forumsController.currentUser,
      ));
    });
  }

  FutureOr<void> navigateToForumsCreatePostEvent(
      NavigateToForumsCreatePostEvent event, Emitter<ForumsState> emit) async {
    emit(NavigateToForumsCreatePostState());
  }

  FutureOr<void> navigateToForumsReplyPostEvent(
      NavigateToForumsReplyPostEvent event, Emitter<ForumsState> emit) async {
    emit(NavigateToForumsReplyPostState(
      forumPost: event.forumPost,
    ));
  }

  FutureOr<void> createReplyForumsPostEvent(
      CreateReplyForumsPostEvent event, Emitter<ForumsState> emit) async {
    emit(CreateReplyForumsPostLoadingState());
    int? doctorRatingIdForCreate;
    final result = await forumsController.addReplyToPost(
      forumPost: event.forumPost,
      replyContent: event.replyContent,
      repliedAt: event.repliedAt,
    );

    final getDoctorRatingId = await forumsController.getDoctorRating(
      doctorUid: event.forumPost.posterUid,
    );

    getDoctorRatingId.fold((failure) {}, (doctorRatingId) {
      doctorRatingIdForCreate = doctorRatingId;
    });

    final repliesPost = await forumsController.getRepliesPost(
      postId: event.forumPost.postId,
    );

    result.fold((failure) {
      emit(CreateReplyForumsPostFailedState());
    }, (success) {
      emit(CreateForumsPostSuccessState());
      if (repliesPost.isRight()) {
        emit(GetRepliesForumsPostSuccessState(
          forumPost: event.forumPost,
          forumReplies: repliesPost.getOrElse(() => []),
          doctorRatingId: doctorRatingIdForCreate ?? 0,
          currentUser: forumsController.currentUser,
        ));
      }
    });
  }

  FutureOr<void> getRepliesForumsPostEvent(
      GetRepliesForumsPostEvent event, Emitter<ForumsState> emit) async {
    emit(GetRepliesForumsPostLoadingState());
    int? doctorRatingId;

    final forumPostId = event.forumPost.postId;
    final getDoctorRatingId = await forumsController.getDoctorRating(
      doctorUid: event.forumPost.posterUid,
    );

    getDoctorRatingId.fold((failure) {}, (doctorRatingId) {
      doctorRatingId = doctorRatingId;
    });

    final repliesPost = await forumsController.getRepliesPost(
      postId: forumPostId,
    );

    repliesPost.fold((failure) {
      emit(GetRepliesForumsPostFailedState(message: failure.toString()));
    }, (replies) {
      emit(GetRepliesForumsPostSuccessState(
        forumPost: event.forumPost,
        forumReplies: replies,
        doctorRatingId: doctorRatingId ?? 0,
        currentUser: forumsController.currentUser,
      ));
    });
  }
}
