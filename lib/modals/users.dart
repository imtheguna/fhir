class Users {
  final String memberid;
  final String grpId;
  final String email;
  final List<dynamic> grpmbrlist;
  List<dynamic> applist;

  Users({
    required this.applist,
    required this.email,
    required this.grpId,
    required this.grpmbrlist,
    required this.memberid,
  });

  Map<String, dynamic> toJson() => {
        'memberid': memberid,
        'grpId': grpId,
        'email': email,
        'grpmbrlist': grpmbrlist,
        'applist': applist
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
      grpId: json['grpId'],
      applist: json['applist'],
      email: json['email'],
      grpmbrlist: json['grpmbrlist'],
      memberid: json['memberid']);
}
