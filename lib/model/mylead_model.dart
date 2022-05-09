class Category {
  Category({
    this.id,
    this.name,
    this.subCategory,
  });

  int? id;
  String? name;
  List<SubCategory>? subCategory;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    subCategory: List<SubCategory>.from(json["SubCategory"].map((x) => SubCategory.fromJson(x))),
  );

}

class SubCategory {
  SubCategory({
    this.id,
    this.name,
    this.member,
  });

  int? id;
  String? name;
  List<Member>? member;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    name: json["name"],
    member: List<Member>.from(json["Member"].map((x) => Member.fromJson(x))),
  );


}

class Member {
  Member({
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

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["id"],
    name: json["name"],
    mobileNumber: json["mobileNumber"],
    pcGroup: json["pcGroup"],
    companyName: json["companyName"],
    profile: json["profile"],
  );
}
