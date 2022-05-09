class CategoryModel {
  int id;
  String name;
  List<SubCategoryModel> subCategory;

  CategoryModel(
      {required this.id, required this.name, required this.subCategory});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      subCategory: List<SubCategoryModel>.from(
          json["subCategory"].map((data) => SubCategoryModel.fromJson(data))),
    );
  }
}

class SubCategoryModel {
  int id;
  String name;
  int categoryId;

  SubCategoryModel(
      {required this.id, required this.name, required this.categoryId});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
        id: json['id'], name: json['name'], categoryId: json['categoryId']);
  }
}
