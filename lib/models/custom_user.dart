// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomUser {
  final String id;
  final int maxScore;
  final String maxScoreDate;
  final String signUpDate;
  final String username;
  final String email;
  CustomUser({
    required this.id,
    required this.email,
    required this.maxScore,
    required this.maxScoreDate,
    required this.signUpDate,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'maxScore': maxScore,
      'maxScoreDate': maxScoreDate,
      'signUpDate': signUpDate,
      'username': username,
      'email': email,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      id: map['id'] as String,
      maxScore: map['maxScore'] as int,
      maxScoreDate: map['maxScoreDate'] as String,
      signUpDate: map['signUpDate'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  CustomUser copyWith({
    String? id,
    int? maxScore,
    String? maxScoreDate,
    String? signUpDate,
    String? username,
    String? email,
  }) {
    return CustomUser(
      id: id ?? this.id,
      maxScore: maxScore ?? this.maxScore,
      maxScoreDate: maxScoreDate ?? this.maxScoreDate,
      signUpDate: signUpDate ?? this.signUpDate,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}
