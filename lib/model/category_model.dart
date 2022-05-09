

class Category {
  int? id;
  String? name;
  List<SubCategory>? subCategory;

  Category({this.id, this.name, this.subCategory});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      subCategory:json["subCategory"] == null ? null : List<SubCategory>.from(json["subCategory"].map((data) => SubCategory.fromJson(data))),
    );
  }
}

class SubCategory {
  int? id;
  String? name;
  int? categoryId;

  SubCategory({this.id, this.name, this.categoryId});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
  }
}
