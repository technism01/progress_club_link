import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/common/vertical_tab.dart';

class CatSubCatSelection extends StatefulWidget {
  final List<List> selectedList;

  const CatSubCatSelection({Key? key, required this.selectedList})
      : super(key: key);

  @override
  State<CatSubCatSelection> createState() => _CatSubCatSelectionState();
}

class _CatSubCatSelectionState extends State<CatSubCatSelection> {
  List list = [
    {
      "categoryName": "IT & Software",
      "subCategoryList": [
        {
          "id": 1,
          "name": "Mobile Software",
        },
        {
          "id": 2,
          "name": "Web Software",
        },
        {
          "id": 3,
          "name": "UI/UX Designing",
        }
      ]
    },
    {
      "categoryName": "Taxtile",
      "subCategoryList": [
        {
          "id": 4,
          "name": "Less Material",
        },
        {
          "id": 5,
          "name": "Embroidery Machine",
        },
      ]
    }
  ];

  List<List> selectedSubCategories = [[], []];
  bool isEmptyList = true;

  @override
  void initState() {
    super.initState();
    if (widget.selectedList.isNotEmpty) {
      selectedSubCategories = widget.selectedList;
      isEmptyList = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Profession"),
        actions: [
          if (!isEmptyList)
            TextButton(
              onPressed: () {
                Navigator.pop(context, selectedSubCategories);
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
          for (int i = 0; i < list.length; i++) ...[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${list[i]["categoryName"]}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (selectedSubCategories[i].isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: appPrimaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      child: Text(
                        "${selectedSubCategories[i].length}",
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
          for (int i = 0; i < list.length; i++) ...[
            SubCategoryView(
              subCategoryList: list[i]["subCategoryList"],
              onSelect: (List list) {
                setState(() {
                  isEmptyList = true;
                  selectedSubCategories[i] = list;
                });
                for (var element in selectedSubCategories) {
                  if (element.isNotEmpty) {
                    setState(() {
                      isEmptyList = false;
                    });
                  }
                }
              },
              selectedList: selectedSubCategories[i],
            ),
          ]
        ],
      ),
    );
  }
}

class SubCategoryView extends StatefulWidget {
  final List subCategoryList;
  final Function(List) onSelect;
  final List selectedList;

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
  List selectedList = [];

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
          value:
              selectedList.contains("${widget.subCategoryList[index]["id"]}"),
          activeColor: appPrimaryColor,
          dense: true,
          contentPadding: const EdgeInsets.only(left: 6),
          title: Text(
            "${widget.subCategoryList[index]["name"]}",
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
                  selectedList.add("${widget.subCategoryList[index]["id"]}");
                });
              } else {
                setState(() {
                  selectedList.remove("${widget.subCategoryList[index]["id"]}");
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
