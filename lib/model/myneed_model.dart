class NeedCategoryModel {
  NeedCategoryModel({
    this.id,
    this.name,
    this.subCategory,
  });

  int? id;
  String? name;
  List<NeedSubCategoryModel>? subCategory;

  factory NeedCategoryModel.fromJson(Map<String, dynamic> json) =>
      NeedCategoryModel(
        id: json["id"],
        name: json["name"],
        subCategory: List<NeedSubCategoryModel>.from(
            json["SubCategory"].map((x) => NeedSubCategoryModel.fromJson(x))),
      );
}

class NeedSubCategoryModel {
  NeedSubCategoryModel({
    this.id,
    this.name,
    this.member,
  });

  int? id;
  String? name;
  List<MyNeedMember>? member;

  factory NeedSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      NeedSubCategoryModel(
        id: json["id"],
        name: json["name"],
        member: List<MyNeedMember>.from(
            json["Member"].map((x) => MyNeedMember.fromJson(x))),
      );
}

class MyNeedMember {
  MyNeedMember({
    this.id,
    this.name,
    this.mobileNumber,
    this.pcGroup,
    this.companyName,
    this.profile,
  });

  int? id;
  String? name;
  String? mobileNumber;
  String? pcGroup;
  String? companyName;
  String? profile;

  factory MyNeedMember.fromJson(Map<String, dynamic> json) => MyNeedMember(
        id: json["id"],
        name: json["name"],
        mobileNumber: json["mobileNumber"],
        pcGroup: json["pcGroup"],
        companyName: json["companyName"],
        profile: json["profile"],
      );
}
