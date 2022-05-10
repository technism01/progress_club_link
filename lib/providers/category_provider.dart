import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/model/category_model.dart';
import 'package:progress_club_link/model/response_model.dart';
import 'package:progress_club_link/model/selected_category_model.dart';

Dio dio = Dio();

class CategoryProvider extends ChangeNotifier {
  bool isLoading = true;

  /*Get Category SubCategory*/
  Future<ResponseClass<List<CategoryModel>>> getCategory() async {
    String _url = StringConstants.apiUrl + StringConstants.category;

    //Response
    ResponseClass<List<CategoryModel>> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        _url,
        options: Options(validateStatus: (status) {
          return status == 404 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        List temp = response.data["data"];
        responseClass.data = List<CategoryModel>.from(
            temp.map((e) => CategoryModel.fromJson(e)));
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 404) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message,webBgColor:
        "linear-gradient(to right, #5A5A5A, #5A5A5A)");
        isLoading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage,webBgColor:
      "linear-gradient(to right, #5A5A5A, #5A5A5A)");
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("login error ->" + e.toString());
      }
      return responseClass;
    }
  }

  /*Add Category SubCategory*/
  Future<ResponseClass> addCategorySubcategory(
      List<CategorySubCategoryModel> addList) async {
    String _url = StringConstants.apiUrl + StringConstants.categoryAdd;

    List<AddCategoryModel> addCategoryModel = [];

    addList.forEach((element) {
      element.subIdList.forEach((value) {
        addCategoryModel.add(AddCategoryModel(
            memberId: sharedPrefs.memberId,
            categoryId: element.id,
            subCategoryId: value));
      });
    });

    var data = {"memberId": sharedPrefs.memberId, "requests": addCategoryModel};

    //Response
    ResponseClass responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        _url,
        data: data,
        options: Options(validateStatus: (status) {
          return status == 400 || status == 201;
        }),
      );
      if (response.statusCode == 201) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message,webBgColor:
        "linear-gradient(to right, #5A5A5A, #5A5A5A)");
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 400) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message,webBgColor:
        "linear-gradient(to right, #5A5A5A, #5A5A5A)");
        isLoading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage,webBgColor:
      "linear-gradient(to right, #5A5A5A, #5A5A5A)");
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("add requirement error ->" + e.toString());
      }
      return responseClass;
    }
  }

  /*get Category SubCategory dash*/
  Future<ResponseClass<List<SelectedCategoryModel>>>
      getCategorySubcategory() async {
    String _url = StringConstants.apiUrl + StringConstants.request;

    var data = {"memberId": sharedPrefs.memberId};

    //Response
    ResponseClass<List<SelectedCategoryModel>> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        _url,
        queryParameters: data,
        options: Options(validateStatus: (status) {
          return status == 404 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        List temp = response.data["data"];
        List<SelectedCategoryModel> list = List<SelectedCategoryModel>.from(
            temp.map((e) => SelectedCategoryModel.fromJson(e)));
        responseClass.data = list;
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 400) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message,webBgColor:
        "linear-gradient(to right, #5A5A5A, #5A5A5A)");
        isLoading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage,webBgColor:
      "linear-gradient(to right, #5A5A5A, #5A5A5A)");
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("get Category SubCategory dash error ->" + e.toString());
      }
      return responseClass;
    }
  }
}

class CategorySubCategoryModel {
  int id;
  List<int> subIdList;

  CategorySubCategoryModel({required this.id, required this.subIdList});
}

class AddCategoryModel {
  AddCategoryModel({
    required this.memberId,
    required this.categoryId,
    required this.subCategoryId,
  });

  int memberId;
  int categoryId;
  int subCategoryId;

  factory AddCategoryModel.fromJson(Map<String, dynamic> json) =>
      AddCategoryModel(
        memberId: json["memberId"],
        categoryId: json["categoryId"],
        subCategoryId: json["subCategoryId"],
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
      };
}
