import 'dart:convert';

class SelectedCategoryModel {
  SelectedCategoryModel({
    required this.memberId,
    required this.subCategoryId,
    required this.categoryId,
  });

  int memberId;
  int subCategoryId;
  int categoryId;

  factory SelectedCategoryModel.fromJson(Map<String, dynamic> json) =>
      SelectedCategoryModel(

        memberId: json["memberId"],
        subCategoryId: json["subCategoryId"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {

        "memberId": memberId,
        "subCategoryId": subCategoryId,
        "categoryId": categoryId,
      };

  static Map<String, dynamic> toMap(SelectedCategoryModel music) => {

        "memberId": music.memberId,
        "subCategoryId": music.subCategoryId,
        "categoryId": music.categoryId,
      };

  static String encode(List<SelectedCategoryModel> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>(
                (music) => SelectedCategoryModel.toMap(music))
            .toList(),
      );

  static List<SelectedCategoryModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<SelectedCategoryModel>(
              (item) => SelectedCategoryModel.fromJson(item))
          .toList();
}
