// ignore_for_file: public_member_api_docs, sort_constructors_first

class Status {
  final String uid;
  final String userName;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;

  Status(
      {required this.uid,
      required this.userName,
      required this.phoneNumber,
      required this.photoUrl,
      required this.createdAt,
      required this.profilePic,
      required this.statusId,
      required this.whoCanSee});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: List<String>.from(map['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      profilePic: map['profilePic'] as String,
      statusId: map['statusId'] as String,
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
}
