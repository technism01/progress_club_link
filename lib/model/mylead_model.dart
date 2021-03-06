class LeadCategoryModel {
  LeadCategoryModel({
    this.id,
    this.name,
    this.subCategory,
  });

  int? id;
  String? name;
  List<LeadSubCategory>? subCategory;

  factory LeadCategoryModel.fromJson(Map<String, dynamic> json) =>
      LeadCategoryModel(
        id: json["id"],
        name: json["name"],
        subCategory: List<LeadSubCategory>.from(
            json["SubCategory"].map((x) => LeadSubCategory.fromJson(x))),
      );
}

class LeadSubCategory {
  LeadSubCategory({
    this.id,
    this.name,
    this.member,
  });

  int? id;
  String? name;
  List<MyLeadMembers>? member;

  factory LeadSubCategory.fromJson(Map<String, dynamic> json) =>
      LeadSubCategory(
        id: json["id"],
        name: json["name"],
        member: List<MyLeadMembers>.from(
            json["Member"].map((x) => MyLeadMembers.fromJson(x))),
      );
}

class MyLeadMembers {
  MyLeadMembers({
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

  factory MyLeadMembers.fromJson(Map<String, dynamic> json) => MyLeadMembers(
        id: json["id"],
        name: json["name"],
        mobileNumber: json["mobileNumber"],
        pcGroup: json["pcGroup"],
        companyName: json["companyName"],
        profile: json["profile"],
      );
}
