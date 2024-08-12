// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String profileImage;
  final String headerImage;
  final String accountType;
  final String address;
  Timestamp? created, updated;
  List<String> chatrooms;
  List<String> appointmentsBooked;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.profileImage,
    required this.headerImage,
    required this.accountType,
    required this.address,
    this.created,
    this.updated,
    required this.chatrooms,
    required this.appointmentsBooked,
  });

  static UserModel fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};
    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }
    return UserModel(
      uid: snap.id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      profileImage: json['profileImage'] ?? '',
      headerImage: json['headerImage'] ?? '',
      address: json['address'] ?? '',
      created: json['created'] ?? Timestamp.now(),
      updated: json['updated'] ?? Timestamp.now(),
      chatrooms: json['chatrooms'] != null
          ? List<String>.from(json['chatrooms'])
          : <String>[],
      accountType: json['accountType'] ?? '',
      appointmentsBooked: json['appointmentsBooked'] != null
          ? List<String>.from(json['appointmentsBooked'])
          : <String>[],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      profileImage: json['profileImage'] ?? '',
      headerImage: json['headerImage'] ?? '',
      accountType: json['accountType'] ?? '',
      address: json['address'] ?? '',
      created: json['created'] ?? Timestamp.now(),
      updated: json['updated'] ?? Timestamp.now(),
      chatrooms: json['chatrooms'] != null
          ? List<String>.from(json['chatrooms'])
          : <String>[],
      appointmentsBooked: json['appointmentsBooked'] != null
          ? List<String>.from(json['chatrooms'])
          : <String>[],
    );
  }

  static Future<UserModel> fromUid({required String uid}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('patients').doc(uid).get();
    return UserModel.fromDocumentSnap(snap);
  }

  static Stream<UserModel> fromUidStream({required String uid}) {
    return FirebaseFirestore.instance
        .collection('patients')
        .doc(uid)
        .snapshots()
        .map(UserModel.fromDocumentSnap);
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'name': name,
        'gender': gender,
        'email': email,
        'dateOfBirth': dateOfBirth,
        'profileImage': profileImage,
        'headerImage': headerImage,
        'accountType': accountType,
        'appointmentsBooked': appointmentsBooked,
        'address': address,
        'created': created,
        'updated': updated,
        'chatrooms': chatrooms,
      };

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        gender,
        dateOfBirth,
        profileImage,
        headerImage,
        accountType,
        appointmentsBooked,
        address,
        created,
        updated,
        chatrooms
      ];
}
