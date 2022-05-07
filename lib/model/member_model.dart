class MemberModel {
  int memberId;
  String memberName;
  String mobileNumber;
  String pcGroup;
  String companyName;
  String? email;
  String? profile;
  List<int> subCategoryIds;
  String token;

  MemberModel(
      {required this.memberName,
      this.email,
      required this.memberId,
      required this.mobileNumber,
      required this.companyName,
      required this.pcGroup,
      this.profile,
      required this.subCategoryIds,
      required this.token});

  factory MemberModel.fromJson(Map<String, dynamic> json, String token) =>
      MemberModel(
        memberId: json["id"],
        memberName: json["name"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        pcGroup: json["pcGroup"],
        companyName: json["companyName"],
        subCategoryIds: json["subCategoryIds"],
        token: token,
      );
}
