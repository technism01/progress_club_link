import 'package:progress_club_link/model/selected_category_model.dart';

class MemberModel {
  int memberId;
  String memberName;
  String mobileNumber;
  String pcGroup;
  String companyName;
  String? email;
  String? profile;
  String token;
  List<SelectedCategoryModel> selected;

  MemberModel(
      {required this.memberName,
      this.email,
      required this.memberId,
      required this.mobileNumber,
      required this.companyName,
      required this.pcGroup,
      this.profile,
      required this.token,required this.selected});

  factory MemberModel.fromJson(Map<String, dynamic> json, String token,List<SelectedCategoryModel> list) =>
      MemberModel(
        memberId: json["id"],
        memberName: json["name"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        pcGroup: json["pcGroup"],
        companyName: json["companyName"],
        token: token,
        selected: list
      );
}
