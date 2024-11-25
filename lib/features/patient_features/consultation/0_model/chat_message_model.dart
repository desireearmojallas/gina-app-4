// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatMessageModel extends Equatable {
  final String? uid;
  final String? authorUid;
  final String? authorName;
  final String? authorImage;
  final Timestamp? createdAt;
  final String? patientName;
  final String? patientUid;
  final String? doctorName;
  final String? doctorUid;
  final String? message;
  List<String> seenBy;
  bool isDeleted;
  bool isEdited;

  ChatMessageModel({
    this.uid,
    this.authorUid,
    this.authorName,
    this.authorImage,
    this.createdAt,
    this.patientName,
    this.patientUid,
    this.doctorName,
    this.doctorUid,
    this.message,
    this.seenBy = const [],
    this.isDeleted = false,
    this.isEdited = false,
  });

  static ChatMessageModel fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatMessageModel(
      uid: snap.id,
      authorUid: json['authorUid'] ?? '',
      authorImage: json['authorImage'] ?? '',
      patientName: json['patientName'] ?? '',
      patientUid: json['patientUid'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorUid: json['doctorUid'] ?? '',
      seenBy: json['seenBy'] != null
          ? List<String>.from(json['seenBy'])
          : <String>[],
      message: json['message'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      isEdited: json['isEdited'] ?? false,
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      uid: json['uid'],
      authorUid: json['authorUid'] ?? '',
      authorName: json['authorName'] ?? '',
      authorImage: json['authorImage'] ?? '',
      patientName: json['patientName'] ?? '',
      patientUid: json['patientUid'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorUid: json['doctorUid'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      message: json['message'] ?? '',
      seenBy: json['seenBy'] != null
          ? List<String>.from(json['seenBy'])
          : <String>[],
      isDeleted: json['isDeleted'] ?? false,
      isEdited: json['isEdited'] ?? false,
    );
  }

  static ChatMessageModel fromDocumentSnapWithRoomId(
      DocumentSnapshot snap, String roomId) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatMessageModel(
      uid: snap.id,
      authorUid: json['authorUid'] ?? '',
      authorImage: json['authorImage'] ?? '',
      patientName: json['patientName'] ?? '',
      patientUid: json['patientUid'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorUid: json['doctorUid'] ?? '',
      seenBy: json['seenBy'] != null
          ? List<String>.from(json['seenBy'])
          : <String>[],
      message: json['message'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      isEdited: json['isEdited'] ?? false,
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> get json => {
        'authorUid': authorUid,
        'authorName': authorName,
        'authorImage': authorImage,
        'patientName': patientName,
        'patientUid': patientUid,
        'doctorName': doctorName,
        'doctorUid': doctorUid,
        'message': message,
        'seenBy': seenBy,
        'isDeleted': isDeleted,
        'isEdited': isEdited,
        'createdAt': createdAt,
      };

  static Stream<List<ChatMessageModel>> individualCurrentChats(
          String chatroom) =>
      FirebaseFirestore.instance
          .collection('consultation-chatrooms')
          .doc(chatroom)
          .collection('messages')
          .orderBy('createdAt')
          .snapshots()
          .map(ChatMessageModel.fromQuerySnap);

  static List<ChatMessageModel> fromQuerySnap(QuerySnapshot snap) {
    try {
      return snap.docs.map(ChatMessageModel.fromDocumentSnap).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  bool hasNotSeenMessage(String uid) {
    return !seenBy.contains(uid);
  }

  Future individualUpdateSeen(String userID, String chatroom) {
    return FirebaseFirestore.instance
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('messages')
        .doc(uid)
        .update({
      'seenBy': FieldValue.arrayUnion([userID])
    });
  }

  @override
  List<Object?> get props => [
        uid,
        authorUid,
        authorName,
        authorImage,
        createdAt,
        message,
        seenBy,
        isDeleted,
        isEdited,
      ];
}
