import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/common/vertical_tab.dart';
import 'package:progress_club_link/helper_functions/SelectedCategoryTOCategorySubCate.dart';
import 'package:progress_club_link/helper_functions/getSelectedSubList.dart';
import 'package:progress_club_link/model/category_model.dart';
import 'package:progress_club_link/providers/category_provider.dart';
import 'package:provider/provider.dart';

import '../common/text_styles.dart';

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
        title: Text(widget.title,
            style: MyTextStyles.semiBold.copyWith(
              fontSize: 16,
            )),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back)),
        actions: [
          if (!isEmptyList)
            TextButton(
              onPressed: () {
                if (widget.isFromDashboard) {
                  context
                      .read<CategoryProvider>()
                      .addCategorySubcategory(selectedSubCategories)
                      .then((value) {
                    if (value.success) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
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
      body: VerticalTabs(
        tabsWidth: size.width * 0.34,
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
                      (element) => element.id == widget.categoryList[i].id);
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

  @override
  void initState() {
    super.initState();
    selectedList = widget.selectedList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.subCategoryList.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          value: selectedList.contains(widget.subCategoryList[index].id),
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
                  selectedList.add(widget.subCategoryList[index].id);
                });
              } else {
                setState(() {
                  selectedList.remove(widget.subCategoryList[index].id);
                });
              }
              widget.onSelect(selectedList);
            }
          },
        );
      },
    );
  }
}
