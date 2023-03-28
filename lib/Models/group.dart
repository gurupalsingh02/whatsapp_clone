class Group {
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final DateTime timeSent;

  Group(
      {required this.timeSent,
      required this.name,
      required this.groupId,
      required this.lastMessage,
      required this.groupPic,
      required this.membersUid});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      groupPic: map['groupPic'] as String,
      membersUid: List<String>.from(map['membersUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}
