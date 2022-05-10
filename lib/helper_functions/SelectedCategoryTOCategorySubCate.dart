import 'package:progress_club_link/model/selected_category_model.dart';
import 'package:progress_club_link/providers/category_provider.dart';

List<CategorySubCategoryModel> selectedCategoryTOCategorySubCate(
    List<SelectedCategoryModel> list) {
  List<CategorySubCategoryModel> returnList = [];

  list.forEach((element) {
    int index =
        returnList.indexWhere((value) => value.id == element.categoryId);
    if (index != -1) {
      returnList.elementAt(index).subIdList.add(element.subCategoryId);
    } else {
      returnList.add(CategorySubCategoryModel(
          id: element.categoryId, subIdList: [element.subCategoryId]));
    }
  });

  return returnList;
}
