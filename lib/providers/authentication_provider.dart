import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/model/member_model.dart';
import 'package:progress_club_link/model/response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_club_link/model/selected_category_model.dart';

Dio dio = Dio();

class AuthenticationProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<ResponseClass<MemberModel>> registerUser({
    required FormData data,
  }) async {
    String _url = StringConstants.apiUrl + StringConstants.signup;

    //Response
    ResponseClass<MemberModel> responseClass = ResponseClass(
      success: false,
      message: "Something went wrong.Please try again",
    );

    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        _url,
        data: data,
        options: Options(validateStatus: (status) {
          return status == 409 || status == 201 || status == 400;
        }),
      );

      if (response.statusCode == 201) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        List temp = response.data["mySubCategory"];
        List<SelectedCategoryModel> list = List<SelectedCategoryModel>.from(
            temp.map((e) => SelectedCategoryModel.fromJson(e)));
        responseClass.data = MemberModel.fromJson(response.data["data"], list);
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 409) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        responseClass.data = null;
        Fluttertoast.showToast(msg: responseClass.message);
        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 400) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        responseClass.data = null;
        Fluttertoast.showToast(msg: responseClass.message);
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
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("registerUser error ->" + e.toString());
      }
      return responseClass;
    }
  }

  /*login user*/
  Future<ResponseClass<MemberModel>> loginUser(
      {required String mobileNo}) async {
    String _url = StringConstants.apiUrl + StringConstants.login;

    //body Data
    var data = {
      "mobileNumber": mobileNo,
    };

    //Response
    ResponseClass<MemberModel> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        _url,
        data: data,
        options: Options(validateStatus: (status) {
          return status == 404 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        List temp = response.data["mySubCategory"];
        List<SelectedCategoryModel> list = List<SelectedCategoryModel>.from(
            temp.map((e) => SelectedCategoryModel.fromJson(e)));

        responseClass.data = MemberModel.fromJson(response.data["data"], list);
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 404) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message);
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
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
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

  /*update user*/
  Future<ResponseClass<MemberModel>> updateUserProfile(
      {required FormData formData}) async {
    String _url = StringConstants.apiUrl + StringConstants.update;

    //Response
    ResponseClass<MemberModel> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.patch(
        _url,
        data: formData,
        options: Options(validateStatus: (status) {
          return status == 400 || status == 409 || status == 200;
        }),
      );
      log("-> ${response.statusCode}");
      if (response.statusCode == 200) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        List temp = response.data["mySubCategory"];
        List<SelectedCategoryModel> list = List<SelectedCategoryModel>.from(
            temp.map((e) => SelectedCategoryModel.fromJson(e)));
        responseClass.data = MemberModel.fromJson(response.data["data"], list);
        isLoading = false;
        notifyListeners();
        Fluttertoast.showToast(msg: responseClass.message);
        return responseClass;
      }
      if (response.statusCode == 400) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message);
        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 409) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message);
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
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("update error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
