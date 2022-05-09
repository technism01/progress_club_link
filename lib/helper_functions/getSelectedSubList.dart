import 'package:progress_club_link/model/category_model.dart';
import 'package:progress_club_link/providers/category_provider.dart';

List<int> getSelectedSubList({
  required CategoryModel categoryList,
  required List<CategorySubCategoryModel> selectedList,
}) {
  int index =
      selectedList.indexWhere((element) => element.id == categoryList.id);
  if (index == -1) {
    return [];
  } else {
    return selectedList[index].subIdList;
  }
}
