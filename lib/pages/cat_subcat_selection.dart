import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/common/vertical_tab.dart';
import 'package:progress_club_link/component/loading_component.dart';
import 'package:progress_club_link/helper_functions/SelectedCategoryTOCategorySubCate.dart';
import 'package:progress_club_link/helper_functions/getSelectedSubList.dart';
import 'package:progress_club_link/model/category_model.dart';
import 'package:progress_club_link/providers/category_provider.dart';
import 'package:progress_club_link/widgets/my_textform_field.dart';
import 'package:provider/provider.dart';
import '../common/EmptyScreen.dart';
import '../common/text_styles.dart';
import 'dashboard.dart';
import 'package:page_transition/page_transition.dart';

class CatSubCatSelection extends StatefulWidget {
  final List<CategoryModel> categoryList;
  final List<CategorySubCategoryModel> selectedList;
  final bool isFromDashboard;
  final String title;

  const CatSubCatSelection(
      {Key? key,
      required this.categoryList,
      required this.selectedList,
      required this.title,
      required this.isFromDashboard})
      : super(key: key);

  @override
  State<CatSubCatSelection> createState() => _CatSubCatSelectionState();
}

class _CatSubCatSelectionState extends State<CatSubCatSelection> {
  List<CategorySubCategoryModel> selectedSubCategories = [];

  List<AddCategoryModel> sendList = [];
  bool isEmptyList = true;

  @override
  void initState() {
    if (widget.selectedList.isNotEmpty) {
      selectedSubCategories = widget.selectedList;
    } else {
      selectedSubCategories = List.generate(
          widget.categoryList.length,
          (index) => CategorySubCategoryModel(
              id: widget.categoryList[index].id, subIdList: []));
    }
    if (widget.isFromDashboard) {
      Future.delayed(const Duration(milliseconds: 0)).then((value) {
        loadData();
      });
    }

    super.initState();
  }

  loadData() async {
    await context
        .read<CategoryProvider>()
        .getCategorySubcategory()
        .then((value) {
      if (value.success) {
        if (value.data != null) {
          selectedSubCategories =
              selectedCategoryTOCategorySubCate(value.data!);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(widget.title,
            style: MyTextStyles.semiBold.copyWith(
              fontSize: 16,
            )),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back)),
        actions: [
          if (!isEmptyList || widget.isFromDashboard)
            TextButton(
              onPressed: () {
                if (widget.isFromDashboard) {
                  context
                      .read<CategoryProvider>()
                      .addCategorySubcategory(selectedSubCategories)
                      .then((value) {
                    if (value.success) {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const Dashboard(
                            initialIndex: 1,
                          ),
                        ),
                      );
                    }
                  });
                } else {
                  Navigator.pop(context, selectedSubCategories);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                    color: appPrimaryColor, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      body: context.watch<CategoryProvider>().isLoading
          ? const LoadingComponent()
          : VerticalTabs(
              tabsWidth: size.width * 0.35,
              contentScrollAxis: Axis.horizontal,
              changePageDuration: const Duration(milliseconds: 500),
              indicatorColor: appPrimaryColor,
              dividerColor: Colors.grey,
              selectedTabBackgroundColor: appPrimaryColor.withOpacity(0.1),
              tabs: <Tab>[
                for (int i = 0; i < widget.categoryList.length; i++) ...[
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.categoryList[i].name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (getSelectedSubList(
                                categoryList: widget.categoryList[i],
                                selectedList: selectedSubCategories)
                            .isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: appPrimaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 18,
                            height: 18,
                            alignment: Alignment.center,
                            child: Text(
                              "${getSelectedSubList(categoryList: widget.categoryList[i], selectedList: selectedSubCategories).length}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
              contents: <Widget>[
                for (int i = 0; i < widget.categoryList.length; i++) ...[
                  SubCategoryView(
                    subCategoryList: widget.categoryList[i].subCategory,
                    onSelect: (List<int> list) {
                      setState(() {
                        isEmptyList = true;
                        int index = selectedSubCategories.indexWhere(
                            (element) =>
                                element.id == widget.categoryList[i].id);
                        if (index != -1) {
                          selectedSubCategories[index].subIdList = list;
                        } else {
                          selectedSubCategories.add(CategorySubCategoryModel(
                              id: widget.categoryList[i].id, subIdList: list));
                        }
                      });
                      for (var element in selectedSubCategories) {
                        if (element.subIdList.isNotEmpty) {
                          setState(() {
                            isEmptyList = false;
                          });
                        }
                      }
                    },
                    selectedList: getSelectedSubList(
                        categoryList: widget.categoryList[i],
                        selectedList: selectedSubCategories),
                    // selectedList: selectedSubCategories[i].subCategory,
                  ),
                ]
              ],
            ),
    );
  }
}

class SubCategoryView extends StatefulWidget {
  final List<SubCategoryModel> subCategoryList;
  final Function(List<int>) onSelect;
  final List<int> selectedList;

  const SubCategoryView(
      {Key? key,
      required this.subCategoryList,
      required this.onSelect,
      required this.selectedList})
      : super(key: key);

  @override
  State<SubCategoryView> createState() => _SubCategoryViewState();
}

class _SubCategoryViewState extends State<SubCategoryView> {
  List<int> selectedList = [];
  TextEditingController searchText = TextEditingController();
  final List<SubCategoryModel> searchedCategoryList = [];

  @override
  void initState() {
    super.initState();
    selectedList = widget.selectedList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyTextFormField(
            onChanged: onSearch,
            contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            icon: const Icon(
              CupertinoIcons.search,
              color: Colors.grey,
              size: 20,
            ),
            hintText: "Search Category you want",
          ),
        ),
        Expanded(
            child: widget.subCategoryList.isNotEmpty
                ? searchedCategoryList.isNotEmpty || searchText.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchedCategoryList.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: selectedList
                                .contains(searchedCategoryList[index].id),
                            activeColor: appPrimaryColor,
                            dense: true,
                            contentPadding: const EdgeInsets.only(left: 6),
                            title: Text(
                              searchedCategoryList[index].name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              if (value != null) {
                                if (value) {
                                  setState(() {
                                    selectedList
                                        .add(searchedCategoryList[index].id);
                                  });
                                } else {
                                  setState(() {
                                    selectedList
                                        .remove(searchedCategoryList[index].id);
                                  });
                                }
                                widget.onSelect(selectedList);
                              }
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: widget.subCategoryList.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: selectedList
                                .contains(widget.subCategoryList[index].id),
                            activeColor: appPrimaryColor,
                            dense: true,
                            contentPadding: const EdgeInsets.only(left: 6),
                            title: Text(
                              widget.subCategoryList[index].name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              if (value != null) {
                                if (value) {
                                  setState(() {
                                    selectedList
                                        .add(widget.subCategoryList[index].id);
                                  });
                                } else {
                                  setState(() {
                                    selectedList.remove(
                                        widget.subCategoryList[index].id);
                                  });
                                }
                                widget.onSelect(selectedList);
                              }
                            },
                          );
                        },
                      )
                : const EmptyScreen(
                    title: "No Subcategory Available",
                    image: "assets/images/nosearchfound.png"))
      ],
    );
  }

  onSearch(String text) async {
    searchedCategoryList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var subcategory in widget.subCategoryList) {
      if (subcategory.name.toLowerCase().contains(text.toLowerCase())) {
        searchedCategoryList.add(subcategory);
      }
    }
    setState(() {});
  }
}
