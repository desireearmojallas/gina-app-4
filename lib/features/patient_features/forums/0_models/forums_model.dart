import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumModel extends Equatable {
  final dynamic postId;
  final String posterUid;
  final String postedBy;
  final String title;
  final String content;
  final Timestamp postedAt;
  final String profileImage;
  final bool isDoctor;
  final int doctorRatingId;
  final List<ForumModel> replies;

  const ForumModel({
    required this.postId,
    required this.posterUid,
    required this.postedBy,
    required this.title,
    required this.content,
    required this.profileImage,
    required this.postedAt,
    required this.isDoctor,
    required this.doctorRatingId,
    required this.replies,
  });

  factory ForumModel.fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};
    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }

    return ForumModel(
      postId: snap.id,
      posterUid: json['posterUid'] ?? '',
      title: json['title'] ?? '',
      content: json['description'] ?? '',
      postedBy: json['postedBy'] ?? '',
      profileImage: json['profileImage'] ?? '',
      postedAt: json['postedAt'] ?? Timestamp.now(),
      isDoctor: json['isDoctor'] ?? false,
      replies: json['replies'] != null
          ? List<ForumModel>.from(
              json['replies'].map((x) => ForumModel.fromJson(x)))
          : [],
      doctorRatingId: json['doctorRatingId'] ?? 0,
    );
  }

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      postId: json['id'],
      posterUid: json['posterUid'] ?? '',
      title: json['title'] ?? '',
      content: json['description'] ?? '',
      postedBy: json['postedBy'] ?? '',
      profileImage: json['profileImage'] ?? '',
      postedAt: json['postedAt'] ?? Timestamp.now(),
      isDoctor: json['isDoctor'] ?? false,
      replies: json['replies'] != null
          ? List<ForumModel>.from(
              json['replies'].map((x) => ForumModel.fromJson(x)))
          : [],
      doctorRatingId: json['doctorRatingId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': postId,
      'posterUid': posterUid,
      'title': title,
      'content': content,
      'postedBy': postedBy,
      'profileImage': profileImage,
      'postedAt': postedAt,
      'isDoctor': isDoctor,
      'replies': replies,
      'doctorRatingId': doctorRatingId,
    };
  }

  @override
  List<Object?> get props => [
        postId,
        posterUid,
        title,
        content,
        postedBy,
        postedAt,
        isDoctor,
        replies,
        doctorRatingId,
      ];
}
