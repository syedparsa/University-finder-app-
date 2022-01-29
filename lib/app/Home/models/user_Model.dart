import 'package:flutter/cupertino.dart';

class EndUser with ChangeNotifier {
  EndUser({
    required this.email,
    this.savedcampIds,
    this.savedHostIds,
  });

  String? email;

  List<String?>? savedcampIds =[];
  List<String?>? savedHostIds = [];

  factory EndUser.fromMap(Map<String, dynamic> data, String documentId) {
    final String email = data['email'];

    final List<String?>? savedcampIds = data['savedcampIds'] != null
        ? (data['savedcampIds'] as List).map((e) => e as String).toList()
        : null;
    final List<String?>? saveduniIds = data['saveduniIds'] != null
        ? (data['saveduniIds'] as List).map((e) => e as String).toList()
        : null;
    return EndUser(
      savedcampIds: savedcampIds,
      savedHostIds: saveduniIds,
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'savedcampIds': savedcampIds,
      'saveduniIds': savedHostIds
    };
  }

  void updateName(String email) => updateWith(email: email);

  void updateWith({
    String? email,
    List<String?>? saveduniIds,
    List<String?>? savedcampIds,
  }) {
    this.email = email ?? this.email;

    this.savedcampIds = savedcampIds ?? this.savedcampIds;
    this.savedHostIds = saveduniIds ?? this.savedHostIds;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndUser &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;

  @override
  String toString() {
    return 'MyUser{email: $email,  savedcampIds: $savedcampIds, saveduniIds: $savedHostIds}';
  }
}
